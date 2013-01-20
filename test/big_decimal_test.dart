import 'package:unittest/unittest.dart';
import 'package:decimal/decimal.dart';

main() {
  test('string validation', () {
    expect(() => new Decimal('1'), returnsNormally);
    expect(() => new Decimal('-1'), returnsNormally);
    expect(() => new Decimal('1.'), throws);
    expect(() => new Decimal('1.0'), returnsNormally);
  });
  test('get isInteger', () {
    expect(dec('1').isInteger, equals(true));
    expect(dec('0').isInteger, equals(true));
    expect(dec('-1').isInteger, equals(true));
    expect(dec('-1.0').isInteger, equals(true));
    expect(dec('1.2').isInteger, equals(false));
    expect(dec('-1.21').isInteger, equals(false));
  });
  test('operator ==(Decimal other)', () {
    expect(dec('1') == (dec('1')), equals(true));
    expect(dec('1') == (dec('2')), equals(false));
    expect(dec('1') == (dec('1.0')), equals(true));
    expect(dec('1') == (dec('2.0')), equals(false));
    expect(dec('1') != (dec('1')), equals(false));
    expect(dec('1') != (dec('2')), equals(true));
  });
  test('toString()', () {
    ['0', '1', '-1', '-1.1', '23', '31878018903828899277492024491376690701584023926880.1'].forEach((String n) {
      expect(new Decimal(n).toString(), equals(n));
    });
  });
  test('compareTo(Decimal other)', () {
    expect(dec('1').compareTo(dec('1')), equals(0));
    expect(dec('1').compareTo(dec('1.0')), equals(0));
    expect(dec('1').compareTo(dec('1.1')), equals(-1));
    expect(dec('1').compareTo(dec('0.9')), equals(1));
  });
  test('operator +(Decimal other)', () {
    expect((dec('1') + dec('1')).toString(), equals('2'));
    expect((dec('1.1') + dec('1')).toString(), equals('2.1'));
    expect((dec('1.1') + dec('0.9')).toString(), equals('2'));
    expect((dec('31878018903828899277492024491376690701584023926880.0') + dec('0.9')).toString(), equals('31878018903828899277492024491376690701584023926880.9'));
  });
  test('operator -(Decimal other)', () {
    expect((dec('1') - dec('1')).toString(), equals('0'));
    expect((dec('1.1') - dec('1')).toString(), equals('0.1'));
    expect((dec('0.1') - dec('1.1')).toString(), equals('-1'));
    expect((dec('31878018903828899277492024491376690701584023926880.0') - dec('0.9')).toString(), equals('31878018903828899277492024491376690701584023926879.1'));
  });
  test('operator *(Decimal other)', () {
    expect((dec('1') * dec('1')).toString(), equals('1'));
    expect((dec('1.1') * dec('1')).toString(), equals('1.1'));
    expect((dec('1.1') * dec('0.1')).toString(), equals('0.11'));
    expect((dec('1.1') * dec('0')).toString(), equals('0'));
    expect((dec('31878018903828899277492024491376690701584023926880.0') * dec('10')).toString(), equals('318780189038288992774920244913766907015840239268800'));
  });
  test('operator %(Decimal other)', () {
    expect((dec('2') % dec('1')).toString(), equals('0'));
    expect((dec('0') % dec('1')).toString(), equals('0'));
    expect((dec('8.9') % dec('1.1')).toString(), equals('0.1'));
    expect((dec('-1.2') % dec('0.5')).toString(), equals('0.3'));
    expect((dec('-1.2') % dec('-0.5')).toString(), equals('0.3'));
  });
  test('operator /(Decimal other)', () {
    expect(() => dec('1') / dec('0'), throws);
    expect((dec('1') / dec('1')).toString(), equals('1'));
    expect((dec('1.1') / dec('1')).toString(), equals('1.1'));
    expect((dec('1.1') / dec('0.1')).toString(), equals('11'));
    expect((dec('0') / dec('0.2315')).toString(), equals('0'));
    expect((dec('31878018903828899277492024491376690701584023926880.0') / dec('10')).toString(), equals('3187801890382889927749202449137669070158402392688'));
  });
  test('operator ~/(Decimal other)', () {
    expect(() => dec('1') ~/ dec('0'), throws);
    expect((dec('3') ~/ dec('2')).toString(), equals('1'));
    expect((dec('1.1') ~/ dec('1')).toString(), equals('1'));
    expect((dec('1.1') ~/ dec('0.1')).toString(), equals('11'));
    expect((dec('0') ~/ dec('0.2315')).toString(), equals('0'));
  });
  test('operator -()', () {
    expect((-dec('1')).toString(), equals('-1'));
    expect((-dec('-1')).toString(), equals('1'));
  });
  test('remainder(Decimal other)', () {
    expect((dec('2').remainder(dec('1'))).toString(), equals('0'));
    expect((dec('0').remainder(dec('1'))).toString(), equals('0'));
    expect((dec('8.9').remainder(dec('1.1'))).toString(), equals('0.1'));
    expect((dec('-1.2').remainder(dec('0.5'))).toString(), equals('-0.2'));
    expect((dec('-1.2').remainder(dec('-0.5'))).toString(), equals('-0.2'));
  });
  test('operator <(Decimal other)', () {
    expect(dec('1') < dec('1'), equals(false));
    expect(dec('1') < dec('1.0'), equals(false));
    expect(dec('1') < dec('1.1'), equals(true));
    expect(dec('1') < dec('0.9'), equals(false));
  });
  test('operator <=(Decimal other)', () {
    expect(dec('1') <= dec('1'), equals(true));
    expect(dec('1') <= dec('1.0'), equals(true));
    expect(dec('1') <= dec('1.1'), equals(true));
    expect(dec('1') <= dec('0.9'), equals(false));
  });
  test('operator >(Decimal other)', () {
    expect(dec('1') > dec('1'), equals(false));
    expect(dec('1') > dec('1.0'), equals(false));
    expect(dec('1') > dec('1.1'), equals(false));
    expect(dec('1') > dec('0.9'), equals(true));
  });
  test('operator >=(Decimal other)', () {
    expect(dec('1') >= dec('1'), equals(true));
    expect(dec('1') >= dec('1.0'), equals(true));
    expect(dec('1') >= dec('1.1'), equals(false));
    expect(dec('1') >= dec('0.9'), equals(true));
  });
  test('get isNaN', () {
    expect(dec('1').isNaN, equals(false));
  });
  test('get isNegative', () {
    expect(dec('-1').isNegative, equals(true));
    expect(dec('0').isNegative, equals(false));
    expect(dec('1').isNegative, equals(false));
  });
  test('get isInfinite', () {
    expect(dec('1').isInfinite, equals(false));
  });
  test('abs()', () {
    expect((dec('-1.49').abs()).toString(), equals('1.49'));
    expect((dec('1.498').abs()).toString(), equals('1.498'));
  });
  test('floor()', () {
    expect((dec('-1.49').floor()).toString(), equals('-2'));
    expect((dec('1.49').floor()).toString(), equals('1'));
  });
  test('ceil()', () {
    expect((dec('-1.49').ceil()).toString(), equals('-1'));
    expect((dec('1.49').ceil()).toString(), equals('2'));
  });
  test('round()', () {
    expect((dec('1.4999').round()).toString(), equals('1'));
    expect((dec('2.5').round()).toString(), equals('3'));
    expect((dec('-2.51').round()).toString(), equals('-3'));
    expect((dec('-2').round()).toString(), equals('-2'));
  });
  test('truncate()', () {
    expect((dec('2.51').truncate()).toString(), equals('2'));
    expect((dec('-2.51').truncate()).toString(), equals('-2'));
    expect((dec('-2').truncate()).toString(), equals('-2'));
  });
  test('toInt()', () {
    expect(dec('2.51').toInt(), equals(2));
    expect(dec('-2.51').toInt(), equals(-2));
    expect(dec('-2').toInt(), equals(-2));
  });
  test('toDouble()', () {
    expect(dec('2.51').toDouble(), equals(2.51));
    expect(dec('-2.51').toDouble(), equals(-2.51));
    expect(dec('-2').toDouble(), equals(-2.0));
  });
  test('toStringAsFixed(int fractionDigits)', () {
    [0, 1, 23, 2.2, 2.499999, 2.5, 2.7, 1.235].forEach((num n) {
      [0, 1, 5, 10].forEach((p) {
        expect(dec(n.toString()).toStringAsFixed(p), equals(n.toStringAsFixed(p)));
      });
    });
  });
  test('toStringAsExponential(int fractionDigits)', () {
    [0, 1, 23, 2.2, 2.499999, 2.5, 2.7, 1.235].forEach((num n) {
      [1, 5, 10].forEach((p) {
        expect(dec(n.toString()).toStringAsExponential(p), equals(n.toStringAsExponential(p)));
      });
    });
  });
  test('toStringAsPrecision(int precision)', () {
    [0, 1, 23, 2.2, 2.499999, 2.5, 2.7, 1.235].forEach((num n) {
      [1, 5, 10].forEach((p) {
        expect(dec(n.toString()).toStringAsPrecision(p), equals(n.toStringAsPrecision(p)));
      });
    });
  });
  test('toRadixString(int radix)', () {
    [0, 1, 23, 2.2, 2.499999, 2.5, 2.7, 1.235].forEach((num n) {
      [2, 5, 10, 36].forEach((p) {
        expect(dec(n.toString()).toRadixString(p), equals(n.toRadixString(p)));
      });
    });
  });
}
