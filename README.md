# Dart Decimals

[![Build Status](https://travis-ci.org/a14n/dart-decimal.svg?branch=master)](https://travis-ci.org/a14n/dart-decimal)

This project enable to make computations on decimal numbers without loosing precision like double operations.

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
  decimal: ^0.3.0
```

* add import in your `dart` code :

```dart
import 'package:decimal/decimal.dart';
```

* Start computing using `Decimal.parse('1.23')`.

_Hint_ : To make your code shorter you can define a shortcut for Decimal.parse :

```dart
final d = Decimal.parse;
d('0.2') + d('0.1'); // => 0.3
```

## License
Apache 2.0
