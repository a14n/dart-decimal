# Dart Decimals

[![Build Status](https://github.com/a14n/dart-decimal/actions/workflows/dart.yml/badge.svg)](https://github.com/a14n/dart-decimal/actions/workflows/dart.yml)

This project enable to make computations on decimal numbers without losing precision like double operations.

For instance :

```dart
// with double
print(0.2 + 0.1); // displays 0.30000000000000004

// with decimal
print(Decimal.parse('0.2') + Decimal.parse('0.1')); // displays 0.3
```

## Usage
To use this library in your code :
* add a dependency in your `pubspec.yaml` :

```yaml
dependencies:
  decimal:
```

* add import in your `dart` code :

```dart
import 'package:decimal/decimal.dart';
```

* Start computing using `Decimal.parse('1.23')`.

_Hint_ : To make your code shorter you can define a shortcut for Decimal.parse :

```dart
final d = (String s) => Decimal.parse(s);
d('0.2') + d('0.1'); // => 0.3
```

## Formatting with intl

You can use the [intl](https://pub.dev/packages/intl) package to format decimal
with `DecimalFormat` from the `package:decimal/intl.dart` library:

```dart
import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';

main() {
  var value = Decimal.parse('1234.56');
  var formatter = DecimalFormatter(NumberFormat.decimalPattern('en-US'));
  print(formatter.format(value));
}
```

Tip: you can define an extension to make it more fluent:

```dart
extension on Decimal {
  String formatWith(NumberFormat formatter) => formatter.format(DecimalIntl(this));
}
main() {
  var value = Decimal.parse('1234.56');
  var formatter = DecimalFormatter(NumberFormat.decimalPattern('en-US'));
  print(value.formatWith(formatter));
}
```

WARNING: For now (2024.05.30) intl doesn't work with `NumberFormat.maximumFractionDigits` greater than 15 on web plateform and 18 otherwise.

## Parsing with intl

You can use the `NumberFormat` from [intl](https://pub.dev/packages/intl) package to parse formatted decimals

```dart
var currencyFormatter = DecimalFormatter(NumberFormat.simpleCurrency(name: 'USD'));
currencyFormatter.parse('\$3.14'); // => 3.14
```

## Default precision for infinite-precision rationals

When a computation results in a non-terminating rational (for example `1/3`),
converting it back to a `Decimal` requires choosing how many fractional digits
to keep. By default, calling `toDecimal()` on such rationals throws to avoid
silent precision choices.

You can set a global default number of fractional digits that will be used
app-wide whenever the scale is not explicitly provided:

```dart
// Set once at app start
Decimal.defaultScaleOnInfinitePrecision = 20; // preferred
// or the short alias:
Decimal.defaultPrecision = 20;

final one = Decimal.parse('1');
final three = Decimal.parse('3');

// Division returns a Rational; with the default set, toDecimal() uses it:
final approx = (one / three).toDecimal();
print(approx); // 0.33333333333333333333 (20 fractional digits)

// You can still override per call:
final approx4 = (one / three).toDecimal(scaleOnInfinitePrecision: 4);
print(approx4); // 0.3333

// Resetting to null restores the original throwing behavior
Decimal.defaultScaleOnInfinitePrecision = null;
// (one / three).toDecimal(); // throws AssertionError
```

Where this default is used (from `lib/decimal.dart`):

- When calling `Rational.toDecimal()` via the extension on `Rational` and the
  rational does not have finite precision, if you do not pass
  `scaleOnInfinitePrecision`, the library will use
  `Decimal.defaultScaleOnInfinitePrecision` (or `Decimal.defaultPrecision`) if
  set; otherwise it throws. All other internal conversions in `decimal.dart`
  operate on finite-precision rationals and do not consult this default.

## License
Apache 2.0
