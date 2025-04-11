package com.example.mopro_flutter_package

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import uniffi.mopro.generateCircomProof
import uniffi.mopro.CircomProof
import uniffi.mopro.ProofLib

/** MoproFlutterPackagePlugin */
class MoproFlutterPackagePlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    this.flutterPluginBinding = flutterPluginBinding
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "mopro_flutter_package")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "getApplicationDocumentsDirectory" -> {
        val context = flutterPluginBinding.applicationContext
        val directory = context.getExternalFilesDir(null)
        result.success(directory?.absolutePath)
      }
      "generateProof" -> {
        val zkeyPath = call.argument<String>("zkeyPath") ?: return result.error(
            "ARGUMENT_ERROR",
            "Missing zkeyPath",
            null
        )

        val inputs =
            call.argument<String>("inputs") ?: return result.error(
                "ARGUMENT_ERROR",
                "Missing inputs",
                null
            )

        val res = generateCircomProof(zkeyPath, inputs, ProofLib.ARKWORKS)
        val proof: CircomProof = res.proof

        val proofList = listOf(
            mapOf(
                "x" to proof.a.x,
                "y" to proof.a.y
            ), mapOf(
                "x" to proof.b.x,
                "y" to proof.b.y
            ), mapOf(
                "x" to proof.c.x,
                "y" to proof.c.y
            )
        )

        // Return the proof and inputs as a map supported by the StandardMethodCodec
        val resMap = mapOf(
            "proof" to proofList,
            "inputs" to res.inputs
        )

        result.success(
            resMap
        )
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
