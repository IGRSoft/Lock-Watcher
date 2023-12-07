//
//  NSImageTextTest.swift
//  Lock-WatcherTests
//
//  Created by Vitalii Parovishnyk on 28.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

@testable import Lock_Watcher
import XCTest

class NSImageExtensionTests: XCTestCase {

    var sampleImage: NSImage!
    
    override func setUpWithError() throws {
        // Load a sample image that you can use for the tests.
        // For simplicity, assuming "Sample" is an image in your test bundle.
        guard let image = NSImage(named: "AppIcon") else {
            XCTFail("Failed to load the sample image.")
            return
        }
        sampleImage = image
    }

    // Check if the returned image size remains the same after adding text.
    func testImageSizeAfterAddingText() {
        guard let newImage = sampleImage.imageWithText(text: "Test") else {
            XCTFail("Failed to generate image with text.")
            return
        }
        XCTAssertEqual(sampleImage.size, newImage.size, "Image size should remain the same after adding text.")
    }
    
    // Ensure that the function returns the original image if the conversion fails.
    func testImageReturnOnFailure() {
        // Intentionally use an invalid image
        let invalidImage = NSImage()
        let newImage = invalidImage.imageWithText(text: "Test")
        XCTAssertTrue(invalidImage.isEqual(newImage), "Should return the original image on failure.")
    }

    // Note: Writing tests for validating the added text, font size, and color on the image
    // would be more complex and may require image processing techniques or libraries
    // to analyze the resulting image. Such tests are beyond the scope of a basic unit test.

    override func tearDownWithError() throws {
        sampleImage = nil
    }
}
