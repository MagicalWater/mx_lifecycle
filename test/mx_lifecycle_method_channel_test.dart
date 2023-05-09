import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mx_lifecycle/mx_lifecycle_method_channel.dart';

void main() {
  MethodChannelMxLifecycle platform = MethodChannelMxLifecycle();
  const MethodChannel channel = MethodChannel('mx_lifecycle');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  // test('getPlatformVersion', () async {
  //   expect(await platform.getPlatformVersion(), '42');
  // });
}
