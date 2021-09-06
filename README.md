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
by wrapping the decimal into `DecimalIntl` from the `package:decimal/intl.dart`
library:

```dart
import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';

main() {
  var value = Decimal.parse('1234.56');
  var formatter = NumberFormat.decimalPattern('en-US');
  print(formatter.format(DecimalIntl(value)));
}
```

Tip: you can define an extension to make it less verbose:

```dart
extension on Decimal {
  String formatWith(NumberFormat formatter) => formatter.format(DecimalIntl(this));
}
main() {
  var value = Decimal.parse('1234.56');
  var formatter = NumberFormat.decimalPattern('en-US');
  print(value.formatWith(formatter));
}
```

## License
Apache 2.0
