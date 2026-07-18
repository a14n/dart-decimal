import 'package:decimal/decimal.dart';
import 'package:rational/rational.dart';
import 'package:test/test.dart';

/// The previous, `Rational`-based algorithm, kept here as an independent oracle
/// so the significand-based implementation is checked against it directly.
Decimal _rationalReference(Decimal d, int scale, String op) {
  final factor = Rational.fromInt(10).pow(scale); // handles negative scale
  final scaled = d.toRational() * factor;
  final BigInt applied = switch (op) {
    'round' => scaled.round(),
    'floor' => scaled.floor(),
    'ceil' => scaled.ceil(),
    'truncate' => scaled.truncate(),
    _ => throw ArgumentError(op),
  };
  return (Rational(applied) / factor).toDecimal();
}

Decimal _apply(Decimal d, int scale, String op) => switch (op) {
      'round' => d.round(scale: scale),
      'floor' => d.floor(scale: scale),
      'ceil' => d.ceil(scale: scale),
      'truncate' => d.truncate(scale: scale),
      _ => throw ArgumentError(op),
    };

void main() {
  group('round/floor/ceil/truncate on the significand', () {
    test('matches the Rational reference across a matrix', () {
      const values = [
        '0',
        '1.5',
        '2.5',
        '-1.5',
        '-2.5',
        '123.4567',
        '-123.4567',
        '0.005',
        '-0.005',
        '99.995',
        '0.15',
        '-0.15',
        '250',
        '1250.5',
        '0.999999',
        '-0.999999',
        '1000000.5',
        '-1000000.5',
        '0.1',
        '9.99',
      ];
      const ops = ['round', 'floor', 'ceil', 'truncate'];
      for (final v in values) {
        final d = Decimal.parse(v);
        for (var scale = -3; scale <= 5; scale++) {
          for (final op in ops) {
            expect(
              _apply(d, scale, op),
              _rationalReference(d, scale, op),
              reason: '$op($v, scale: $scale)',
            );
          }
        }
      }
    });

    test('negative ties round away from zero', () {
      expect(Decimal.parse('-2.5').round(), Decimal.fromInt(-3));
      expect(Decimal.parse('2.5').round(), Decimal.fromInt(3));
      expect(Decimal.parse('-3.5').round(), Decimal.fromInt(-4));
    });

    test('ties at negative scale', () {
      expect(Decimal.fromInt(25).round(scale: -1), Decimal.fromInt(30));
      expect(Decimal.fromInt(-25).round(scale: -1), Decimal.fromInt(-30));
      expect(Decimal.fromInt(120).round(scale: -2), Decimal.fromInt(100));
    });

    test('scale at or beyond precision is a no-op', () {
      final d = Decimal.parse('1.23');
      expect(d.round(scale: 2), d);
      expect(d.round(scale: 5), d);
      expect(d.floor(scale: 5), d);
      expect(d.ceil(scale: 5), d);
      expect(d.truncate(scale: 5), d);
    });

    test('floor and ceil directions on negatives', () {
      expect(Decimal.parse('-1.1').floor(), Decimal.fromInt(-2));
      expect(Decimal.parse('-1.1').ceil(), Decimal.fromInt(-1));
      expect(Decimal.parse('-1.1').truncate(), Decimal.fromInt(-1));
    });
  });
}
