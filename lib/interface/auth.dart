import 'dart:convert';

import 'service.dart';
import 'package:velocity_x/velocity_x.dart';
import '../helpers/jwt_decode.dart';

abstract class AuthService<Model> extends Service{

	bool validateToken = true;

	String _authSessionKey = '__user_auth__';
	String _authTokenSessionKey = '__user_auth_token__';

	void store({required Map<String, dynamic> obj, String? token}) async {
		var session = await this.session;

		if (validateToken && token != null && Jwt.isExpired(token)) 
			throw('Invalid token or token expired.');

		if (token != null) 
			await session.setString(_authTokenSessionKey, token);

		await session.setString(_authSessionKey, json.encode(obj));
	}

	Future<bool> get isLoggedIn async {
		var session = await this.session;

		var user = session.getString(_authSessionKey);

		if(!(await getAuthToken).isEmptyOrNull && !user.isEmptyOrNull)
			return true;

		return false;
	}

	Future<dynamic?> get getAuthUser async{
		var session = await this.session;

		var user = session.getString(_authSessionKey);

		if(!(await getAuthToken).isEmptyOrNull && !user.isEmptyOrNull)
			return json.decode(user!);

		return null;
	}

	Future<String?> get getAuthToken async{
		var session = await this.session;
		var token = session.getString(_authTokenSessionKey);

		if (validateToken && token != null && !Jwt.isExpired(token))
			return token;

		if (!validateToken && !token.isEmptyOrNull)
			return token;

		if (!validateToken && token.isEmptyOrNull)
			return 'invalid_token';

		return null;
	}

	dynamic onLogin(Object params);
	
	dynamic onRegister(Object params);

	dynamic onForgotPassword(String email);
}