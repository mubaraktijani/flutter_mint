import 'package:sqflite/sqlite_api.dart';

abstract class ORM<T> {
	String _where = '';
	List<dynamic> _whereArgs = [];

	int id = 0;
	String get tableName;
	String get createTable;
	Future<Database> get db;
	Map<String, dynamic> get toJson;

	set where(String newValue) => _where = newValue;
	set whereArgs(List<dynamic> newValue) => _whereArgs = newValue;

	T fromDB(Map<String, dynamic> json);

	Future<List<T>> get all async {
		return db.then((_db) async {
			var rows = await _db.query(
				tableName
			);

			if (_db.isOpen) await _db.close();

			return (rows.length > 0)
				? rows.map((e) => fromDB(e)).toList()
				: [];
		});
	}

	Future<T> exist() async {
		return db.then((_db) async {

			var rows = await _db.query(
				tableName, 
				limit: 1, 
				where: _where,
				whereArgs: _whereArgs
			);

			if (_db.isOpen) await _db.close();

			return (rows.length > 0)
				? fromDB(rows.first)
				: null as T;
		});
	}

	Future<T> find(int id) async {
		return db.then((_db) async {
			var params = [];
			var conditions;

			if (id != 0) {
				conditions += 'id = ?';
				params.add(id);
			}

			if (id != 0 && _where.isNotEmpty) 
				conditions += 'AND $_where';

			if (_where.isNotEmpty) params.addAll(_whereArgs);

			var rows = await _db.query(
				tableName, 
				limit: 1, 
				where: conditions,
				whereArgs: params
			);

			if (_db.isOpen) await _db.close();

			return (rows.length > 0)
				? fromDB(rows.first)
				: null as T;
		});
	}

	Future<int> save() async {
		return db.then((_db) async {
			Map<String, dynamic> data = toJson;
			if (data.containsKey('id')) data.remove('id');

			int _id = await _db.insert(
				tableName, 
				data, 
				conflictAlgorithm: ConflictAlgorithm.replace
			);

			if (_db.isOpen) await _db.close();

			return _id;
		});
	}

	Future<int> update() async {
		return db.then((_db) async {

			int _id = await _db.update(
				tableName, 
				toJson, 
				where: _where, 
				whereArgs: _whereArgs,
				conflictAlgorithm: ConflictAlgorithm.replace
			);

			if (_db.isOpen) await _db.close();

			return _id;
		});
	}

	Future<void> remove() async {
		return db.then((_db) async {
			await _db.delete(
				tableName, 
				where: _where, 
				whereArgs: _whereArgs,
			);

			if (_db.isOpen) await _db.close();
		});
	}

	Future<void> insert(List<Map<String, dynamic>> data) async {
		return db.then((_db) async {

			await _db.transaction((transaction) async {
				var batch = transaction.batch();

				data.forEach((row) {
					batch.insert(
						tableName, 
						row, 
						conflictAlgorithm: ConflictAlgorithm.replace
					);
				});
				
				await batch.commit();
			});

			if (_db.isOpen) await _db.close();
		});
	}
	
	Future<void> empty(List<Map<String, dynamic>> data) async {
		return db.then((_db) async {
			await _db.delete(tableName);

			if (_db.isOpen) await _db.close();
		});
	}
}