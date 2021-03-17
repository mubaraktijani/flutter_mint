import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../interface/orm.dart';

class AppDatabase {

	AppDatabase._();

	static Future<Database> init(String name, {
		int version: 1,
		List<ORM> onCreateScripts: const [],
		List<String> onUpgradeScripts: const []
	}) async {
		String databasesPath = await getDatabasesPath() as String;
		String dbPath = join(databasesPath, name);

		return openDatabase(
			dbPath,
			version: version,
			onCreate: (Database db, int version) async {
				(onCreateScripts).forEach(
					(script) async => await db.execute(script.createTable)
				);
			},
			onUpgrade: (Database db, int oldVersion, int newVersion) async {
				for (var i = oldVersion - 1; i < newVersion - 1; i++) {
					await db.execute(onUpgradeScripts[i]);
				} 
			}
		);
	}
}