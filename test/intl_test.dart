library tests;

import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:expector/expector.dart';
import 'package:intl/intl.dart';
import 'package:test/test.dart' show test;

Decimal dec(String value) => Decimal.parse(value);

void main() {
  test('Number.format output the same result as with double', () {
    final formats = <NumberFormat>[
      NumberFormat.decimalPattern('en-US'),
      NumberFormat.decimalPattern('fr-FR'),
    ];
    final numbers = <String>[
      '0',
      '1',
      '-1.123',
      '123456789.0123',
    ];
    for (var format in formats) {
      for (var number in numbers) {
        expectThat(format.format(DecimalIntl(Decimal.parse(number))))
            .equals(format.format(double.parse(number)));
      }
    }
  });
}
