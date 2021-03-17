import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Service {

	String get baseUrl;
	Future<SharedPreferences> get session => SharedPreferences.getInstance();
	
	Dio get http {
		Dio dio = new Dio();

		dio.options.baseUrl = baseUrl;
		dio.options.connectTimeout = 20000;
		dio.options.receiveTimeout = 20000;

		return dio;
	}
}