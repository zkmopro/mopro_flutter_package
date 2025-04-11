import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'mopro_flutter_package_platform_interface.dart';

/// An implementation of [MoproFlutterPackagePlatform] that uses method channels.
class MethodChannelMoproFlutterPackage extends MoproFlutterPackagePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('mopro_flutter_package');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
