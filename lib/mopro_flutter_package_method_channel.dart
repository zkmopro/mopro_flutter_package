import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'mopro_flutter_package_platform_interface.dart';
import 'mopro_flutter_types.dart';

/// An implementation of [MoproFlutterPackagePlatform] that uses method channels.
class MethodChannelMoproFlutterPackage extends MoproFlutterPackagePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('mopro_flutter_package');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<String> getApplicationDocumentsDirectory() async {
    final directory = await methodChannel.invokeMethod<String>(
      'getApplicationDocumentsDirectory',
    );
    return directory ?? '';
  }

  @override
  Future<GenerateProofResult?> generateProof(
    String zkeyPath,
    String inputs,
  ) async {
    final proofResult = await methodChannel.invokeMethod<Map<Object?, Object?>>(
      'generateProof',
      {'zkeyPath': zkeyPath, 'inputs': inputs},
    );

    if (proofResult == null) {
      return null;
    }

    var generateProofResult = GenerateProofResult.fromMap(proofResult);

    return generateProofResult;
  }
}
