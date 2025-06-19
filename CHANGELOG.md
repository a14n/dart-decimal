# 3.2.3 (2025-06-19)

- Fix bad scale value by parsing `0.0` (see [Issue with Decimal.tryParse return value formatting](https://github.com/a14n/dart-decimal/issues/115))

# 3.2.2 (2025-06-15)

- loosen `intl` to `>=0.19.0 <0.21.0` to address [Intl version within flutter_localizations makes version 3.2.1 of decimal impossible to use on Flutter v3.29.3](https://github.com/a14n/dart-decimal/issues/113)
- Bump `lints` to 5.0.0
- [Make `Decimal.zero`, `Decimal.one`, and  `Decimal.ten` final](https://github.com/a14n/dart-decimal/pull/114)

# 3.2.1 (2025-01-20)

- [fix: toString() method for values < 0.1](https://github.com/a14n/dart-decimal/pull/111)

# 3.2.0 (2025-01-19)

- Improve performances

# 3.1.0 (2024-11-22)

- Bump `intl` to 0.20.0, `lints` to 5.0.0
- Bump SDK to 3.3.0 (enables wasm)

# 3.0.2 (2024-06-09)

- Fix #107: avoid exception when formatting decimal with `NumberFormat.compact()`.

# 3.0.1 (2024-06-04)

- Throw `FormatException` on `formatter.parse('NaN')`.

# 3.0.0 (2024-06-02)

- Add `DecimalFormatter` to deal with [intl](https://pub.dev/packages/intl) package. Your can now parse and format decimals.
- Add a dependency to intl.

# 2.3.3 (2023-07-08)

- [Introduce logical operators to DecimalIntl to support intl 0.18.0](https://github.com/a14n/dart-decimal/pull/98)

# 2.3.2 (2022-12-07)

- Update files according to license.

# 2.3.1 (2022-11-24)

- Update license file to be recognized by pub.dev.

# 2.3.0 (2022-09-07)

- (Breaking change) Fix `Decimal.pow` return type. This method now returns a `Rational` because `3.pow(-1)` (similar to `1/3`) could not be represented as a `Decimal`.
- Allow `Rational.toDecimal()` customization via its new `toBigInt` parameter.

# 2.2.0 (2022-04-19)

- Fix [toStringAsExponential returned 10.00e+7 instead of 1.00e+8](https://github.com/a14n/dart-decimal/issues/74)

# 2.1.0 (2021-12-22)

- Fix [toStringAsExponential returns INFINITY](https://github.com/a14n/dart-decimal/issues/48) by implementing `toStringAsExponential` without relying on double implementation.
- Fix issue to have `zero.precision == 1`.

# 2.0.1 (2021-12-20)

- Fix [`toString` issue with negative number between 0 and -1](https://github.com/a14n/dart-decimal/issues/65)

# 2.0.0 (2021-11-29)

The goal of this version is to have sharper types on the API and to avoid having [Decimal] objects that are not decimal numbers (`1/3` for instance).

It introduces several breaking changes.

- `~/` now returns a `BigInt`. If you need a `Decimal` you can convert the `BigInt` to `Decimal` with `bigint.toDecimal()`.
- Removal of `isNaN` getter. It was always returning `false`.
- Removal of `isInfinite` getter. It was always returning `false`.
- Removal of `isNegative` getter. You can replace it with `decimal < Decimal.zero`.
- `inverse`, `/` now return a `Rational`. If you need a `Decimal` you can convert the `Rational` to `Decimal` with `rational.toDecimal(scaleOnInfinitePrecision: xxx)`. If you need to make several computations where inverses or divisions are involved you should make thoses operations on `Rational` type to avoid loosing precision and at the end convert the result back to `Decimal` if you want to display the result in a decimal form.

Other changes:

- `round()`, `floor()`, `ceil()`, `truncate()` now accept an optional `scale` to indicate at which digit the operation should be done.
- Add `shift` to move the decimal point.
- Add extension method `hasFinitePrecision` on `Rational` to know if a decimal form of the rational is possible without loosing precision.
- Add extension method `toDecimal()` on `Rational`.
- Add extension method `toDecimal()` on `int`.
- Add extension method `toDecimal()` on `BigInt`.

# 1.5.0 (2021-11-17)

- Support json serialization as String with `Decimal.fromJson`/`Decimal.toJson`.

# 1.4.0 (2021-11-16)

- Add `Decimal.ten`.
- Add `Decimal.toBigInt`.

# 1.3.0 (2021-07-21)

- Add `Decimal.fromBigInt`.

# 1.2.0 (2021-05-31)

- Add `DecimalIntl` to allow formatting with [intl](https://pub.dev/packages/intl) package.

# 1.1.0 (2021-04-29)

- Allow negative value as exponent of `pow`.

# 1.0.0+1 (2021-03-29)

- Fix typo in the description of the package.

# 1.0.0 (2021-02-25)

- Stable null safety release.

# 1.0.0-nullsafety (2020-11-27)

- Migrate to nullsafety.

# 0.3.5 (2019-09-02)

- [add `Decimal.pow`](https://github.com/a14n/dart-decimal/issues/24).

# 0.3.4 (2019-07-29)

- add `Decimal.zero` and `Decimal.one`.
- add `Decimal.inverse`.

# 0.3.3 (2019-01-16)

- add `Decimal.tryParse`.

# 0.3.2 (2018-07-24)

- migration to Dart 2.

# v0.3.1 (2018-07-10)

- make `Decimal.parse` a factory constructor.

# v0.3.0 (2018-07-10)

- allow parsing of `1.`

# v0.2.0 (2018-04-15)

- move to Dart SDK 2.0

# v0.1.4 (2017-06-16)

- make package strong clean

# v0.1.3 (2014-10-29)

- add `Decimal.signum`
- add `Decimal.hasFinitePrecision`
- add `Decimal.precision`
- add `Decimal.scale`

# Semantic Version Conventions

http://semver.org/

- *Stable*:  All even numbered minor versions are considered API stable:
  i.e.: v1.0.x, v1.2.x, and so on.
- *Development*: All odd numbered minor versions are considered API unstable:
  i.e.: v0.9.x, v1.1.x, and so on.
