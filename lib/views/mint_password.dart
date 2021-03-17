library flutter_mint;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:velocity_x/velocity_x.dart';

class MintPassword extends StatefulWidget {

	final String? hint, error;
	final double iconSize;
	final InputDecoration? decoration;
	final Function(String?)? onSaved;
	final TextEditingController? textController;

	MintPassword({
		this.decoration, this.hint, this.error, 
		this.onSaved, this.textController, this.iconSize: 13
	});

	@override
	_MintPasswordState createState() => _MintPasswordState();
}

class _MintPasswordState extends State<MintPassword> {
	bool _obscureText = true;

	@override
	Widget build(BuildContext context) => TextFormField(
		obscureText: _obscureText,
		onSaved: widget.onSaved,
		controller: widget.textController,
		validator: (val) => widget.error != null && val!.isEmptyOrNull
			? widget.error
			: null,
		keyboardType: TextInputType.visiblePassword,
		decoration: (widget.decoration ?? InputDecoration()).copyWith(
			hintText: widget.hint,
			suffixIcon: IconButton(
				icon: Icon(
					_obscureText
						? CupertinoIcons.eye_slash
						: CupertinoIcons.eye
				).iconSize(widget.iconSize),
				onPressed: () => setState(
					() => _obscureText = !_obscureText
				)
			)
		)
	);
}