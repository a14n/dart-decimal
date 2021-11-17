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
