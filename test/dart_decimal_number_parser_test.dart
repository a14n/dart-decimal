import 'package:decimal/dart_decimal_number_parser.dart';
import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

Decimal? parse(NumberFormat format, String text) => Decimal.parseWith(format, text);

Decimal rationalPi = Decimal.parse('3.14');
NumberFormat plainFormatter = NumberFormat();
NumberFormat currencyFormatter = NumberFormat.simpleCurrency(name: 'USD');

final parserGenerator = DartDecimalNumberParser.new;

void main() {
  group('Parses plain decimals', () {
    test('Can parse plain decimal', () {
      expect(parse(plainFormatter, '3.14'), equals(rationalPi));
      expect(parse(plainFormatter, '03.14'), equals(rationalPi));
      expect(parse(plainFormatter, '-3.14'), equals(-rationalPi));
    });
  });

  group('Parses currency decimals', () {
    test('Can parse currency decimal', () {
      expect(parse(currencyFormatter, '\$3.14'), equals(rationalPi));
      expect(parse(currencyFormatter, '\$03.14'), equals(rationalPi));
      expect(parse(currencyFormatter, '-\$3.14'), equals(-rationalPi));
    });
  });

  group('Use custom parser syntax', () {
    group('Parses plain decimals', () {
      test('Can parse plain decimal', () {
        expect(plainFormatter.parseWith(parserGenerator, '3.14'), equals(rationalPi));
        expect(plainFormatter.parseWith(parserGenerator, '03.14'), equals(rationalPi));
        expect(plainFormatter.parseWith(parserGenerator, '-3.14'), equals(-rationalPi));
      });
    });

    group('Parses currency decimals', () {
      test('Can parse currencies decimal', () {
        expect(currencyFormatter.parseWith(parserGenerator, '\$3.14'), equals(rationalPi));
        expect(currencyFormatter.parseWith(parserGenerator, '\$03.14'), equals(rationalPi));
        expect(currencyFormatter.parseWith(parserGenerator, '-\$3.14'), equals(-rationalPi));
      });
    });
  });
}