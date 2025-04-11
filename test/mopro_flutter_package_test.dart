import 'package:flutter_test/flutter_test.dart';
import 'package:mopro_flutter_package/mopro_flutter_package.dart';
import 'package:mopro_flutter_package/mopro_flutter_package_platform_interface.dart';
import 'package:mopro_flutter_package/mopro_flutter_package_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMoproFlutterPackagePlatform
    with MockPlatformInterfaceMixin
    implements MoproFlutterPackagePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MoproFlutterPackagePlatform initialPlatform = MoproFlutterPackagePlatform.instance;

  test('$MethodChannelMoproFlutterPackage is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMoproFlutterPackage>());
  });

  test('getPlatformVersion', () async {
    MoproFlutterPackage moproFlutterPackagePlugin = MoproFlutterPackage();
    MockMoproFlutterPackagePlatform fakePlatform = MockMoproFlutterPackagePlatform();
    MoproFlutterPackagePlatform.instance = fakePlatform;

    expect(await moproFlutterPackagePlugin.getPlatformVersion(), '42');
  });
}
