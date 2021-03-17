library flutter_mint;

import 'dart:io' as io;

import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:futuristic/futuristic.dart';
import 'package:cached_network_image/cached_network_image.dart';


class MintImage extends StatelessWidget {

	final String? path;
	final BoxFit? fit;
	final double? height;
	final double? width;
	final double? borderRadius;

	MintImage(this.path, {
		this.fit, 
		this.height, 
		this.width, 
		this.borderRadius
	});

	@override
	Widget build(BuildContext context) => ClipRRect(
		borderRadius: BorderRadius.circular(this.borderRadius ?? 0),
		child: (_isNetworkImage)
			? CachedNetworkImage(
				imageUrl: this.path,
				fit: this.fit,
				height: this.height,
				width: this.width,
				alignment: Alignment.topCenter,
				placeholder: (_, __) => _shimmer(
					enabled: true,
					height: this.height ?? double.infinity
				),
				errorWidget: (_, __, ___) => _shimmer(
					enabled: false,
					height: this.height ?? double.infinity
				)
			)
			: Futuristic<bool>(
				autoStart: true,
				futureBuilder: io.File('assets/${this.path}').exists,
				busyBuilder: (_) => _shimmer(
					enabled: true,
					height: height ?? double.infinity
				),
				errorBuilder: (_, e, c) => InkWell(
					onTap: c,
					child: _shimmer(
						enabled: false,
						height: this.height ?? double.infinity
					)
				),
				dataBuilder: (_, exists) => (exists)
					? Image.asset(
						'assets/${this.path}',
						fit: this.fit,
						height: this.height,
						width: this.width
					)
					: _shimmer(
						enabled: false,
						height: this.height ?? double.infinity
					)
			)
	);

	bool get _isNetworkImage => (
		this.path != null && 
		(this.path!.contains('//') || this.path!.contains('http'))
	);

	Widget _shimmer({bool enabled: true, double? height}) => Shimmer.fromColors(
		baseColor: Colors.grey[200],
		highlightColor: Colors.grey[50],
		enabled: enabled,
		direction: ShimmerDirection.ttb,
		child: Container(
			color: Colors.grey,
			height: height
		)
	);
}