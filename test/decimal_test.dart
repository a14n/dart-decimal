// Copyright 2013 Alexandre Ardhuin
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:expector/expector.dart';
import 'package:rational/rational.dart';
import 'package:test/test.dart' show group, test;

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
    expectThat(dec('1').inverse).equals(dec('1').toRational());
    expectThat(dec('0.1').inverse).equals(dec('10').toRational());
    expectThat(dec('200').inverse).equals(dec('0.005').toRational());
  });
  test('operator ==(Decimal other)', () {
    expectThat(dec('1') == dec('1')).isTrue;
    expectThat(dec('1') == dec('2')).isFalse;
    expectThat(dec('1') == dec('1.0')).isTrue;
    expectThat(dec('1') == dec('2.0')).isFalse;
    expectThat(dec('1') != dec('1')).isFalse;
    expectThat(dec('1') != dec('2')).isTrue;
  });
  test('toString()', () {
    for (final n in [
      '0',
      '1',
      '-0.1',
      '-1',
      '-1.1',
      '23',
      '31878018903828899277492024491376690701584023926880.1'
    ]) {
      expectThat(dec(n).toString()).equals(n);
    }
    expectThat((dec('1') / dec('3')).toString()).equals('1/3');
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
    expectThat(dec('1') + dec('1')).equals(dec('2'));
    expectThat(dec('1.1') + dec('1')).equals(dec('2.1'));
    expectThat(dec('1.1') + dec('0.9')).equals(dec('2'));
    expectThat(dec('31878018903828899277492024491376690701584023926880.0') +
            dec('0.9'))
        .equals(dec('31878018903828899277492024491376690701584023926880.9'));
  });
  test('operator -(Decimal other)', () {
    expectThat(dec('1') - dec('1')).equals(dec('0'));
    expectThat(dec('1.1') - dec('1')).equals(dec('0.1'));
    expectThat(dec('0.1') - dec('1.1')).equals(dec('-1'));
    expectThat(dec('31878018903828899277492024491376690701584023926880.0') -
            dec('0.9'))
        .equals(dec('31878018903828899277492024491376690701584023926879.1'));
  });
  test('operator *(Decimal other)', () {
    expectThat(dec('1') * dec('1')).equals(dec('1'));
    expectThat(dec('1.1') * dec('1')).equals(dec('1.1'));
    expectThat(dec('1.1') * dec('0.1')).equals(dec('0.11'));
    expectThat(dec('1.1') * dec('0')).equals(dec('0'));
    expectThat(dec('31878018903828899277492024491376690701584023926880.0') *
            dec('10'))
        .equals(dec('318780189038288992774920244913766907015840239268800'));
  });
  test('operator %(Decimal other)', () {
    expectThat(dec('2') % dec('1')).equals(dec('0'));
    expectThat(dec('0') % dec('1')).equals(dec('0'));
    expectThat(dec('8.9') % dec('1.1')).equals(dec('0.1'));
    expectThat(dec('-1.2') % dec('0.5')).equals(dec('0.3'));
    expectThat(dec('-1.2') % dec('-0.5')).equals(dec('0.3'));
  });
  test('operator /(Decimal other)', () async {
    await expectThat(() => dec('1') / dec('0')).throws;
    expectThat(dec('1') / dec('1')).equals(dec('1').toRational());
    expectThat(dec('1.1') / dec('1')).equals(dec('1.1').toRational());
    expectThat(dec('1.1') / dec('0.1')).equals(dec('11').toRational());
    expectThat(dec('0') / dec('0.2315')).equals(dec('0').toRational());
    expectThat(dec('31878018903828899277492024491376690701584023926880.0') /
            dec('10'))
        .equals(dec('3187801890382889927749202449137669070158402392688')
            .toRational());
  });
  test('operator ~/(Decimal other)', () async {
    await expectThat(() => dec('1') ~/ dec('0')).throws;
    expectThat(dec('3') ~/ dec('2')).equals(BigInt.from(1));
    expectThat(dec('1.1') ~/ dec('1')).equals(BigInt.from(1));
    expectThat(dec('1.1') ~/ dec('0.1')).equals(BigInt.from(11));
    expectThat(dec('0') ~/ dec('0.2315')).equals(BigInt.from(0));
  });
  test('operator -()', () {
    expectThat(-dec('1')).equals(dec('-1'));
    expectThat(-dec('-1')).equals(dec('1'));
  });
  test('remainder(Decimal other)', () {
    expectThat(dec('2').remainder(dec('1'))).equals(dec('0'));
    expectThat(dec('0').remainder(dec('1'))).equals(dec('0'));
    expectThat(dec('8.9').remainder(dec('1.1'))).equals(dec('0.1'));
    expectThat(dec('-1.2').remainder(dec('0.5'))).equals(dec('-0.2'));
    expectThat(dec('-1.2').remainder(dec('-0.5'))).equals(dec('-0.2'));
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
  test('abs()', () {
    expectThat(dec('-1.49').abs()).equals(dec('1.49'));
    expectThat(dec('1.498').abs()).equals(dec('1.498'));
  });
  test('signum', () {
    expectThat(dec('-1.49').signum).equals(-1);
    expectThat(dec('1.49').signum).equals(1);
    expectThat(dec('0').signum).equals(0);
  });
  group('floor()', () {
    test('without scale', () {
      expectThat(dec('1').floor()).equals(dec('1'));
      expectThat(dec('-1').floor()).equals(dec('-1'));
      expectThat(dec('1.49').floor()).equals(dec('1'));
      expectThat(dec('-1.49').floor()).equals(dec('-2'));
    });
    test('with positive scale', () {
      expectThat(dec('1').floor(scale: 1)).equals(dec('1'));
      expectThat(dec('-1').floor(scale: 1)).equals(dec('-1'));
      expectThat(dec('1.49').floor(scale: 1)).equals(dec('1.4'));
      expectThat(dec('-1.49').floor(scale: 1)).equals(dec('-1.5'));
    });
    test('with negative scale', () {
      expectThat(dec('1').floor(scale: -1)).equals(dec('0'));
      expectThat(dec('-1').floor(scale: -1)).equals(dec('-10'));
      expectThat(dec('14.9').floor(scale: -1)).equals(dec('10'));
      expectThat(dec('-14.9').floor(scale: -1)).equals(dec('-20'));
    });
  });
  group('ceil()', () {
    test('without scale', () {
      expectThat(dec('1').ceil()).equals(dec('1'));
      expectThat(dec('-1').ceil()).equals(dec('-1'));
      expectThat(dec('-1.49').ceil()).equals(dec('-1'));
      expectThat(dec('1.49').ceil()).equals(dec('2'));
    });
    test('with positive scale', () {
      expectThat(dec('1').ceil(scale: 1)).equals(dec('1'));
      expectThat(dec('-1').ceil(scale: 1)).equals(dec('-1'));
      expectThat(dec('-1.49').ceil(scale: 1)).equals(dec('-1.4'));
      expectThat(dec('1.49').ceil(scale: 1)).equals(dec('1.5'));
    });
    test('with negative scale', () {
      expectThat(dec('1').ceil(scale: -1)).equals(dec('10'));
      expectThat(dec('-1').ceil(scale: -1)).equals(dec('0'));
      expectThat(dec('-14.9').ceil(scale: -1)).equals(dec('-10'));
      expectThat(dec('14.9').ceil(scale: -1)).equals(dec('20'));
    });
  });
  group('round()', () {
    test('without scale', () {
      expectThat(dec('1.4999').round()).equals(dec('1'));
      expectThat(dec('2.5').round()).equals(dec('3'));
      expectThat(dec('-2.51').round()).equals(dec('-3'));
      expectThat(dec('-2').round()).equals(dec('-2'));
    });
    test('with positive scale', () {
      expectThat(dec('1.4999').round(scale: 1)).equals(dec('1.5'));
      expectThat(dec('2.5').round(scale: 1)).equals(dec('2.5'));
      expectThat(dec('-2.51').round(scale: 1)).equals(dec('-2.5'));
      expectThat(dec('-2').round(scale: 1)).equals(dec('-2'));
    });
    test('with negative scale', () {
      expectThat(dec('1.4999').round(scale: -1)).equals(dec('0'));
      expectThat(dec('12.5').round(scale: -1)).equals(dec('10'));
      expectThat(dec('-25.1').round(scale: -1)).equals(dec('-30'));
      expectThat(dec('-24').round(scale: -1)).equals(dec('-20'));
    });
  });
  group('truncate()', () {
    test('without scale', () {
      expectThat(dec('1.4999').truncate()).equals(dec('1'));
      expectThat(dec('2.5').truncate()).equals(dec('2'));
      expectThat(dec('-2.51').truncate()).equals(dec('-2'));
      expectThat(dec('-2').truncate()).equals(dec('-2'));
    });
    test('with positive scale', () {
      expectThat(dec('1.4999').truncate(scale: 1)).equals(dec('1.4'));
      expectThat(dec('2.5').truncate(scale: 1)).equals(dec('2.5'));
      expectThat(dec('-2.51').truncate(scale: 1)).equals(dec('-2.5'));
      expectThat(dec('-2').truncate(scale: 1)).equals(dec('-2'));
    });
    test('with negative scale', () {
      expectThat(dec('1.4999').truncate(scale: -1)).equals(dec('0'));
      expectThat(dec('12.5').truncate(scale: -1)).equals(dec('10'));
      expectThat(dec('-25.1').truncate(scale: -1)).equals(dec('-20'));
      expectThat(dec('-24').truncate(scale: -1)).equals(dec('-20'));
    });
  });
  test('shift()', () {
    expectThat(dec('123.4567').shift(0)).equals(dec('123.4567'));
    expectThat(dec('123.4567').shift(1)).equals(dec('1234.567'));
    expectThat(dec('123.4567').shift(2)).equals(dec('12345.67'));
    expectThat(dec('123.4567').shift(6)).equals(dec('123456700'));
    expectThat(dec('123.4567').shift(-1)).equals(dec('12.34567'));
    expectThat(dec('123.4567').shift(-2)).equals(dec('1.234567'));
    expectThat(dec('123.4567').shift(-3)).equals(dec('0.1234567'));
  });
  test('clamp(Decimal lowerLimit, Decimal upperLimit)', () {
    expectThat(dec('2.51').clamp(dec('1'), dec('3'))).equals(dec('2.51'));
    expectThat(dec('2.51').clamp(dec('2.6'), dec('3'))).equals(dec('2.6'));
    expectThat(dec('2.51').clamp(dec('1'), dec('2.5'))).equals(dec('2.5'));
  });

  group('roundHalfEven - scale -', () {
    test('0', () {
      expectThat(dec('5.5').roundHalfEven()).equals(dec('6'));
      expectThat(dec('2.5').roundHalfEven()).equals(dec('2'));
      expectThat(dec('1.6').roundHalfEven()).equals(dec('2'));
      expectThat(dec('1.55').roundHalfEven()).equals(dec('2'));
      expectThat(dec('1.1').roundHalfEven()).equals(dec('1'));
      expectThat(dec('1.0').roundHalfEven()).equals(dec('1'));
      expectThat(dec('-1.0').roundHalfEven()).equals(dec('-1'));
      expectThat(dec('-1.1').roundHalfEven()).equals(dec('-1'));
      expectThat(dec('-1.6').roundHalfEven()).equals(dec('-2'));
      expectThat(dec('-2.5').roundHalfEven()).equals(dec('-2'));
      expectThat(dec('-5.5').roundHalfEven()).equals(dec('-6'));
    });

    test('1', () {
      expectThat(dec('5.5').roundHalfEven(scale: 1)).equals(dec('5.5'));
      expectThat(dec('2.5').roundHalfEven(scale: 1)).equals(dec('2.5'));
      expectThat(dec('1.6').roundHalfEven(scale: 1)).equals(dec('1.6'));
      expectThat(dec('1.1').roundHalfEven(scale: 1)).equals(dec('1.1'));
      expectThat(dec('1.0').roundHalfEven(scale: 1)).equals(dec('1.0'));
      expectThat(dec('1.55').roundHalfEven(scale: 1)).equals(dec('1.6'));
      expectThat(dec('3.145').roundHalfEven(scale: 1)).equals(dec('3.1'));
      expectThat(dec('11.505').roundHalfEven(scale: 1)).equals(dec('11.5'));
      expectThat(dec('12.5645').roundHalfEven(scale: 1)).equals(dec('12.6'));
      expectThat(dec('12.5655').roundHalfEven(scale: 1)).equals(dec('12.6'));
      expectThat(dec('12.4655').roundHalfEven(scale: 1)).equals(dec('12.5'));
      expectThat(dec('14.505').roundHalfEven(scale: 1)).equals(dec('14.5'));
      expectThat(dec('14.504').roundHalfEven(scale: 1)).equals(dec('14.5'));
      expectThat(dec('14.506').roundHalfEven(scale: 1)).equals(dec('14.5'));
      expectThat(dec('14.5').roundHalfEven(scale: 1)).equals(dec('14.5'));
      expectThat(dec('13.055').roundHalfEven(scale: 1)).equals(dec('13.1'));
      expectThat(dec('16.055').roundHalfEven(scale: 1)).equals(dec('16.1'));
      expectThat(dec('17.555').roundHalfEven(scale: 1)).equals(dec('17.6'));
      expectThat(dec('20.555').roundHalfEven(scale: 1)).equals(dec('20.6'));
      expectThat(dec('21.5555').roundHalfEven(scale: 1)).equals(dec('21.6'));
      expectThat(dec('24.5555').roundHalfEven(scale: 1)).equals(dec('24.6'));
    });

    test('2', () {
      expectThat(dec('5.5').roundHalfEven(scale: 2)).equals(dec('5.50'));
      expectThat(dec('2.5').roundHalfEven(scale: 2)).equals(dec('2.50'));
      expectThat(dec('1.6').roundHalfEven(scale: 2)).equals(dec('1.60'));
      expectThat(dec('1.55').roundHalfEven(scale: 2)).equals(dec('1.55'));
      expectThat(dec('1.1').roundHalfEven(scale: 2)).equals(dec('1.10'));
      expectThat(dec('1.0').roundHalfEven(scale: 2)).equals(dec('1.00'));
      expectThat(dec('3.145').roundHalfEven(scale: 2)).equals(dec('3.14'));
      expectThat(dec('11.505').roundHalfEven(scale: 2)).equals(dec('11.50'));
      expectThat(dec('12.5645').roundHalfEven(scale: 2)).equals(dec('12.56'));
      expectThat(dec('12.5655').roundHalfEven(scale: 2)).equals(dec('12.57'));
      expectThat(dec('12.4655').roundHalfEven(scale: 2)).equals(dec('12.47'));
      expectThat(dec('14.505').roundHalfEven(scale: 2)).equals(dec('14.50'));
      expectThat(dec('14.504').roundHalfEven(scale: 2)).equals(dec('14.50'));
      expectThat(dec('14.506').roundHalfEven(scale: 2)).equals(dec('14.51'));
      expectThat(dec('14.5').roundHalfEven(scale: 2)).equals(dec('14.50'));
      expectThat(dec('13.055').roundHalfEven(scale: 2)).equals(dec('13.06'));
      expectThat(dec('16.055').roundHalfEven(scale: 2)).equals(dec('16.06'));
      expectThat(dec('17.555').roundHalfEven(scale: 2)).equals(dec('17.56'));
      expectThat(dec('20.555').roundHalfEven(scale: 2)).equals(dec('20.56'));
      expectThat(dec('21.5555').roundHalfEven(scale: 2)).equals(dec('21.56'));
      expectThat(dec('24.5555').roundHalfEven(scale: 2)).equals(dec('24.56'));
    });
    test('4', () {
      expectThat(dec('0.133656866839782').roundHalfEven(scale: 4))
          .equals(dec('0.1337'));
    });
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
  test('precision', () {
    expectThat(dec('100').precision).equals(3);
    expectThat(dec('10000').precision).equals(5);
    expectThat(dec('-10000').precision).equals(5);
    expectThat(dec('1e5').precision).equals(6);
    expectThat(dec('100.000').precision).equals(3);
    expectThat(dec('100.1').precision).equals(4);
    expectThat(dec('100.0000001').precision).equals(10);
    expectThat(dec('-100.0000001').precision).equals(10);
    expectThat(dec('100.000000000000000000000000000001').precision).equals(33);
    expectThat(dec('0').precision).equals(1);
    expectThat(dec('0.1').precision).equals(2);
    expectThat(dec('0.01').precision).equals(3);
    expectThat(dec('-0.01').precision).equals(3);
  });
  test('scale', () {
    expectThat(dec('100').scale).equals(0);
    expectThat(dec('10000').scale).equals(0);
    expectThat(dec('100.000').scale).equals(0);
    expectThat(dec('100.1').scale).equals(1);
    expectThat(dec('100.0000001').scale).equals(7);
    expectThat(dec('-100.0000001').scale).equals(7);
    expectThat(dec('100.000000000000000000000000000001').scale).equals(30);
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
    expectThat(dec('0').toStringAsExponential(0)).equals('0e+0');
    for (final n in [0, 1, 23, 2.2, 2.499999, 2.5, 2.7, 1.235, -1.2, -0.02]) {
      for (final p in [1, 5, 10]) {
        expectThat(dec(n.toString()).toStringAsExponential(p))
            .equals(n.toStringAsExponential(p));
      }
    }
    // issue https://github.com/a14n/dart-decimal/issues/48
    expectThat(dec('1.7976931348623157e+310').toStringAsExponential(10))
        .equals('1.7976931349e+310');
    // issue https://github.com/a14n/dart-decimal/issues/74
    expectThat(dec('9.9999e+7').toStringAsExponential(2)).equals('1.00e+8');
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
    expectThat(dec('100').pow(0)).equals(dec('1').toRational());
    expectThat(dec('100').pow(1)).equals(dec('100').toRational());
    expectThat(dec('100').pow(2)).equals(dec('10000').toRational());
    expectThat(dec('100').pow(-1)).equals(dec('0.01').toRational());
    expectThat(dec('100').pow(-2)).equals(dec('0.0001').toRational());
    expectThat(dec('0.1').pow(0)).equals(dec('1').toRational());
    expectThat(dec('0.1').pow(1)).equals(dec('0.1').toRational());
    expectThat(dec('0.1').pow(2)).equals(dec('0.01').toRational());
    expectThat(dec('0.1').pow(-1)).equals(dec('10').toRational());
    expectThat(dec('0.1').pow(-2)).equals(dec('100').toRational());
    expectThat(dec('-1').pow(0)).equals(dec('1').toRational());
    expectThat(dec('-1').pow(1)).equals(dec('-1').toRational());
    expectThat(dec('-1').pow(2)).equals(dec('1').toRational());
    expectThat(dec('-1').pow(-1)).equals(dec('-1').toRational());
    expectThat(dec('-1').pow(-2)).equals(dec('1').toRational());
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

  test('Rational.hasFinitePrecision', () {
    const p = Rational.parse;
    for (final r in [
      p('100'),
      p('100.100'),
      p('1') / p('5'),
      (p('1') / p('3')) * p('3'),
      p('0.00000000000000000000001'),
    ]) {
      expectThat(r.hasFinitePrecision).isTrue;
    }
    for (final r in [p('1') / p('3')]) {
      expectThat(r.hasFinitePrecision).isFalse;
    }
  });

  test('Rational.toDecimal', () {
    Rational r(int numerator, int denominator) =>
        Rational.fromInt(numerator, denominator);
    expectThat(r(1, 1).toDecimal()).equals(dec('1'));
    expectThat(() => r(1, 3).toDecimal()).throwsA<AssertionError>();
    expectThat(r(1, 3).toDecimal(scaleOnInfinitePrecision: 1))
        .equals(dec('0.3'));
    expectThat(r(1, 4).toDecimal(scaleOnInfinitePrecision: 1))
        .equals(dec('0.25'));
    expectThat(r(2, 3).toDecimal(
      scaleOnInfinitePrecision: 1,
      toBigInt: (v) => v.round(),
    )).equals(dec('0.7'));
  });

  test('DoubleExt', () {
    expectThat(3.4569.toDecimal()).equals(dec('3.4569'));
    expectThat(1.1.toDecimal()).equals(dec('1.1'));
    expectThat(1.0.toDecimal()).equals(dec('1'));
    expectThat(0.0.toDecimal()).equals(dec('0'));
    expectThat((-1.0).toDecimal()).equals(dec('-1'));
    expectThat((-1.1).toDecimal()).equals(dec('-1.1'));
    expectThat((-3.4569).toDecimal()).equals(dec('-3.4569'));
  });

  test('NumExt', () {
    expectThat(num.parse('3.4569').toDecimal()).equals(dec('3.4569'));
    expectThat(num.parse('1.1').toDecimal()).equals(dec('1.1'));
    expectThat(num.parse('1.0').toDecimal()).equals(dec('1'));
    expectThat(num.parse('0.0').toDecimal()).equals(dec('0'));
    expectThat(num.parse('-1.0').toDecimal()).equals(dec('-1'));
    expectThat(num.parse('-1.1').toDecimal()).equals(dec('-1.1'));
    expectThat(num.parse('-3.4569').toDecimal()).equals(dec('-3.4569'));
  });
}
