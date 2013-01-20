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
final _0 = new Decimal.fromInt(0);
final _1 = new Decimal.fromInt(1);
final _5 = new Decimal.fromInt(5);
final _10 = new Decimal.fromInt(10);

Decimal dec(String value) => new Decimal(value);

int _gcd(int a, int b) {
  while (b != 0) {
    int t = b;
    b = a % t;
    a = t;
  }
  return a;
}

class Decimal implements Comparable {
  int _numerator, _denominator;

  Decimal(String value) {
    final match = _PATERN.firstMatch(value);
    if (match == null) throw new FormatException("$value is not a valid format");
    final group1 = match.group(1);
    final group2 = match.group(2);

    if (group2 != null) {
      int denominator = 1;
      for (int i = 1; i < group2.length; i++) {
        denominator = denominator * 10;
      }
      _init(int.parse('${group1}${group2.substring(1)}'), denominator);
    } else {
      _init(int.parse(group1), 1);
    }
  }
  Decimal.fromFraction(int numerator, int denominator) {
    _init(numerator, denominator);
  }
  Decimal.fromInt(int value) {
    _init(value, 1);
  }

  void _init(int numerator, int denominator) {
    if (denominator == 0) throw new IntegerDivisionByZeroException();
    if (numerator == 0) {
      this._numerator = 0;
      this._denominator = 1;
    } else {
      final gcd = _gcd(numerator.abs(), denominator.abs());
      if (denominator < 0) {
        this._numerator = -numerator ~/ gcd;
        this._denominator = -denominator ~/ gcd;
      } else {
        this._numerator = numerator ~/ gcd;
        this._denominator = denominator ~/ gcd;
      }
    }
  }

  bool get isInteger => _denominator == 1;

  bool operator ==(Decimal other) => this._numerator == other._numerator && this._denominator == other._denominator;

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
  Decimal operator %(Decimal other) => this.remainder(other) + (isNegative ? other.abs() : _0);

  /** Division operator. */
  Decimal operator /(Decimal other) => new Decimal.fromFraction(this._numerator * other._denominator, this._denominator * other._numerator);

  /**
   * Truncating division operator.
   *
   * The result of the truncating division [:a ~/ b:] is equivalent to
   * [:(a / b).truncate():].
   */
  Decimal operator ~/(Decimal other) => (this / other).truncate();

  /** Negate operator. */
  Decimal operator -() => new Decimal.fromFraction(-_numerator, _denominator);

  /** Return the remainder from dividing this [num] by [other]. */
  Decimal remainder(Decimal other) => this - (this ~/ other) * other;

  /** Relational less than operator. */
  bool operator <(Decimal other) => this.compareTo(other) < 0;

  /** Relational less than or equal operator. */
  bool operator <=(Decimal other) => this.compareTo(other) <= 0;

  /** Relational greater than operator. */
  bool operator >(Decimal other) => this.compareTo(other) > 0;

  /** Relational greater than or equal operator. */
  bool operator >=(Decimal other) => this.compareTo(other) >= 0;

  bool get isNaN => false;

  bool get isNegative => _numerator < 0;

  bool get isInfinite => false;

  /** Returns the absolute value of this [num]. */
  Decimal abs() => isNegative ? (-this) : this;

  /** Returns the greatest integer value no greater than this [num]. */
  Decimal floor() => isNegative ? (this.truncate() - _1) : this.truncate();

  /** Returns the least integer value that is no smaller than this [num]. */
  Decimal ceil() => isNegative ? this.truncate() : (this.truncate() + _1);

  /**
   * Returns the integer value closest to this [num].
   *
   * Rounds away from zero when there is no closest integer:
   *  [:(3.5).round() == 4:] and [:(-3.5).round() == -4:].
   */
  Decimal round() {
    final abs = this.abs();
    final absBy10 =  abs * _10;
    Decimal dec;
    if (absBy10 % _10 < _5) {
      dec = abs.truncate();
    } else {
      dec = abs.truncate() + _1;
    }
    return isNegative ? -dec : dec;
  }

  /**
   * Returns the integer value obtained by discarding any fractional
   * digits from this [num].
   */
  Decimal truncate() => new Decimal.fromInt(this.toInt());

  /** Truncates this [num] to an integer and returns the result as an [int]. */
  int toInt() => _numerator ~/ _denominator;

  /**
   * Return this [num] as a [double].
   *
   * If the number is not representable as a [double], an
   * approximation is returned. For numerically large integers, the
   * approximation may be infinite.
   */
  double toDouble() => _numerator / _denominator;


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

  /**
   * Converts a [num] to a string in decimal exponential notation with
   * [fractionDigits] digits after the decimal point.
   */
  String toStringAsExponential(int fractionDigits)  => isInteger ? toInt().toStringAsExponential(fractionDigits) : toDouble().toStringAsExponential(fractionDigits);

  /**
   * Converts a [num] to a string representation with [precision]
   * significant digits.
   */
  String toStringAsPrecision(int precision) => isInteger ? toInt().toStringAsPrecision(precision) : toDouble().toStringAsPrecision(precision);

  /**
   * Converts a [num] to a string representation in the given [radix].
   *
   * The [num] in converted to an [int] using [toInt]. That [int] is
   * then converted to a string representation with the given
   * [radix]. In the string representation, lower-case letters are
   * used for digits above '9'.
   *
   * The [radix] argument must be an integer between 2 and 36.
   */
  String toRadixString(int radix) => toInt().toRadixString(radix);
}