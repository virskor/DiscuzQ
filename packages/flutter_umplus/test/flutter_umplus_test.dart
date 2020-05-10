import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_umplus/flutter_umplus.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_umplus');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterUmplus.platformVersion, '42');
  });
}
