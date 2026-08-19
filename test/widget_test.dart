import 'package:echo_ink/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

void main() {
  testWidgets('EchoInk starts on its splash screen', (tester) async {
    await Hive.initFlutter();
    journalBox = await Hive.openBox<dynamic>('test_journals');
    await tester.pumpWidget(const EchoInkApp());
    expect(find.text('EchoInk'), findsNothing);
  });
}
