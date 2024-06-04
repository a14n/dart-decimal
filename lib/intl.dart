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

import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';
import 'package:rational/rational.dart';

class DecimalFormatter {
  DecimalFormatter(this.numberFormat);

  final NumberFormat numberFormat;

  /// Parses [text] as a decimal literal using the provided number formatter and returns its value as [Decimal]
  Decimal parse(String text) =>
      _DartDecimalNumberParser(numberFormat, text).value!;

  /// Parses [text] as a decimal literal using the provided number formatter and returns its value as [Decimal], or null if the parsing fails.
  Decimal? tryParse(String text) {
    try {
      return parse(text);
    } on FormatException {
      return null;
    }
  }

  /// Format [number] according to our pattern and return the formatted string.
  String format(Decimal number) => numberFormat.format(_DecimalIntl(number));
}

class _DecimalIntl {
  _DecimalIntl(Decimal decimal) : this._rational(decimal.toRational());

  _DecimalIntl._rational(this._rational);

  factory _DecimalIntl._(dynamic number) {
    if (number is _DecimalIntl) {
      return number;
    } else if (number is Decimal) {
      return _DecimalIntl(number);
    } else if (number is Rational) {
      return _DecimalIntl._rational(number);
    } else if (number is BigInt) {
      return _DecimalIntl(Decimal.fromBigInt(number));
    } else if (number is int) {
      return _DecimalIntl(Decimal.fromInt(number));
    }
    return _DecimalIntl(Decimal.parse(number.toString()));
  }

  final Rational _rational;

  bool get isNegative => _rational < Rational.zero;

  _DecimalIntl abs() => _DecimalIntl._rational(_rational.abs());

  _DecimalIntl operator ~/(dynamic other) =>
      _DecimalIntl._(_rational ~/ _DecimalIntl._(other)._rational);

  _DecimalIntl operator +(dynamic other) =>
      _DecimalIntl._(_rational + _DecimalIntl._(other)._rational);

  _DecimalIntl operator -(dynamic other) =>
      _DecimalIntl._(_rational - _DecimalIntl._(other)._rational);

  _DecimalIntl operator *(dynamic other) =>
      _DecimalIntl._(_rational * _DecimalIntl._(other)._rational);

  _DecimalIntl operator /(dynamic other) =>
      _DecimalIntl._(_rational / _DecimalIntl._(other)._rational);

  bool operator <(dynamic other) => _rational < _DecimalIntl._(other)._rational;

  bool operator <=(dynamic other) =>
      _rational <= _DecimalIntl._(other)._rational;

  bool operator >(dynamic other) => _rational > _DecimalIntl._(other)._rational;

  bool operator >=(dynamic other) =>
      _rational >= _DecimalIntl._(other)._rational;

  _DecimalIntl remainder(dynamic other) =>
      _DecimalIntl._(_rational.remainder(_DecimalIntl._(other)._rational));

  int toInt() => _rational.toBigInt().toInt();

  double toDouble() => _rational.toDouble();

  _DecimalIntl round() => _DecimalIntl._(_rational.round());

  @override
  bool operator ==(Object other) =>
      _rational == _DecimalIntl._(other)._rational;

  @override
  int get hashCode => _rational.hashCode;

  @override
  String toString() => _rational.toString();
}

class _DartDecimalNumberParser extends NumberParserBase<Decimal> {
  _DartDecimalNumberParser(super.format, super.text);

  @override
  Decimal fromNormalized(String normalizedText) =>
      Decimal.parse(normalizedText);

  @override
  Decimal nan() => throw FormatException('Could not parse Decimal');

  @override
  Decimal negativeInfinity() =>
      throw FormatException('Could not parse Decimal');

  @override
  Decimal positiveInfinity() =>
      throw FormatException('Could not parse Decimal');

  @override
  Decimal scaled(Decimal parsed, int scale) => (parsed / Decimal.fromInt(scale))
      .toDecimal(scaleOnInfinitePrecision: scale);
}
