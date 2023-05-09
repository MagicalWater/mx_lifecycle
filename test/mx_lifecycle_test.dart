import 'package:flutter_test/flutter_test.dart';
import 'package:mx_lifecycle/mx_lifecycle.dart';
import 'package:mx_lifecycle/mx_lifecycle_platform_interface.dart';
import 'package:mx_lifecycle/mx_lifecycle_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockMxLifecyclePlatform
//     with MockPlatformInterfaceMixin
//     implements MxLifecyclePlatform {
//
//   @override
//   Future<String?> getLifecycleState() {
//     // TODO: implement getLifecycleState
//     throw UnimplementedError();
//   }
// }

void main() {
  final MxLifecyclePlatform initialPlatform = MxLifecyclePlatform.instance;

  test('$MethodChannelMxLifecycle is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMxLifecycle>());
  });

  // test('getPlatformVersion', () async {
  //   MxLifecycle mxLifecyclePlugin = MxLifecycle();
  //   MockMxLifecyclePlatform fakePlatform = MockMxLifecyclePlatform();
  //   MxLifecyclePlatform.instance = fakePlatform;
  //
  //   expect(await mxLifecyclePlugin.getPlatformVersion(), '42');
  // });
}
