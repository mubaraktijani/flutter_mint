library flutter_mint;

import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'helpers/error_handler.dart';
import 'helpers/functions.dart';

export 'views/mint_loader.dart';
export 'views/mint_image.dart';
export 'views/mint_password.dart';

class FlutterMintApp {

	final bool? debugShowCheckedModeBanner;
	final Widget? home;
	final String? title;
	final ThemeData Function(BuildContext)? theme;
	final List<SingleChildWidget>? providers;
	final Map<String, dynamic>? routes;
	final Function(BuildContext)? onBody;

	/// Error Handler sertings
	final String? sentryClientDNS;
	final EmailAutoHandler? errorEmailHandler;

	FlutterMintApp({
		this.routes,
		this.home, 
		this.title, 
		this.theme, 
		this.onBody,
		this.providers,
		this.sentryClientDNS,
		this.errorEmailHandler,
		this.debugShowCheckedModeBanner: false, 
	});

	dynamic get run => initErrorHandler(
		_widget(),
		sentryDNS: this.sentryClientDNS,
		emailHandler: this.errorEmailHandler
	);

	Widget _widget() => MintApp(
		home: this.home,
		title: this.title ?? 'Muraki Flutter',
		theme: this.theme,
		routes: this.routes,
		onBody: this.onBody,
		providers: this.providers,
		debugShowCheckedModeBanner: this.debugShowCheckedModeBanner
	);
}

class MintApp extends StatelessWidget {

	final bool? debugShowCheckedModeBanner;
	final Widget? home;
	final String? title;
	final ThemeData Function(BuildContext)? theme;
	final List<SingleChildWidget>? providers;
	final Map<String, dynamic>? routes;
	final Function(BuildContext)? onBody;

	MintApp({
		this.home, 
		this.title, 
		this.routes,
		this.theme, 
		this.onBody,
		this.providers,
		this.debugShowCheckedModeBanner, 
	});
	
	@override
	Widget build(BuildContext context) {
		if(onBody != null) onBody!(context);

		return (this.providers != null && this.providers!.length > 0)
			? MultiProvider(
				providers: this.providers!,
				builder: (context, child) => _onBuild(context)
			)
			: _onBuild(context);
	}

	Widget _onBuild(context) => MaterialApp(
		home: this.home,
		title: this.title ?? "Mint Flutter",
		theme: this.theme != null ? this.theme!(context) : null,
		builder: materialAppBuilder,
		themeMode: ThemeMode.light,
		// navigatorKey: Catcher.navigatorKey,
		onGenerateRoute: (settings) => onGenerateRoute(settings, this.routes ?? {}),
		debugShowCheckedModeBanner: false
	);
}
