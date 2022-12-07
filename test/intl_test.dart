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
import 'package:decimal/intl.dart';
import 'package:expector/expector.dart';
import 'package:intl/intl.dart';
import 'package:test/test.dart' show test;

Decimal dec(String value) => Decimal.parse(value);

void main() {
  test('Number.format output the same result as with double', () {
    final formats = <NumberFormat>[
      NumberFormat.decimalPattern('en-US'),
      NumberFormat.decimalPattern('fr-FR'),
    ];
    final numbers = <String>[
      '0',
      '1',
      '-1.123',
      '123456789.0123',
    ];
    for (var format in formats) {
      for (var number in numbers) {
        expectThat(format.format(DecimalIntl(Decimal.parse(number))))
            .equals(format.format(double.parse(number)));
      }
    }
  });
}
