import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';

Catcher initErrorHandler(Widget _appWidget, {
	EmailAutoHandler? emailHandler, String? sentryDNS
}) {
	CatcherOptions debugOptions = CatcherOptions(
		DialogReportMode(), 
		[
			ConsoleHandler(
				enableApplicationParameters: false,
				enableDeviceParameters: false,
				enableCustomParameters: false,
				enableStackTrace: false
			)
		]
	);
	
	CatcherOptions releaseOptions = CatcherOptions(
		DialogReportMode(), 
		[
			EmailManualHandler(
				["support@email.com"]
			)
		]
	);

	return Catcher(
		_appWidget, 
		debugConfig: debugOptions, 
		releaseConfig: releaseOptions
	);
}