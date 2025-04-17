# Mopro Flutter Package

A Flutter plugin for running Circom zero-knowledge proofs (Groth16 with Arkworks backend) on mobile platforms (iOS/Android). This package allows you to generate proofs based on a compiled Circom circuit (`.zkey` file) and inputs, and also verify these proofs.

## Getting Started

This project provides a Flutter interface to the underlying `mopro-core` library which handles the ZK proof generation and verification.

### Prerequisites

*   Flutter SDK installed.
*   A compiled Circom circuit (`<circuit_name>_final.zkey` file).

### Installation

1.  Add `mopro_flutter_package` as a dependency in your `pubspec.yaml` file:

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      mopro_flutter_package: # Add the correct version or path/git dependency
        # Example using path dependency (if the package is local):
        # path: ../path/to/mopro_flutter_package
        # Or specify the version from pub.dev once published
        # version: ^0.1.0 
    ```

2.  Include your Circom `.zkey` file as an asset in your Flutter project. Add the asset path to your `pubspec.yaml`:

    ```yaml
    flutter:
      uses-material-design: true
      assets:
        - assets/circuits/ # Or the specific path to your .zkey file
        # Example: - assets/circuits/multiplier2_final.zkey 
    ```

3.  Run `flutter pub get` in your terminal to install the package.

## Usage

Here's a basic example demonstrating how to generate and verify a proof for a simple multiplier circuit (`multiplier2.circom`) where `c = a * b`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // Required for loading assets
import 'package:mopro_flutter_package/mopro_flutter_package.dart';
import 'dart:convert'; // Required for jsonEncode

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mopro ZK Proof Example'),
        ),
        body: const Center(
          child: ZkProofWidget(),
        ),
      ),
    );
  }
}

class ZkProofWidget extends StatefulWidget {
  const ZkProofWidget({super.key});

  @override
  _ZkProofWidgetState createState() => _ZkProofWidgetState();
}

class _ZkProofWidgetState extends State<ZkProofWidget> {
  String _status = 'Idle';
  final MoproFlutterPackage _mopro = MoproFlutterPackage();

  @override
  void initState() {
    super.initState();
    // Initialize Mopro (optional, might be needed for specific setup)
    // _mopro.initialize(); 
  }

  Future<void> _runZkProofLogic() async {
    setState(() => _status = 'Loading circuit...');

    try {
      // --- 1. Load the Zkey Asset ---
      // Note: Accessing assets directly by path might be platform-specific. 
      // A robust solution involves copying the asset to a temporary directory 
      // accessible by the native code. This example assumes direct path access 
      // might work or needs adaptation based on platform specifics.
      // TODO: Implement robust asset handling (copying to accessible temp path)
      const String zkeyAssetName = 'assets/circuits/multiplier2_final.zkey'; 
      // For now, we pass the asset name; native side needs to resolve it.
      // Or, implement asset copying logic here.

      // --- 2. Prepare Inputs ---
      setState(() => _status = 'Preparing inputs...');
      const int a = 3;
      const int b = 5;
      final Map<String, List<String>> inputs = {
        'a': [a.toString()],
        'b': [b.toString()],
      };
      final String inputsJson = jsonEncode(inputs);

      // Expected outputs (public signals) for verification later
      final List<String> expectedOutputs = [(a * b).toString(), a.toString()]; 

      // --- 3. Generate Proof ---
      setState(() => _status = 'Generating proof...');
      final GenerateProofResult proofResult = await _mopro.generateProof(
        zkeyPath: zkeyAssetName, // Pass the asset path/name
        inputs: inputsJson,
      );

      setState(() => _status = 'Proof generated. Verifying...');

      // --- 4. Verify Proof ---
      final bool isValid = await _mopro.verifyProof(
        zkeyPath: zkeyAssetName, // Pass the asset path/name
        proof: proofResult.proof,
        inputs: proofResult.inputs, // Use inputs returned by generateProof
      );

      setState(() {
        if (isValid) {
          // Optional: Compare generated inputs/public signals with expected ones
          if (listEquals(proofResult.inputs, expectedOutputs)) {
            _status = 'Proof Verified Successfully!';
          } else {
            _status = 'Proof Verified, but outputs mismatch! Generated: ${proofResult.inputs}, Expected: $expectedOutputs';
          }
        } else {
          _status = 'Proof Verification Failed!';
        }
        print('Generated Proof: ${proofResult.proof}');
        print('Generated Inputs/Public Signals: ${proofResult.inputs}');
      });

    } catch (e) {
      setState(() => _status = 'Error: $e');
    }
  }

  // Helper function for comparing lists (requires foundation import)
  bool listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Status: $_status'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _runZkProofLogic,
          child: const Text('Run ZK Proof'),
        ),
      ],
    );
  }
}


## Additional Information

*   Find more details about the underlying Rust core library at [mopro-core repository link - TODO add link]
*   For issues and contributions, please visit the main project repository [main project repository link - TODO add link]

For help getting started with Flutter development in general, view the
[online documentation](https://docs.flutter.dev), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
