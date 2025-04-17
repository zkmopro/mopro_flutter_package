# Mopro Flutter Package

A Flutter plugin for generating and verifying zero-knowledge proofs (ZKPs) on mobile platforms (iOS/Android). This package provides a simple interface to interact with proof systems such as Circom and Halo2, supporting multiple proof libraries (e.g., Arkworks, Rapidsnark).

## Getting Started

Follow these steps to integrate the Mopro Flutter package into your project.

### Adding a package dependency to an app

1.  **Add Dependency:** You can add `mopro_flutter_package` to your project using the command line or by manually editing `pubspec.yaml`.

    *   **Command Line (Recommended):**
        ```bash
        flutter pub add mopro_flutter_package 
        ```
        This command automatically adds the latest compatible version to your `pubspec.yaml`.

    *   **Manual Edit (Required for local path or specific Git dependencies):**
        Open your `pubspec.yaml` file and add `mopro_flutter_package` under `dependencies`.

        ```yaml
        dependencies:
          flutter:
            sdk: flutter

          mopro_flutter_package: VERSION_YOU_PREFERRED
          # mopro_flutter_package: ^0.1.0 
        ```

2.  **Update Circuit Asset:** Include your compiled Circom `.zkey` file as an asset. Add the asset path to your `pubspec.yaml` under the `flutter:` section:

    ```yaml
    flutter:
      uses-material-design: true # Ensure this is present
      assets:
        # Add the directory containing your .zkey file(s)
        - assets/circuits/ 
        # Or specify the file directly:
        # - assets/circuits/multiplier2_final.zkey 
    ```
    *Make sure the path points correctly to where you've placed your `.zkey` file within your Flutter project.*

3.  **Install Package:** Run the following command in your terminal from the root of your Flutter project:

    ```bash
    flutter pub get
    ```

## Usage Example

Here's a basic example demonstrating how to use the package to generate and verify a proof for a simple multiplier circuit (`multiplier2.circom`: `template Multiplier2() { signal input a; signal input b; signal output c; c <== a * b; }`)

```dart
// Import the package
import 'package:mopro_flutter_package/mopro_flutter_package.dart';
import 'package:mopro_flutter_package/mopro_flutter_types.dart';

void main() {
  runApp(const MyApp());
}

// --- Example Usage Widget ---
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MoproFlutterPackage _mopro = MoproFlutterPackage();
  String _status = 'Idle';
  String _proof = '';
  List<String> _publicInputs = [];

  @override
  void initState() {
    super.initState();
    // Optional: Initialize any platform-specific setup if needed
    // _mopro.initialize(); 
  }

  Future<void> _runProveAndVerify() async {
    setState(() => _status = 'Initializing...');
    
    // TODO: Robust asset handling (copying to accessible temp path)
    // This example assumes the native code can handle the asset path directly.
    // You might need to copy the asset to a temporary file first.
    const String zkeyAssetName = 'assets/circuits/multiplier2_final.zkey'; 

    try {
      // --- 1. Prepare Inputs ---
      setState(() => _status = 'Preparing inputs...');
      // Corresponds to the inputs of multiplier2.circom
      const int a = 3;
      const int b = 5;
      final Map<String, List<String>> inputs = {
        'a': [a.toString()],
        'b': [b.toString()],
      };
      // Convert inputs to JSON string
      final String inputsJson = jsonEncode(inputs);

      // --- 2. Generate Proof ---
      setState(() => _status = 'Generating proof...');
      // Use the zkey asset path provided in pubspec.yaml
      final GenerateProofResult proofResult = await _mopro.generateProof(
        zkeyPath: zkeyAssetName, 
        inputs: inputsJson,
      );
      
      setState(() {
         _status = 'Proof generated. Verifying...';
         _proof = proofResult.proof; // Store for display/use
         _publicInputs = proofResult.inputs; // Store public inputs (outputs of circuit)
      });

      // --- 3. Verify Proof ---
      final bool isValid = await _mopro.verifyProof(
        zkeyPath: zkeyAssetName, // Use the same zkey asset path
        proof: proofResult.proof, // Use the generated proof
        inputs: proofResult.inputs, // Use the public inputs from proof generation
      );

      setState(() {
        _status = isValid ? 'Proof Verified Successfully!' : 'Proof Verification Failed!';
      });

      // Optional: Log results
      print('Generated Proof: ${proofResult.proof}');
      print('Public Inputs/Outputs: ${proofResult.inputs}');
      print('Verification result: $isValid');

    } catch (e) {
      setState(() => _status = 'Error: $e');
      print('Error caught: $e');
    }
  }
}
```

> [!WARNING]  
> The default bindings are built specifically for the `multiplier2` circom circuit. If you'd like to update the circuit or switch to a different proving scheme, please refer to the [How to Build the Package](#how-to-build-the-package) section.<br/>
> Circuit source code: https://github.com/zkmopro/circuit-registry/tree/main/multiplier2<br/>
> Example .zkey file for the circuit: http://ci-keys.zkmopro.org/multiplier2_final.zkey<br/>

## How to Build the Package

This package relies on bindings generated by the Mopro CLI.
To learn how to build Mopro bindings, refer to the [Getting Started](https://zkmopro.org/docs/getting-started) section.
If you'd like to generate custom bindings for your own circuits or proving schemes, check out the guide on how to use the Mopro CLI: [Rust Setup for Android/iOS Bindings](https://zkmopro.org/docs/setup/rust-setup#setup-any-rust-project).

## Community

-   X account: <a href="https://twitter.com/zkmopro"><img src="https://img.shields.io/twitter/follow/zkmopro?style=flat-square&logo=x&label=zkmopro"></a>
-   Telegram group: <a href="https://t.me/zkmopro"><img src="https://img.shields.io/badge/telegram-@zkmopro-blue.svg?style=flat-square&logo=telegram"></a>

## Acknowledgements

This work was initially sponsored by a joint grant from [PSE](https://pse.dev/) and [0xPARC](https://0xparc.org/). It is currently incubated by PSE.
