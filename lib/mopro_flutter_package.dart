// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/to/pubspec-plugin-platforms.
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'mopro_flutter_types.dart';
import 'mopro_flutter_package_platform_interface.dart';

class MoproFlutterPackage {
  Future<String?> getPlatformVersion() {
    return MoproFlutterPackagePlatform.instance.getPlatformVersion();
  }

  Future<String> copyAssetToFileSystem(String assetPath) async {
    // Load the asset as bytes
    final byteData = await rootBundle.load(assetPath);
    // Get the app's document directory (or other accessible directory)
    final directory = await getApplicationDocumentsDirectory();
    //Strip off the initial dirs from the filename
    assetPath = assetPath.split('/').last;

    final file = File('${directory.path}/$assetPath');

    // Write the bytes to a file in the file system
    await file.writeAsBytes(byteData.buffer.asUint8List());

    return file.path; // Return the file path
  }

  Future<GenerateProofResult?> generateProof(
    String zkeyFile,
    String inputs,
  ) async {
    return await copyAssetToFileSystem(zkeyFile).then((path) async {
      return await MoproFlutterPackagePlatform.instance.generateProof(path, inputs);
    });
  }
}
