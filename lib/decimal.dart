// Copyright (c) 2013, Alexandre Ardhuin
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

library decimal;

import 'package:meta/meta.dart';

final _PATERN = new RegExp(r"^(\-?\d+)(\.\d\d*)?$");

Decimal dec(String value) => new Decimal(value);

int _gcd(int a, int b) {
  while (b != 0) {
    int t = b;
    b = a % t;
    a = t;
  }
  return a;
}
int _abs(int a) => a < 0 ? -a : a;

class Decimal implements Comparable {
  int _numerator, _denominator;

  Decimal(String value) {
    final match = _PATERN.firstMatch(value);
    if (match == null) throw new FormatException("$value is not a valid format");
    final group1 = match.group(1);
    final group2 = match.group(2);

    if (group2 != null) {
      int down = 1;
      for (int i = 1; i < group2.length; i++) {
        down = down * 10;
      }
      _numerator = int.parse('${group1}${group2.substring(1)}');
      _denominator = down;
    } else {
      _numerator = int.parse(group1);
      _denominator = 1;
    }
  }
  Decimal.fromFraction(int numerator, int denominator) {
    if (denominator == 0) throw new IntegerDivisionByZeroException();
    int gcd = _gcd(_abs(numerator), _abs(denominator));
    if (denominator < 0) {
      this._numerator = -numerator ~/ gcd;
      this._denominator = -denominator ~/ gcd;
    } else {
      this._numerator = numerator ~/ gcd;
      this._denominator = denominator ~/ gcd;
    }
  }

  String toStringAsFraction() => '${_numerator}/${_denominator}';

  @override String toString() {
    String asString = toStringAsFixed(10);
    while (asString.contains('.') && (asString.endsWith('0') || asString.endsWith('.'))) {
      asString = asString.substring(0, asString.length - 1);
    }
    return asString;
  }

  // implementation of Comparable

  @override int compareTo(Decimal other) => (this._numerator * other._denominator).compareTo(other._numerator * this._denominator);

  // implementation of num

  /** Addition operator. */
  Decimal operator +(Decimal other) => new Decimal.fromFraction(this._numerator * other._denominator + other._numerator * this._denominator, this._denominator * other._denominator);

  /** Subtraction operator. */
  Decimal operator -(Decimal other) => new Decimal.fromFraction(this._numerator * other._denominator - other._numerator * this._denominator, this._denominator * other._denominator);

  /** Multiplication operator. */
  Decimal operator *(Decimal other) => new Decimal.fromFraction(this._numerator * other._numerator, this._denominator * other._denominator);

  /** Euclidean modulo operator. */
  num operator %(num other) { throw 'unimplemented'; }

  /** Division operator. */
  Decimal operator /(Decimal other) => new Decimal.fromFraction(this._numerator * other._denominator, this._denominator * other._numerator);

  /**
   * Converts a [num] to a string representation with [fractionDigits]
   * digits after the decimal point.
   */
  String toStringAsFixed(int fractionDigits) {
    final intPart = (_numerator < 0 ? -_numerator : _numerator) ~/ _denominator;
    final remining = (_numerator < 0 ? -_numerator : _numerator) % _denominator;
    if (fractionDigits == 0) {
      if (remining * 2 < _denominator) {
        return '${intPart}';
      } else {
        return '${intPart + 1}';
      }
    } else {
      int mul = 10;
      for (int i = 0; i < fractionDigits; i++) {
        mul *= 10;
      }
      final fractionPartPlus1 = (_denominator + remining) * mul ~/ _denominator;
      final roundPart = fractionPartPlus1 % 10 < 5 ? 0 : 1;
      final fractionPart = (fractionPartPlus1 ~/ 10 + roundPart).toString();
      return '${_numerator < 0 ? '-' : ''}$intPart.${fractionPart.toString().substring(1)}';
    }
  }
}