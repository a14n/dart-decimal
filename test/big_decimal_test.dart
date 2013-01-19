import 'package:unittest/unittest.dart';
import 'package:decimal/decimal.dart';

main() {
  test('decimal string validation', () {
    expect(() => new Decimal('1'), returnsNormally);
    expect(() => new Decimal('-1'), returnsNormally);
    expect(() => new Decimal('1.'), throws);
    expect(() => new Decimal('1.0'), returnsNormally);
  });
  test('decimal representation', () {
    ['0', '1', '-1', '-1.1', '23', '31878018903828899277492024491376690701584023926880.1'].forEach((String n) {
      expect(new Decimal(n).toString(), equals(n));
    });
  });
  test('decimal toStringAsFixed', () {
    [0, 1, 23, 2.2, 2.499999, 2.5, 2.7, 1.235].forEach((num n) {
      [0, 1, 5, 10].forEach((p) {
        expect(dec(n.toString()).toStringAsFixed(p), equals(n.toStringAsFixed(p)));
      });
    });
  });
  test('decimal comparaison', () {
    expect(dec('1').compareTo(dec('1')), equals(0));
    expect(dec('1').compareTo(dec('1.0')), equals(0));
    expect(dec('1').compareTo(dec('1.1')), equals(-1));
    expect(dec('1').compareTo(dec('0.9')), equals(1));
  });
  test('decimal addition', () {
    expect((dec('1') + dec('1')).toString(), equals('2'));
    expect((dec('1.1') + dec('1')).toString(), equals('2.1'));
    expect((dec('1.1') + dec('0.9')).toString(), equals('2'));
    expect((dec('31878018903828899277492024491376690701584023926880.0') + dec('0.9')).toString(), equals('31878018903828899277492024491376690701584023926880.9'));
  });
  test('decimal soustraction', () {
    expect((dec('1') - dec('1')).toString(), equals('0'));
    expect((dec('1.1') - dec('1')).toString(), equals('0.1'));
    expect((dec('0.1') - dec('1.1')).toString(), equals('-1'));
    expect((dec('31878018903828899277492024491376690701584023926880.0') - dec('0.9')).toString(), equals('31878018903828899277492024491376690701584023926879.1'));
  });
  test('decimal multiplication', () {
    expect((dec('1') * dec('1')).toString(), equals('1'));
    expect((dec('1.1') * dec('1')).toString(), equals('1.1'));
    expect((dec('1.1') * dec('0.1')).toString(), equals('0.11'));
    expect((dec('1.1') * dec('0')).toString(), equals('0'));
    expect((dec('31878018903828899277492024491376690701584023926880.0') * dec('10')).toString(), equals('318780189038288992774920244913766907015840239268800'));
  });
  test('decimal division', () {
    expect(() => dec('1') / dec('0'), throws);
    expect((dec('1') / dec('1')).toString(), equals('1'));
    expect((dec('1.1') / dec('1')).toString(), equals('1.1'));
    expect((dec('1.1') / dec('0.1')).toString(), equals('11'));
    expect((dec('0') / dec('0.2315')).toString(), equals('0'));
    expect((dec('31878018903828899277492024491376690701584023926880.0') / dec('10')).toString(), equals('3187801890382889927749202449137669070158402392688'));
  });
}
