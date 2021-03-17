import 'package:flutter_test/flutter_test.dart';

import '../lib/flutter_mint.dart';

void main() {
	test('adds one to input values', () {
		final calculator = FlutterMintApp(
			routes: {}
		);
		calculator.run;
	});
}
