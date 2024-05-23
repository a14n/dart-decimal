import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

class DartDecimalNumberParser extends NumberParserBase<Decimal?> {
  DartDecimalNumberParser(super.format, super.text);

  @override
  Decimal? fromNormalized(String normalizedText) => Decimal.tryParse(normalizedText);

  @override
  Decimal? nan() => null;

  @override
  Decimal? negativeInfinity() => null;

  @override
  Decimal? positiveInfinity() => null;

  @override
  Decimal? scaled(Decimal? parsed, int scale) =>
      parsed != null ?
      (parsed / Decimal.fromInt(scale)).toDecimal(scaleOnInfinitePrecision: scale) : null;
}
