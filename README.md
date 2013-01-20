Dart Decimals
=============
This project enable to make computations on decimal numbers without loosing precision like double operations.

For instance :

```dart
// with double
print(0.2 + 0.1); // displays 0.30000000000000004

// with decimal
print(dec('0.2') + dec('0.1')); // displays 0.3
```

## Usage ##
To use this library in your code :
* add a dependency in your `pubspec.yaml` :

```yaml
dependencies:
  decimal: '<1.0.0'
```

* add import in your `dart` code :

```dart
import 'package:decimal/decimal.dart';
```

* Start computing using `dec('1.23')`.

## License ##
Apache 2.0
