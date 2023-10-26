//
//  NSImageDataTest.swift
//  Lock-WatcherTests
//
//  Created by Vitalii P on 28.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

@testable import Lock_Watcher
import XCTest

class NSImageDataTest: XCTestCase {
    
    // Test that valid NSImage converts to non-empty JPEG data
    func testValidImageToJpeg() {
        // Assuming you have a valid image named "Sample" in your test bundle.
        guard let image = NSImage(named: "MenuIcon") else {
            XCTFail("Failed to load the sample image.")
            return
        }
        
        let jpegRepresentation = image.jpegData
        XCTAssertFalse(jpegRepresentation.isEmpty, "JPEG data should not be empty for valid image.")
    }
    
    // Test that an empty or invalid NSImage converts to empty JPEG data
    func testInvalidImageToJpeg() {
        let image = NSImage()
        let jpegRepresentation = image.jpegData
        XCTAssertTrue(jpegRepresentation.isEmpty, "JPEG data should be empty for an invalid image.")
    }
}
