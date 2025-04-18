import Flutter
import UIKit
import XCTest

@testable import MoproFFI

// This demonstrates a simple unit test of the Swift portion of this plugin's implementation.
//
// See https://developer.apple.com/documentation/xctest for more information about using XCTest.

class RunnerTests: XCTestCase {

   func testCircomProverAndVerifier() async throws {
     guard let zkeyPath = Bundle(for: RunnerTests.self).path(forResource: "multiplier2_final", ofType: "zkey") else {
       XCTFail("zkey path not found in the test bundle")
       return
     }
     do {
       let a = 3
       let b = 5
       let c = a * b
       let input_str: String = "{\"b\":[\"5\"],\"a\":[\"3\"]}"

       let outputs: [String] = [String(c), String(a)]

       let generateProofResult = try generateCircomProof(
         zkeyPath: zkeyPath, circuitInputs: input_str, proofLib: ProofLib.arkworks)

       let isValid = try verifyCircomProof(
         zkeyPath: zkeyPath,
         proofResult: CircomProofResult(
           proof: generateProofResult.proof, inputs: generateProofResult.inputs),
         proofLib: ProofLib.arkworks)
       XCTAssertTrue(isValid, "Proof verification should succeed")
       XCTAssertEqual(outputs, generateProofResult.inputs, "Generated inputs should match expected outputs")
     } catch {
       XCTFail("testCircomProverAndVerifier failed with error: \(error)")
     }
   }

}
