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
import 'package:rational/rational.dart';

class DecimalIntl {
  DecimalIntl(Decimal decimal) : this._rational(decimal.toRational());
  DecimalIntl._rational(this._rational);

  factory DecimalIntl._(dynamic number) {
    if (number is DecimalIntl) {
      return number;
    } else if (number is Decimal) {
      return DecimalIntl(number);
    } else if (number is Rational) {
      return DecimalIntl._rational(number);
    } else if (number is BigInt) {
      return DecimalIntl(Decimal.fromBigInt(number));
    } else if (number is int) {
      return DecimalIntl(Decimal.fromInt(number));
    }
    return DecimalIntl(Decimal.parse(number.toString()));
  }

  final Rational _rational;

  bool get isNegative => _rational < Rational.zero;

  DecimalIntl abs() => DecimalIntl._rational(_rational.abs());

  DecimalIntl operator ~/(dynamic other) =>
      DecimalIntl._(_rational ~/ DecimalIntl._(other)._rational);

  DecimalIntl operator +(dynamic other) =>
      DecimalIntl._(_rational + DecimalIntl._(other)._rational);

  DecimalIntl operator -(dynamic other) =>
      DecimalIntl._(_rational - DecimalIntl._(other)._rational);

  DecimalIntl operator *(dynamic other) =>
      DecimalIntl._(_rational * DecimalIntl._(other)._rational);

  DecimalIntl operator /(dynamic other) =>
      DecimalIntl._(_rational / DecimalIntl._(other)._rational);

  DecimalIntl remainder(dynamic other) =>
      DecimalIntl._(_rational.remainder(DecimalIntl._(other)._rational));

  int toInt() => _rational.toBigInt().toInt();

  double toDouble() => _rational.toDouble();

  DecimalIntl round() => DecimalIntl._(_rational.round());

  @override
  bool operator ==(Object other) => _rational == DecimalIntl._(other)._rational;

  @override
  int get hashCode => _rational.hashCode;

  @override
  String toString() => _rational.toString();
}
