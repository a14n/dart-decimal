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

final _PATTERN = new RegExp(r"^(-?\d+)(\.\d+)?$");
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
    final match = _PATTERN.firstMatch(value);
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
    // remove factor 2 and 5 of denominator to know if String representation is finished
    // in decimal system, division by 2 or 5 leads to a finished size of decimal part
    int denominator = _denominator;
    int fractionDigits = 0;
    while (denominator % 2 == 0) {
      denominator = denominator ~/ 2;
      fractionDigits++;
    }
    while (denominator % 5 == 0) {
      denominator = denominator ~/ 5;
      fractionDigits++;
    }
    final hasLimitedLength = _numerator % denominator == 0;
    if (!hasLimitedLength) {
      fractionDigits = 10;
    }
    String asString = toStringAsFixed(fractionDigits);
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
  Decimal floor() => isInteger ? this.truncate() : isNegative ? (this.truncate() - _1) : this.truncate();

  /** Returns the least integer value that is no smaller than this [num]. */
  Decimal ceil() => isInteger ? this.truncate() : isNegative ? this.truncate() : (this.truncate() + _1);

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

  /**
   * Clamps [this] to be in the range [lowerLimit]-[upperLimit]. The comparison
   * is done using [compareTo] and therefore takes [:-0.0:] into account.
   * It also implies that [double.NaN] is treated as the maximal double value.
   */
  Decimal clamp(Decimal lowerLimit, Decimal upperLimit) => this < lowerLimit ? lowerLimit : this > upperLimit ? upperLimit : this;

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
    if (fractionDigits == 0) {
      return round().toInt().toString();
    } else {
      int mul = 1;
      for (int i = 0; i < fractionDigits; i++) {
        mul *= 10;
      }
      final mulDec = new Decimal.fromInt(mul);
      final tmp = (abs() + _1) * mulDec;
      final tmpRound = tmp.round();
      final intPart = ((tmpRound ~/ mulDec) - _1).toInt();
      final decimalPart = tmpRound.toInt().toString().substring(intPart.toString().length);
      return '${isNegative ? '-' : ''}${intPart}.${decimalPart}';
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
}