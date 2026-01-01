//
//  ICloudNotifier.swift
//
//  Created on 10.08.2021.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import AppKit
import CoreLocation

/// A service responsible for handling and sending image notifications to iCloud.
///
/// The `iCloudNotifier` interacts with the iCloud and sends an image captured from the `ThiefDto`
/// data object to the user's iCloud Documents folder.
///
/// This class is `Sendable` because all stored properties are immutable and `Sendable`:
/// - `logger` conforms to `LogProtocol: Sendable`
/// - `documentsFolderName` is an immutable `String`
final class ICloudNotifier: NotifierProtocol, Sendable {
    // MARK: - Dependency injection

    /// Logger instance responsible for capturing and logging events or errors.
    private let logger: LogProtocol

    // MARK: - Variables

    /// Name of the iCloud directory where images are saved.
    /// Default is "Documents".
    private let documentsFolderName = "Documents"

    // MARK: - Initializer

    /// Initializes a new instance of the `ICloudNotifier` with the provided logger or a default logger.
    ///
    /// - Parameter logger: An optional logger instance for capturing and logging events.
    init(logger: LogProtocol = Log(category: .iCloudNotifier)) {
        self.logger = logger
    }

    // MARK: - Public methods

    /// Registers the notifier with the provided application settings.
    ///
    /// - Parameter settings: The application settings to configure the iCloud notifier.
    func register(with settings: AppSettingsProtocol) {
        // This method is left blank for future settings integrations.
    }

    /// Sends an image notification based on the provided `ThiefDto` information.
    ///
    /// This function saves the image with optional text derived from `thiefDto.description()`
    /// to the iCloud's "Documents" folder.
    ///
    /// - Parameter thiefDto: The data object containing the details to be saved as an image.
    /// - Throws: `NotifierError` if the image fails to save.
    func send(_ thiefDto: ThiefDto) async throws {
        guard let localURL = thiefDto.filePath else {
            logger.error("wrong file path")
            throw NotifierError.invalidFilePath
        }

        guard var iCloudURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent(documentsFolderName) else {
            logger.error("wrong iCloud url")
            throw NotifierError.invalidCloudURL("iCloud")
        }

        iCloudURL.appendPathComponent(localURL.lastPathComponent)

        var image = thiefDto.snapshot
        let info = thiefDto.description()
        if !info.isEmpty {
            image = image?.imageWithText(text: info)
        }

        logger.debug("send: \(thiefDto)")

        do {
            guard let data = image?.jpegData else {
                throw NotifierError.emptyData
            }
            try data.write(to: iCloudURL)
        } catch let error as NotifierError {
            throw error
        } catch {
            logger.error(error.localizedDescription)
            throw NotifierError.uploadFailed(error)
        }
    }
}
