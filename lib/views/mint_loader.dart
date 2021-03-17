library flutter_mint;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class MintLoader extends StatelessWidget{

	@override
	Widget build(BuildContext context) => Column(
		mainAxisSize: MainAxisSize.max,
		mainAxisAlignment: MainAxisAlignment.center,
		crossAxisAlignment: CrossAxisAlignment.center,
		children: [
			SpinKitChasingDots(
				color: context.primaryColor,
				size: context.screenWidth * 0.08,
			)
		]
	);

	static Future dialog(BuildContext context) => showDialog(
		context: context,
		barrierDismissible: false,
		builder: (_) => Container(
			child: Text('Loading...'),
		)
	);
}

class MintErrorView extends StatelessWidget {

	final Object? error;
	final Function()? voidCallback;

	MintErrorView({this.error, this.voidCallback});

	@override
	Widget build(BuildContext context) => Container(
		width: double.infinity,
		child: Column(
			mainAxisSize: MainAxisSize.max,
			mainAxisAlignment: MainAxisAlignment.center,
			crossAxisAlignment: CrossAxisAlignment.center,
			children: [
				Icon(
					CupertinoIcons.exclamationmark_triangle,
				)
				.iconSize(50)
				.pOnly(bottom: 30),

				'Oops! An error occurred while\n processing your request'
					.text
					.size(22)
					.align(TextAlign.center)
					.textStyle(context.textTheme.headline3)
					.lineHeight(1.1)
					.make()
					.pOnly(bottom: 15),

				'${this.error}'
					.text
					.size(14)
					.color(Colors.red.shade400)
					.align(TextAlign.center)
					.fontWeight(FontWeight.w200)
					.textStyle(context.textTheme.bodyText1)
					.make()
					.pOnly(bottom: 10),

				OutlineButton(
					onPressed: this.voidCallback,
					shape: RoundedRectangleBorder(
						side: BorderSide(
							color: context.primaryColor,
							width: 1,
							style: BorderStyle.solid
						)
					),
					child: Row(
						mainAxisAlignment: MainAxisAlignment.center,
						children: [
							Icon(SimpleLineIcons.reload)
								.iconSize(14)
								.iconColor(context.primaryColor)
								.pOnly(right: 5),
							'Reload'
								.text
								.size(14)
								.color(context.primaryColor)
								.align(TextAlign.center)
								.textStyle(context.textTheme.button)
								.make()
						]
					) 
				).wOneThird(context)
			]
		)
	);
}