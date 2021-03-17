import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';

String parseHtmlString(String htmlString) {
	final document = parse(htmlString);
	final String parsedString = parse(document.body!.text).documentElement!.text;

	return parsedString;
}

String removeAllHtmlTags(String htmlText) {
	RegExp exp = RegExp(
		r"<[^>]*>",
		multiLine: true,
		caseSensitive: true
	);

	return htmlText.replaceAll(exp, '');
}

onGenerateRoute(RouteSettings settings, Map<String, dynamic> routes) {
	return MaterialPageRoute(
		builder: (BuildContext context) {
			dynamic arg = settings.arguments;
			return routes[settings.name](arg);
		},
		maintainState: true,
		fullscreenDialog: false,
	);
}

Widget materialAppBuilder(BuildContext context, Widget? widget) {
	Catcher.addDefaultErrorWidget(
		showStacktrace: true,
		title: "Custom error title",
		description: "Custom error description",
		maxWidthForSmallMode: 150
	);

	return widget!;
}

Future<Uint8List> getImageBytes(String url, {
		Function(int received, int total)? onProgress
}) async {
	return Dio().get(
			url,
			onReceiveProgress: (onProgress != null) 
				? onProgress
				: (received, total) {
					if (total != -1) {
						return (received / total * 100).floorToDouble() as dynamic;
					}
					return 0.0 as dynamic;
				},
			options: Options(
				responseType: ResponseType.bytes,
				followRedirects: false,
			)
		)
		.then((Response res) => Uint8List.fromList(res.data));
}