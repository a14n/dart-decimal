library tests;

import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:expector/expector.dart';
import 'package:test/test.dart' show test;

Decimal dec(String value) => Decimal.parse(value);

void main() {
  test('tryParse', () {
    expectThat(Decimal.tryParse('1')).equals(dec('1'));
    expectThat(Decimal.tryParse('a')).isNull;
  });
  test('string validation', () async {
    await expectThat(() => dec('1')).returnsNormally();
    await expectThat(() => dec('-1')).returnsNormally();
    await expectThat(() => dec('1.')).returnsNormally();
    await expectThat(() => dec('1.0')).returnsNormally();
  });
  test('get isInteger', () {
    expectThat(dec('1').isInteger).isTrue;
    expectThat(dec('0').isInteger).isTrue;
    expectThat(dec('-1').isInteger).isTrue;
    expectThat(dec('-1.0').isInteger).isTrue;
    expectThat(dec('1.2').isInteger).isFalse;
    expectThat(dec('-1.21').isInteger).isFalse;
  });
  test('get inverse', () {
    expectThat(dec('1').inverse).equals(dec('1'));
    expectThat(dec('0.1').inverse).equals(dec('10'));
    expectThat(dec('200').inverse).equals(dec('0.005'));
  });
  test('operator ==(Decimal other)', () {
    expectThat(dec('1') == (dec('1'))).isTrue;
    expectThat(dec('1') == (dec('2'))).isFalse;
    expectThat(dec('1') == (dec('1.0'))).isTrue;
    expectThat(dec('1') == (dec('2.0'))).isFalse;
    expectThat(dec('1') != (dec('1'))).isFalse;
    expectThat(dec('1') != (dec('2'))).isTrue;
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
      expectThat(dec(n).toString()).equals(n);
    }
    expectThat((dec('1') / dec('3')).toString()).equals('0.3333333333');
    expectThat(dec('9.9').toString()).equals('9.9');
    expectThat((dec('1.0000000000000000000000000000000000000000000000001') *
                dec('1.0000000000000000000000000000000000000000000000001'))
            .toString())
        .equals(
            '1.00000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000001');
  });
  test('compareTo(Decimal other)', () {
    expectThat(dec('1').compareTo(dec('1'))).equals(0);
    expectThat(dec('1').compareTo(dec('1.0'))).equals(0);
    expectThat(dec('1').compareTo(dec('1.1'))).equals(-1);
    expectThat(dec('1').compareTo(dec('0.9'))).equals(1);
  });
  test('operator +(Decimal other)', () {
    expectThat((dec('1') + dec('1')).toString()).equals('2');
    expectThat((dec('1.1') + dec('1')).toString()).equals('2.1');
    expectThat((dec('1.1') + dec('0.9')).toString()).equals('2');
    expectThat((dec('31878018903828899277492024491376690701584023926880.0') +
                dec('0.9'))
            .toString())
        .equals('31878018903828899277492024491376690701584023926880.9');
  });
  test('operator -(Decimal other)', () {
    expectThat((dec('1') - dec('1')).toString()).equals('0');
    expectThat((dec('1.1') - dec('1')).toString()).equals('0.1');
    expectThat((dec('0.1') - dec('1.1')).toString()).equals('-1');
    expectThat((dec('31878018903828899277492024491376690701584023926880.0') -
                dec('0.9'))
            .toString())
        .equals('31878018903828899277492024491376690701584023926879.1');
  });
  test('operator *(Decimal other)', () {
    expectThat((dec('1') * dec('1')).toString()).equals('1');
    expectThat((dec('1.1') * dec('1')).toString()).equals('1.1');
    expectThat((dec('1.1') * dec('0.1')).toString()).equals('0.11');
    expectThat((dec('1.1') * dec('0')).toString()).equals('0');
    expectThat((dec('31878018903828899277492024491376690701584023926880.0') *
                dec('10'))
            .toString())
        .equals('318780189038288992774920244913766907015840239268800');
  });
  test('operator %(Decimal other)', () {
    expectThat((dec('2') % dec('1')).toString()).equals('0');
    expectThat((dec('0') % dec('1')).toString()).equals('0');
    expectThat((dec('8.9') % dec('1.1')).toString()).equals('0.1');
    expectThat((dec('-1.2') % dec('0.5')).toString()).equals('0.3');
    expectThat((dec('-1.2') % dec('-0.5')).toString()).equals('0.3');
  });
  test('operator /(Decimal other)', () async {
    await expectThat(() => dec('1') / dec('0')).throws;
    expectThat((dec('1') / dec('1')).toString()).equals('1');
    expectThat((dec('1.1') / dec('1')).toString()).equals('1.1');
    expectThat((dec('1.1') / dec('0.1')).toString()).equals('11');
    expectThat((dec('0') / dec('0.2315')).toString()).equals('0');
    expectThat((dec('31878018903828899277492024491376690701584023926880.0') /
                dec('10'))
            .toString())
        .equals('3187801890382889927749202449137669070158402392688');
  });
  test('operator ~/(Decimal other)', () async {
    await expectThat(() => dec('1') ~/ dec('0')).throws;
    expectThat((dec('3') ~/ dec('2')).toString()).equals('1');
    expectThat((dec('1.1') ~/ dec('1')).toString()).equals('1');
    expectThat((dec('1.1') ~/ dec('0.1')).toString()).equals('11');
    expectThat((dec('0') ~/ dec('0.2315')).toString()).equals('0');
  });
  test('operator -()', () {
    expectThat((-dec('1')).toString()).equals('-1');
    expectThat((-dec('-1')).toString()).equals('1');
  });
  test('remainder(Decimal other)', () {
    expectThat((dec('2').remainder(dec('1'))).toString()).equals('0');
    expectThat((dec('0').remainder(dec('1'))).toString()).equals('0');
    expectThat((dec('8.9').remainder(dec('1.1'))).toString()).equals('0.1');
    expectThat((dec('-1.2').remainder(dec('0.5'))).toString()).equals('-0.2');
    expectThat((dec('-1.2').remainder(dec('-0.5'))).toString()).equals('-0.2');
  });
  test('operator <(Decimal other)', () {
    expectThat(dec('1') < dec('1')).isFalse;
    expectThat(dec('1') < dec('1.0')).isFalse;
    expectThat(dec('1') < dec('1.1')).isTrue;
    expectThat(dec('1') < dec('0.9')).isFalse;
  });
  test('operator <=(Decimal other)', () {
    expectThat(dec('1') <= dec('1')).isTrue;
    expectThat(dec('1') <= dec('1.0')).isTrue;
    expectThat(dec('1') <= dec('1.1')).isTrue;
    expectThat(dec('1') <= dec('0.9')).isFalse;
  });
  test('operator >(Decimal other)', () {
    expectThat(dec('1') > dec('1')).isFalse;
    expectThat(dec('1') > dec('1.0')).isFalse;
    expectThat(dec('1') > dec('1.1')).isFalse;
    expectThat(dec('1') > dec('0.9')).isTrue;
  });
  test('operator >=(Decimal other)', () {
    expectThat(dec('1') >= dec('1')).isTrue;
    expectThat(dec('1') >= dec('1.0')).isTrue;
    expectThat(dec('1') >= dec('1.1')).isFalse;
    expectThat(dec('1') >= dec('0.9')).isTrue;
  });
  test('get isNaN', () {
    expectThat(dec('1').isNaN).isFalse;
  });
  test('get isNegative', () {
    expectThat(dec('-1').isNegative).isTrue;
    expectThat(dec('0').isNegative).isFalse;
    expectThat(dec('1').isNegative).isFalse;
  });
  test('get isInfinite', () {
    expectThat(dec('1').isInfinite).isFalse;
  });
  test('abs()', () {
    expectThat((dec('-1.49').abs()).toString()).equals('1.49');
    expectThat((dec('1.498').abs()).toString()).equals('1.498');
  });
  test('signum', () {
    expectThat(dec('-1.49').signum).equals(-1);
    expectThat(dec('1.49').signum).equals(1);
    expectThat(dec('0').signum).equals(0);
  });
  test('floor()', () {
    expectThat((dec('1').floor()).toString()).equals('1');
    expectThat((dec('-1').floor()).toString()).equals('-1');
    expectThat((dec('1.49').floor()).toString()).equals('1');
    expectThat((dec('-1.49').floor()).toString()).equals('-2');
  });
  test('ceil()', () {
    expectThat((dec('1').floor()).toString()).equals('1');
    expectThat((dec('-1').floor()).toString()).equals('-1');
    expectThat((dec('-1.49').ceil()).toString()).equals('-1');
    expectThat((dec('1.49').ceil()).toString()).equals('2');
  });
  test('round()', () {
    expectThat((dec('1.4999').round()).toString()).equals('1');
    expectThat((dec('2.5').round()).toString()).equals('3');
    expectThat((dec('-2.51').round()).toString()).equals('-3');
    expectThat((dec('-2').round()).toString()).equals('-2');
  });
  test('truncate()', () {
    expectThat((dec('2.51').truncate()).toString()).equals('2');
    expectThat((dec('-2.51').truncate()).toString()).equals('-2');
    expectThat((dec('-2').truncate()).toString()).equals('-2');
  });
  test('clamp(Decimal lowerLimit, Decimal upperLimit)', () {
    expectThat((dec('2.51').clamp(dec('1'), dec('3'))).toString())
        .equals('2.51');
    expectThat((dec('2.51').clamp(dec('2.6'), dec('3'))).toString())
        .equals('2.6');
    expectThat((dec('2.51').clamp(dec('1'), dec('2.5'))).toString())
        .equals('2.5');
  });
  test('toInt()', () {
    expectThat(dec('2.51').toInt()).equals(2);
    expectThat(dec('-2.51').toInt()).equals(-2);
    expectThat(dec('-2').toInt()).equals(-2);
  });
  test('toBigInt()', () {
    expectThat(dec('2.51').toBigInt()).equals(BigInt.from(2));
    expectThat(dec('-2.51').toBigInt()).equals(BigInt.from(-2));
    expectThat(dec('-2').toBigInt()).equals(BigInt.from(-2));
  });
  test('toDouble()', () {
    expectThat(dec('2.51').toDouble()).equals(2.51);
    expectThat(dec('-2.51').toDouble()).equals(-2.51);
    expectThat(dec('-2').toDouble()).equals(-2.0);
  });
  test('hasFinitePrecision', () {
    for (final d in [
      dec('100'),
      dec('100.100'),
      dec('1') / dec('5'),
      (dec('1') / dec('3')) * dec('3'),
      dec('0.00000000000000000000001')
    ]) {
      expectThat(d.hasFinitePrecision).isTrue;
    }
    for (final d in [dec('1') / dec('3')]) {
      expectThat(d.hasFinitePrecision).isFalse;
    }
  });
  test('precision', () {
    expectThat(dec('100').precision).equals(3);
    expectThat(dec('10000').precision).equals(5);
    expectThat(dec('100.000').precision).equals(3);
    expectThat(dec('100.1').precision).equals(4);
    expectThat(dec('100.0000001').precision).equals(10);
    expectThat(dec('100.000000000000000000000000000001').precision).equals(33);
    expectThat(() => (dec('1') / dec('3')).precision).throws;
  });
  test('scale', () {
    expectThat(dec('100').scale).equals(0);
    expectThat(dec('10000').scale).equals(0);
    expectThat(dec('100.000').scale).equals(0);
    expectThat(dec('100.1').scale).equals(1);
    expectThat(dec('100.0000001').scale).equals(7);
    expectThat(dec('100.000000000000000000000000000001').scale).equals(30);
    expectThat(() => (dec('1') / dec('3')).scale).throws;
  });
  test('toStringAsFixed(int fractionDigits)', () {
    for (final n in [0, 1, 23, 2.2, 2.499999, 2.5, 2.7, 1.235]) {
      for (final p in [0, 1, 5, 10]) {
        expectThat(dec(n.toString()).toStringAsFixed(p))
            .equals(n.toStringAsFixed(p));
      }
    }
  });
  test('toStringAsExponential(int fractionDigits)', () {
    for (final n in [0, 1, 23, 2.2, 2.499999, 2.5, 2.7, 1.235]) {
      for (final p in [1, 5, 10]) {
        expectThat(dec(n.toString()).toStringAsExponential(p))
            .equals(n.toStringAsExponential(p));
      }
    }
  });
  test('toStringAsPrecision(int precision)', () {
    expectThat(dec('0').toStringAsPrecision(1)).equals('0');
    expectThat(dec('0').toStringAsPrecision(5)).equals('0.0000');
    expectThat(dec('0').toStringAsPrecision(10)).equals('0.000000000');
    expectThat(dec('1').toStringAsPrecision(1)).equals('1');
    expectThat(dec('1').toStringAsPrecision(5)).equals('1.0000');
    expectThat(dec('1').toStringAsPrecision(10)).equals('1.000000000');
    expectThat(dec('23').toStringAsPrecision(1)).equals('20');
    expectThat(dec('23').toStringAsPrecision(5)).equals('23.000');
    expectThat(dec('23').toStringAsPrecision(10)).equals('23.00000000');
    expectThat(dec('2.2').toStringAsPrecision(1)).equals('2');
    expectThat(dec('2.2').toStringAsPrecision(5)).equals('2.2000');
    expectThat(dec('2.2').toStringAsPrecision(10)).equals('2.200000000');
    expectThat(dec('2.499999').toStringAsPrecision(1)).equals('2');
    expectThat(dec('2.499999').toStringAsPrecision(5)).equals('2.5000');
    expectThat(dec('2.499999').toStringAsPrecision(10)).equals('2.499999000');
    expectThat(dec('2.5').toStringAsPrecision(1)).equals('3');
    expectThat(dec('2.5').toStringAsPrecision(5)).equals('2.5000');
    expectThat(dec('2.5').toStringAsPrecision(10)).equals('2.500000000');
    expectThat(dec('2.7').toStringAsPrecision(1)).equals('3');
    expectThat(dec('2.7').toStringAsPrecision(5)).equals('2.7000');
    expectThat(dec('2.7').toStringAsPrecision(10)).equals('2.700000000');
    expectThat(dec('1.235').toStringAsPrecision(1)).equals('1');
    expectThat(dec('1.235').toStringAsPrecision(5)).equals('1.2350');
    expectThat(dec('1.235').toStringAsPrecision(10)).equals('1.235000000');
  });
  test('issue #13', () {
    expectThat(Decimal.parse('21.962962546543768').toString())
        .equals('21.962962546543768');
  });
  test('zero', () {
    expectThat(Decimal.zero).equals(Decimal.fromInt(0));
  });
  test('one', () {
    expectThat(Decimal.one).equals(Decimal.fromInt(1));
  });
  test('ten', () {
    expectThat(Decimal.ten).equals(Decimal.fromInt(10));
  });
  test('pow', () {
    expectThat(dec('100').pow(0)).equals(dec('1'));
    expectThat(dec('100').pow(1)).equals(dec('100'));
    expectThat(dec('100').pow(2)).equals(dec('10000'));
    expectThat(dec('100').pow(-1)).equals(dec('0.01'));
    expectThat(dec('100').pow(-2)).equals(dec('0.0001'));
    expectThat(dec('0.1').pow(0)).equals(dec('1'));
    expectThat(dec('0.1').pow(1)).equals(dec('0.1'));
    expectThat(dec('0.1').pow(2)).equals(dec('0.01'));
    expectThat(dec('0.1').pow(-1)).equals(dec('10'));
    expectThat(dec('0.1').pow(-2)).equals(dec('100'));
    expectThat(dec('-1').pow(0)).equals(dec('1'));
    expectThat(dec('-1').pow(1)).equals(dec('-1'));
    expectThat(dec('-1').pow(2)).equals(dec('1'));
    expectThat(dec('-1').pow(-1)).equals(dec('-1'));
    expectThat(dec('-1').pow(-2)).equals(dec('1'));
  });
  test('fromJson', () async {
    expectThat(Decimal.fromJson('1')).equals(Decimal.one);
    await expectThat(() => Decimal.fromJson('-1')).returnsNormally();
    await expectThat(() => Decimal.fromJson('1.')).returnsNormally();
    await expectThat(() => Decimal.fromJson('1.0')).returnsNormally();
  });
  test('toJson', () {
    const encoder = JsonEncoder();
    expectThat(encoder.convert({
      'zero': Decimal.zero,
      'one': Decimal.one,
    })).equals(
      '{'
      '"zero":"${Decimal.zero}",'
      '"one":"${Decimal.one}"'
      '}',
    );
  });
}
