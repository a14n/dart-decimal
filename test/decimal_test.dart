library tests;

import 'package:test/test.dart';
import 'package:decimal/decimal.dart';

Decimal dec(String value) => Decimal.parse(value);

void main() {
  test('tryParse', () {
    expect(Decimal.tryParse('1'), dec('1'));
    expect(Decimal.tryParse('a'), null);
  });
  test('string validation', () {
    expect(() => dec('1'), returnsNormally);
    expect(() => dec('-1'), returnsNormally);
    expect(() => dec('1.'), returnsNormally);
    expect(() => dec('1.0'), returnsNormally);
  });
  test('get isInteger', () {
    expect(dec('1').isInteger, equals(true));
    expect(dec('0').isInteger, equals(true));
    expect(dec('-1').isInteger, equals(true));
    expect(dec('-1.0').isInteger, equals(true));
    expect(dec('1.2').isInteger, equals(false));
    expect(dec('-1.21').isInteger, equals(false));
  });
  test('get inverse', () {
    expect(dec('1').inverse, dec('1'));
    expect(dec('0.1').inverse, dec('10'));
    expect(dec('200').inverse, dec('0.005'));
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
    for (final n in [
      '0',
      '1',
      '-1',
      '-1.1',
      '23',
      '31878018903828899277492024491376690701584023926880.1'
    ]) {
      expect(dec(n).toString(), equals(n));
    }
    expect((dec('1') / dec('3')).toString(), equals('0.3333333333'));
    expect(dec('9.9').toString(), equals('9.9'));
    expect(
        (dec('1.0000000000000000000000000000000000000000000000001') *
                dec('1.0000000000000000000000000000000000000000000000001'))
            .toString(),
        equals(
            '1.00000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000001'));
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
    expect(
        (dec('31878018903828899277492024491376690701584023926880.0') +
                dec('0.9'))
            .toString(),
        equals('31878018903828899277492024491376690701584023926880.9'));
  });
  test('operator -(Decimal other)', () {
    expect((dec('1') - dec('1')).toString(), equals('0'));
    expect((dec('1.1') - dec('1')).toString(), equals('0.1'));
    expect((dec('0.1') - dec('1.1')).toString(), equals('-1'));
    expect(
        (dec('31878018903828899277492024491376690701584023926880.0') -
                dec('0.9'))
            .toString(),
        equals('31878018903828899277492024491376690701584023926879.1'));
  });
  test('operator *(Decimal other)', () {
    expect((dec('1') * dec('1')).toString(), equals('1'));
    expect((dec('1.1') * dec('1')).toString(), equals('1.1'));
    expect((dec('1.1') * dec('0.1')).toString(), equals('0.11'));
    expect((dec('1.1') * dec('0')).toString(), equals('0'));
    expect(
        (dec('31878018903828899277492024491376690701584023926880.0') *
                dec('10'))
            .toString(),
        equals('318780189038288992774920244913766907015840239268800'));
  });
  test('operator %(Decimal other)', () {
    expect((dec('2') % dec('1')).toString(), equals('0'));
    expect((dec('0') % dec('1')).toString(), equals('0'));
    expect((dec('8.9') % dec('1.1')).toString(), equals('0.1'));
    expect((dec('-1.2') % dec('0.5')).toString(), equals('0.3'));
    expect((dec('-1.2') % dec('-0.5')).toString(), equals('0.3'));
  });
  test('operator /(Decimal other)', () {
    expect(() => dec('1') / dec('0'), throwsA(anything));
    expect((dec('1') / dec('1')).toString(), equals('1'));
    expect((dec('1.1') / dec('1')).toString(), equals('1.1'));
    expect((dec('1.1') / dec('0.1')).toString(), equals('11'));
    expect((dec('0') / dec('0.2315')).toString(), equals('0'));
    expect(
        (dec('31878018903828899277492024491376690701584023926880.0') /
                dec('10'))
            .toString(),
        equals('3187801890382889927749202449137669070158402392688'));
  });
  test('operator ~/(Decimal other)', () {
    expect(() => dec('1') ~/ dec('0'), throwsA(anything));
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
  test('signum', () {
    expect(dec('-1.49').signum, equals(-1));
    expect(dec('1.49').signum, equals(1));
    expect(dec('0').signum, equals(0));
  });
  test('floor()', () {
    expect((dec('1').floor()).toString(), equals('1'));
    expect((dec('-1').floor()).toString(), equals('-1'));
    expect((dec('1.49').floor()).toString(), equals('1'));
    expect((dec('-1.49').floor()).toString(), equals('-2'));
  });
  test('ceil()', () {
    expect((dec('1').floor()).toString(), equals('1'));
    expect((dec('-1').floor()).toString(), equals('-1'));
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
  test('clamp(Decimal lowerLimit, Decimal upperLimit)', () {
    expect((dec('2.51').clamp(dec('1'), dec('3'))).toString(), equals('2.51'));
    expect((dec('2.51').clamp(dec('2.6'), dec('3'))).toString(), equals('2.6'));
    expect((dec('2.51').clamp(dec('1'), dec('2.5'))).toString(), equals('2.5'));
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
  test('hasFinitePrecision', () {
    for (final d in [
      dec('100'),
      dec('100.100'),
      dec('1') / dec('5'),
      (dec('1') / dec('3')) * dec('3'),
      dec('0.00000000000000000000001')
    ]) {
      expect(d.hasFinitePrecision, isTrue);
    }
    for (final d in [dec('1') / dec('3')]) {
      expect(d.hasFinitePrecision, isFalse);
    }
  });
  test('precision', () {
    expect(dec('100').precision, equals(3));
    expect(dec('10000').precision, equals(5));
    expect(dec('100.000').precision, equals(3));
    expect(dec('100.1').precision, equals(4));
    expect(dec('100.0000001').precision, equals(10));
    expect(dec('100.000000000000000000000000000001').precision, equals(33));
    expect(() => (dec('1') / dec('3')).precision, throwsA(anything));
  });
  test('scale', () {
    expect(dec('100').scale, equals(0));
    expect(dec('10000').scale, equals(0));
    expect(dec('100.000').scale, equals(0));
    expect(dec('100.1').scale, equals(1));
    expect(dec('100.0000001').scale, equals(7));
    expect(dec('100.000000000000000000000000000001').scale, equals(30));
    expect(() => (dec('1') / dec('3')).scale, throwsA(anything));
  });
  test('toStringAsFixed(int fractionDigits)', () {
    for (final n in [0, 1, 23, 2.2, 2.499999, 2.5, 2.7, 1.235]) {
      for (final p in [0, 1, 5, 10]) {
        expect(dec(n.toString()).toStringAsFixed(p), n.toStringAsFixed(p));
      }
    }
  });
  test('toStringAsExponential(int fractionDigits)', () {
    for (final n in [0, 1, 23, 2.2, 2.499999, 2.5, 2.7, 1.235]) {
      for (final p in [1, 5, 10]) {
        expect(dec(n.toString()).toStringAsExponential(p),
            n.toStringAsExponential(p));
      }
    }
  });
  test('toStringAsPrecision(int precision)', () {
    expect(dec('0').toStringAsPrecision(1), '0');
    expect(dec('0').toStringAsPrecision(5), '0.0000');
    expect(dec('0').toStringAsPrecision(10), '0.000000000');
    expect(dec('1').toStringAsPrecision(1), '1');
    expect(dec('1').toStringAsPrecision(5), '1.0000');
    expect(dec('1').toStringAsPrecision(10), '1.000000000');
    expect(dec('23').toStringAsPrecision(1), '20');
    expect(dec('23').toStringAsPrecision(5), '23.000');
    expect(dec('23').toStringAsPrecision(10), '23.00000000');
    expect(dec('2.2').toStringAsPrecision(1), '2');
    expect(dec('2.2').toStringAsPrecision(5), '2.2000');
    expect(dec('2.2').toStringAsPrecision(10), '2.200000000');
    expect(dec('2.499999').toStringAsPrecision(1), '2');
    expect(dec('2.499999').toStringAsPrecision(5), '2.5000');
    expect(dec('2.499999').toStringAsPrecision(10), '2.499999000');
    expect(dec('2.5').toStringAsPrecision(1), '3');
    expect(dec('2.5').toStringAsPrecision(5), '2.5000');
    expect(dec('2.5').toStringAsPrecision(10), '2.500000000');
    expect(dec('2.7').toStringAsPrecision(1), '3');
    expect(dec('2.7').toStringAsPrecision(5), '2.7000');
    expect(dec('2.7').toStringAsPrecision(10), '2.700000000');
    expect(dec('1.235').toStringAsPrecision(1), '1');
    expect(dec('1.235').toStringAsPrecision(5), '1.2350');
    expect(dec('1.235').toStringAsPrecision(10), '1.235000000');
  });
  test('issue #13', () {
    expect(
        Decimal.parse('21.962962546543768').toString(), '21.962962546543768');
  });
  test('zero', () {
    expect(Decimal.zero, Decimal.fromInt(0));
  });
  test('one', () {
    expect(Decimal.one, Decimal.fromInt(1));
  });
}
