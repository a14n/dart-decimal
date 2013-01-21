import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';
import 'big_decimal_test.dart' as t;

main() {
  useHtmlConfiguration();
  t.main();
}
