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

import 'package:rational/rational.dart';

final _i0 = BigInt.zero;
final _i1 = BigInt.one;
final _i2 = BigInt.two;
final _i5 = BigInt.from(5);
final _r10 = Rational.fromInt(10);

/// A number that can be exactly written with a finite number of digits in the
/// decimal system.
class Decimal implements Comparable<Decimal> {
  /// Create a new decimal from its rational value.
  Decimal._(this._rational) : assert(_rational.hasFinitePrecision);

  /// Create a new [Decimal] from a [BigInt].
  factory Decimal.fromBigInt(BigInt value) => value.toRational().toDecimal();

  /// Create a new [Decimal] from an [int].
  factory Decimal.fromInt(int value) => Decimal.fromBigInt(BigInt.from(value));

  /// Create a new [Decimal] from its [String] representation.
  factory Decimal.fromJson(String value) => Decimal.parse(value);

  final Rational _rational;

  /// Parses [source] as a decimal literal and returns its value as [Decimal].
  static Decimal parse(String source) => Rational.parse(source).toDecimal();

  /// Parses [source] as a decimal literal and returns its value as [Decimal].
  static Decimal? tryParse(String source) {
    try {
      return Decimal.parse(source);
    } on FormatException {
      return null;
    }
  }

  /// The [Decimal] corresponding to `0`.
  static Decimal zero = Decimal.fromInt(0);

  /// The [Decimal] corresponding to `1`.
  static Decimal one = Decimal.fromInt(1);

  /// The [Decimal] corresponding to `10`.
  static Decimal ten = Decimal.fromInt(10);

  /// The [Rational] corresponding to `this`.
  Rational toRational() => _rational;

  /// Returns `true` if `this` is an integer.
  bool get isInteger => _rational.isInteger;

  /// Returns a [Rational] corresponding to `1/this`.
  Rational get inverse => _rational.inverse;

  @override
  bool operator ==(Object other) =>
      other is Decimal && _rational == other._rational;

  @override
  int get hashCode => _rational.hashCode;

  /// Returns a [String] representation of `this`.
  @override
  String toString() {
    if (_rational.isInteger) return _rational.toString();
    var value = toStringAsFixed(scale);
    while (
        value.contains('.') && (value.endsWith('0') || value.endsWith('.'))) {
      value = value.substring(0, value.length - 1);
    }
    return value;
  }

  /// Converts `this` to [String] by using [toString].
  String toJson() => toString();

  @override
  int compareTo(Decimal other) => _rational.compareTo(other._rational);

  /// Addition operator.
  Decimal operator +(Decimal other) =>
      (_rational + other._rational).toDecimal();

  /// Subtraction operator.
  Decimal operator -(Decimal other) =>
      (_rational - other._rational).toDecimal();

  /// Multiplication operator.
  Decimal operator *(Decimal other) =>
      (_rational * other._rational).toDecimal();

  /// Euclidean modulo operator.
  ///
  /// See [num.operator%].
  Decimal operator %(Decimal other) =>
      (_rational % other._rational).toDecimal();

  /// Division operator.
  Rational operator /(Decimal other) => _rational / other._rational;

  /// Truncating division operator.
  ///
  /// See [num.operator~/].
  BigInt operator ~/(Decimal other) => _rational ~/ other._rational;

  /// Returns the negative value of this rational.
  Decimal operator -() => (-_rational).toDecimal();

  /// Return the remainder from dividing this [Decimal] by [other].
  Decimal remainder(Decimal other) =>
      (_rational.remainder(other._rational)).toDecimal();

  /// Whether this number is numerically smaller than [other].
  bool operator <(Decimal other) => _rational < other._rational;

  /// Whether this number is numerically smaller than or equal to [other].
  bool operator <=(Decimal other) => _rational <= other._rational;

  /// Whether this number is numerically greater than [other].
  bool operator >(Decimal other) => _rational > other._rational;

  /// Whether this number is numerically greater than or equal to [other].
  bool operator >=(Decimal other) => _rational >= other._rational;

  /// Returns the absolute value of `this`.
  Decimal abs() => _rational.abs().toDecimal();

  /// The signum function value of `this`.
  ///
  /// E.e. -1, 0 or 1 as the value of this [Decimal] is negative, zero or positive.
  int get signum => _rational.signum;

  /// Returns the greatest [Decimal] value no greater than this [Rational].
  ///
  /// An optional [scale] value can be provided as parameter to indicate the
  /// digit used as reference for the operation.
  ///
  /// ```
  /// var x = Decimal.parse('123.4567');
  /// x.floor(); // 123
  /// x.floor(scale: 1); // 123.4
  /// x.floor(scale: 2); // 123.45
  /// x.floor(scale: -1); // 120
  /// ```
  Decimal floor({int scale = 0}) => _scaleAndApply(scale, (e) => e.floor());

  /// Returns the least [Decimal] value that is no smaller than this [Rational].
  ///
  /// An optional [scale] value can be provided as parameter to indicate the
  /// digit used as reference for the operation.
  ///
  /// ```
  /// var x = Decimal.parse('123.4567');
  /// x.ceil(); // 124
  /// x.ceil(scale: 1); // 123.5
  /// x.ceil(scale: 2); // 123.46
  /// x.ceil(scale: -1); // 130
  /// ```
  Decimal ceil({int scale = 0}) => _scaleAndApply(scale, (e) => e.ceil());

  /// Returns the [Decimal] value closest to this number.
  ///
  /// Rounds away from zero when there is no closest integer:
  /// `(3.5).round() == 4` and `(-3.5).round() == -4`.
  ///
  /// An optional [scale] value can be provided as parameter to indicate the
  /// digit used as reference for the operation.
  ///
  /// ```
  /// var x = Decimal.parse('123.4567');
  /// x.round(); // 123
  /// x.round(scale: 1); // 123.5
  /// x.round(scale: 2); // 123.46
  /// x.round(scale: -1); // 120
  /// ```
  Decimal round({int scale = 0}) => _scaleAndApply(scale, (e) => e.round());

  Decimal _scaleAndApply(int scale, BigInt Function(Rational) f) {
    final scaleFactor = ten.pow(scale).toRational();
    return (f(_rational * scaleFactor).toRational() / scaleFactor).toDecimal();
  }

  /// The [BigInt] obtained by discarding any fractional digits from `this`.
  Decimal truncate({int scale = 0}) =>
      _scaleAndApply(scale, (e) => e.truncate());

  /// Shift the decimal point on the right for positive [value] or on the left
  /// for negative one.
  ///
  /// ```dart
  /// var x = Decimal.parse('123.4567');
  /// x.shift(1); // 1234.567
  /// x.shift(-1); // 12.34567
  /// ```
  Decimal shift(int value) => this * ten.pow(value);

  /// Clamps `this` to be in the range [lowerLimit]-[upperLimit].
  Decimal clamp(Decimal lowerLimit, Decimal upperLimit) =>
      _rational.clamp(lowerLimit._rational, upperLimit._rational).toDecimal();

  /// The [BigInt] obtained by discarding any fractional digits from `this`.
  BigInt toBigInt() => _rational.toBigInt();

  /// Returns `this` as a [double].
  ///
  /// If the number is not representable as a [double], an approximation is
  /// returned. For numerically large integers, the approximation may be
  /// infinite.
  double toDouble() => _rational.toDouble();

  /// The precision of this [Decimal].
  ///
  /// The precision is the number of digits in the unscaled value.
  ///
  /// ```dart
  /// Decimal.parse('0').precision; // => 1
  /// Decimal.parse('1').precision; // => 1
  /// Decimal.parse('1.5').precision; // => 2
  /// Decimal.parse('0.5').precision; // => 2
  /// ```
  int get precision {
    final value = abs();
    return value.scale + value.toBigInt().toString().length;
  }

  /// The scale of this [Decimal].
  ///
  /// The scale is the number of digits after the decimal point.
  ///
  /// ```dart
  /// Decimal.parse('1.5').scale; // => 1
  /// Decimal.parse('1').scale; // => 0
  /// ```
  int get scale {
    var i = 0;
    var x = _rational;
    while (!x.isInteger) {
      i++;
      x *= _r10;
    }
    return i;
  }

  /// A decimal-point string-representation of this number with [fractionDigits]
  /// digits after the decimal point.
  String toStringAsFixed(int fractionDigits) {
    assert(fractionDigits >= 0);
    if (fractionDigits == 0) return round().toBigInt().toString();
    final value = round(scale: fractionDigits);
    final intPart = value.toBigInt().abs();
    final decimalPart =
        (one + value.abs() - intPart.toDecimal()).shift(fractionDigits);
    return '${value < zero ? '-' : ''}$intPart.${decimalPart.toString().substring(1)}';
  }

  /// An exponential string-representation of this number with [fractionDigits]
  /// digits after the decimal point.
  String toStringAsExponential([int fractionDigits = 0]) {
    assert(fractionDigits >= 0);

    final negative = this < zero;
    var value = abs();
    var eValue = 0;
    while (value < one && value > zero) {
      value *= ten;
      eValue--;
    }
    while (value >= ten) {
      value = (value / ten).toDecimal();
      eValue++;
    }

    var roundedValue = value.round(scale: fractionDigits);

    // If the rounded value is bigger than 10, then divide it once more
    // to make it follow the normalized scientific notation.
    if (roundedValue >= ten) {
      value = (value / ten).toDecimal();
      eValue++;

      roundedValue = value.round(scale: fractionDigits);
    }

    return <String>[
      if (negative) '-',
      roundedValue.toStringAsFixed(fractionDigits),
      'e',
      if (eValue >= 0) '+',
      '$eValue',
    ].join();
  }

  /// A string representation with [precision] significant digits.
  String toStringAsPrecision(int precision) {
    assert(precision > 0);

    if (this == zero) {
      return <String>[
        '0',
        if (precision > 1) '.',
        for (var i = 1; i < precision; i++) '0',
      ].join();
    }

    final limit = ten.pow(precision);

    var shift = one;
    final absValue = abs();
    var pad = 0;
    while (absValue * shift < limit) {
      pad++;
      shift *= ten;
    }
    while (absValue * shift >= limit) {
      pad--;
      shift = (shift / ten).toDecimal();
    }
    final value = ((this * shift).round() / shift).toDecimal();
    return pad <= 0 ? value.toString() : value.toStringAsFixed(pad);
  }

  /// Returns `this` to the power of [exponent].
  ///
  /// Returns [one] if the [exponent] equals `0`.
  Decimal pow(int exponent) => _rational.pow(exponent).toDecimal();
}

/// Extensions on [Rational].
extension RationalExt on Rational {
  /// Returns a [Decimal] corresponding to `this`.
  ///
  /// Some rational like `1/3` can not be converted to decimal because they need
  /// an infinite number of digits. For those cases (where [hasFinitePrecision]
  /// is `false`) a [scaleOnInfinitePrecision] can be provided to truncate its
  /// decimal representation. Note that the returned decimal will not be exactly
  /// equal to `this`.
  Decimal toDecimal({int? scaleOnInfinitePrecision}) {
    if (scaleOnInfinitePrecision == null || hasFinitePrecision) {
      return Decimal._(this);
    }
    final scaleFactor = _r10.pow(scaleOnInfinitePrecision);
    return Decimal._(
        (this * scaleFactor).truncate().toRational() / scaleFactor);
  }

  /// Returns `true` if this [Rational] has a finite precision.
  ///
  /// Having a finite precision means that the number can be exactly represented
  /// as decimal with a finite number of fractional digits.
  bool get hasFinitePrecision {
    // the denominator should only be a product of powers of 2 and 5
    var den = denominator;
    while (den % _i5 == _i0) {
      den = den ~/ _i5;
    }
    while (den % _i2 == _i0) {
      den = den ~/ _i2;
    }
    return den == _i1;
  }
}

/// Extensions on [BigInt].
extension BigIntExt on BigInt {
  /// This [BigInt] as a [Decimal].
  Decimal toDecimal() => Decimal.fromBigInt(this);
}

/// Extensions on [int].
extension IntExt on int {
  /// This [int] as a [Decimal].
  Decimal toDecimal() => Decimal.fromInt(this);
}
