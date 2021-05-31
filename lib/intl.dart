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
import 'package:decimal/decimal.dart';

class DecimalIntl {
  DecimalIntl(this.decimal);

  factory DecimalIntl._(dynamic number) {
    if (number is DecimalIntl) {
      return number;
    } else if (number is Decimal) {
      return DecimalIntl(number);
    } else if (number is int) {
      return DecimalIntl(Decimal.fromInt(number));
    }
    return DecimalIntl(Decimal.parse(number.toString()));
  }

  final Decimal decimal;

  bool get isNegative => decimal.isNegative;

  DecimalIntl abs() => DecimalIntl(decimal.abs());

  DecimalIntl operator ~/(dynamic other) =>
      DecimalIntl(decimal ~/ DecimalIntl._(other).decimal);

  DecimalIntl operator +(dynamic other) =>
      DecimalIntl(decimal + DecimalIntl._(other).decimal);

  DecimalIntl operator -(dynamic other) =>
      DecimalIntl(decimal - DecimalIntl._(other).decimal);

  DecimalIntl operator *(dynamic other) =>
      DecimalIntl(decimal * DecimalIntl._(other).decimal);

  DecimalIntl operator /(dynamic other) =>
      DecimalIntl(decimal / DecimalIntl._(other).decimal);

  DecimalIntl remainder(dynamic other) =>
      DecimalIntl(decimal.remainder(DecimalIntl._(other).decimal));

  int toInt() => decimal.toInt();

  double toDouble() => decimal.toDouble();

  DecimalIntl round() => DecimalIntl(decimal.round());

  @override
  bool operator ==(Object other) => decimal == DecimalIntl._(other).decimal;

  @override
  int get hashCode => decimal.hashCode;

  @override
  String toString() => decimal.toString();
}
