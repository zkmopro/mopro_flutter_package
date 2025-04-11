import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'mopro_flutter_types.dart';
import 'mopro_flutter_package_method_channel.dart';

abstract class MoproFlutterPackagePlatform extends PlatformInterface {
  /// Constructs a MoproFlutterPackagePlatform.
  MoproFlutterPackagePlatform() : super(token: _token);

  static final Object _token = Object();

  static MoproFlutterPackagePlatform _instance =
      MethodChannelMoproFlutterPackage();

  /// The default instance of [MoproFlutterPackagePlatform] to use.
  ///
  /// Defaults to [MethodChannelMoproFlutterPackage].
  static MoproFlutterPackagePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MoproFlutterPackagePlatform] when
  /// they register themselves.
  static set instance(MoproFlutterPackagePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String> getApplicationDocumentsDirectory() {
    throw UnimplementedError('getApplicationDocumentsDirectory() has not been implemented.');
  }

  Future<GenerateProofResult?> generateProof(String zkeyPath, String inputs) {
    throw UnimplementedError('generateProof() has not been implemented.');
  }
}
