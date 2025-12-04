# Lock-Watcher

**macOS surveillance application for security monitoring**

Turn your Mac into a powerful surveillance system with Lock-Watcher. Detect and capture unauthorized access attempts discreetly, receiving high-quality photos from your built-in or external camera and securely storing them locally or in the cloud.

## Download

Available on the [Mac App Store](https://apps.apple.com/app/lock-watcher/id1583462846)

## Company Information

**Company Name**: IGR Soft
**Domain**: com.igrsoft
**Contact**: support@igrsoft.com

## Project Information

**Project Name**: Lock-Watcher
**Bundle Identifier**: com.igrsoft.Lock-Watcher
**Current Version**: 1.2.2 (Build 1222)

### Project Description

Lock-Watcher transforms your Mac into a stealthy security guardian. It monitors various system triggers - wake-up events, login attempts, power changes, USB connections, and wrong password entries - to detect potential unauthorized access. When triggered, it captures high-quality photos along with location, IP address, and network trace-route information, storing everything securely for later review.

## Features

- **Camera Selection** - Choose between built-in or external cameras for surveillance
- **High-Quality Capture** - Optimal photo capture with smart compression
- **Easy Configuration** - Simple setup for triggers and storage locations

### Security Triggers

- **On WakeUp** - Captures when Mac exits sleep mode
- **On Login** - Captures on user login events
- **On Battery Power Switch** - Captures when switching between AC and battery (laptops)
- **On USB Mount** - Captures when USB devices are connected
- **On Wrong Password** - Captures on failed login attempts (Non-MAS only)

### Snapshot Information

Each capture includes:
- Device location (GPS coordinates)
- Network IP address
- Network trace-route analysis
- Timestamp with date formatting

### Storage Options

- **Local Database** - Encrypted storage on your Mac
- **iCloud** - Sync to iCloud Drive
- **Dropbox** - Cloud backup via Dropbox
- **Mail** - Email delivery (Non-MAS only)

### Additional Features

- **Organized Files** - Date-formatted naming for easy retrieval
- **Customizable Menubar** - Icon indicator and notifications on triggers
- **Password Protection** - Secure access to snapshots and settings
- **Biometric Authentication** - Apple Watch and Touch ID keyboard support

## Technology Stack

- **Language**: Swift 6.2
- **UI Framework**: SwiftUI with AppKit integration
- **Minimum Platform**: macOS 13.5+
- **Architecture**: MVVM + Coordinator pattern
- **Concurrency**: Swift 6 strict concurrency
- **Storage**: EasyStash (encrypted local storage)
- **Cloud**: iCloud (CloudKit), Dropbox SDK
- **Camera**: PhotoSnap library
- **Auto-Launch**: LaunchAtLogin

## Requirements

- **macOS**: 13.5 or later
- **Hardware**: Mac with built-in or external camera
- **Xcode**: 16.3+ (for development)
- **Swift**: 6.2

## Architecture

Lock-Watcher uses a modern MVVM + Coordinator architecture:

- **Managers**: Business logic (TriggerManager, ThiefManager, DatabaseManager)
- **Listeners**: Event detection (WakeUp, Power, USB, Login, WrongPassword)
- **Notifiers**: Output channels (iCloud, Dropbox, Mail, Notifications)
- **Coordinator**: View presentation and navigation

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed system architecture.

## Project Structure

```
Lock-Watcher/
├── Source/                  # Main application source
│   ├── Application/         # App entry point and delegate
│   ├── Coordinator/         # Navigation coordination
│   ├── Managers/            # Core business logic
│   ├── Listeners/           # Event trigger listeners
│   ├── Notifiers/           # Output channel notifiers
│   ├── Views/               # SwiftUI interface
│   ├── Models/              # Data structures
│   ├── Extensions/          # Swift extensions
│   ├── Utils/               # Utility functions
│   └── Logger/              # Logging infrastructure
├── XPCServices/             # Privileged helper services
│   ├── XPCAuthentication/   # Biometric authentication
│   ├── XPCMail/             # Email delivery (Non-MAS)
│   └── XPCPower/            # Power management
├── Tests/                   # Unit tests
├── UITests/                 # UI automation tests
├── Resources/               # Assets and configuration
└── Configurations/          # Build configs (MAS/Non-MAS)
```

## Info.plist Requirements

### Required Permissions

```xml
<!-- Camera access -->
<key>NSCameraUsageDescription</key>
<string>Lock-Watcher uses camera to capture photos on security triggers.</string>

<!-- Location access -->
<key>NSLocationUsageDescription</key>
<string>Lock-Watcher records location when capturing security events.</string>

<!-- Biometric authentication -->
<key>NSFaceIDUsageDescription</key>
<string>Lock-Watcher uses biometric authentication to protect access.</string>
```

## Getting Started

### 1. Clone Repository

```bash
git clone <repository-url>
cd Lock-Watcher
```

### 2. Open in Xcode

```bash
open Lock-Watcher.xcodeproj
```

### 3. Build and Run

Select the appropriate scheme:
- **Lock-Watcher** - Mac App Store build
- **Lock-Watcher-non-mas** - Direct distribution build

Press `Cmd+R` to build and run.

## Building

### MAS (Mac App Store) Build

```bash
xcodebuild -project Lock-Watcher.xcodeproj \
           -scheme Lock-Watcher \
           -configuration Release \
           build
```

### Non-MAS (Direct Distribution) Build

```bash
xcodebuild -project Lock-Watcher.xcodeproj \
           -scheme Lock-Watcher-non-mas \
           -configuration Release \
           build
```

## Testing

### Run Unit Tests

```bash
xcodebuild test \
    -project Lock-Watcher.xcodeproj \
    -scheme Lock-Watcher \
    -destination 'platform=macOS'
```

### Run UI Tests

```bash
xcodebuild test \
    -project Lock-Watcher.xcodeproj \
    -scheme Lock-Watcher \
    -destination 'platform=macOS' \
    -only-testing:Lock-WatcherUITests
```

## Development

### Code Style

Project uses **SwiftFormat** for consistent code formatting:

```bash
swiftformat .
```

Configuration in `.swiftformat` file.

### Reset App Permissions

For development testing, reset all permissions:

```bash
tccutil reset All com.igrsoft.Lock-Watcher
```

### AI Agent Configuration

This project includes AI development configuration:
- [CLAUDE.md](CLAUDE.md) - AI agent configuration for Swift/macOS development
- [ARCHITECTURE.md](ARCHITECTURE.md) - System architecture documentation

### Build Configurations

| Config | Bundle ID | Features |
|--------|-----------|----------|
| MAS | com.igrsoft.Lock-Watcher | App Store compliant |
| Non-MAS | com.igrsoft.Lock-Watcher-nonmas | Full features (Mail, WrongPassword) |

## Troubleshooting

### Camera Not Working

**Issue**: Camera capture fails or shows black image
**Solution**:
- Check camera permissions in System Preferences > Privacy & Security > Camera
- Ensure no other app is using the camera
- Try selecting a different camera in settings

### Location Not Available

**Issue**: Location data missing from captures
**Solution**:
- Enable location services in System Preferences > Privacy & Security > Location Services
- Grant Lock-Watcher location access
- Ensure location services are not disabled system-wide

### Triggers Not Firing

**Issue**: Events don't trigger captures
**Solution**:
- Verify triggers are enabled in settings
- Check that the app is running (menubar icon visible)
- Review system logs for errors

### iCloud Sync Issues

**Issue**: Captures not appearing in iCloud
**Solution**:
- Verify iCloud is enabled in System Preferences
- Check iCloud Drive has available storage
- Ensure Lock-Watcher has iCloud access

### Dropbox Connection Failed

**Issue**: Cannot connect to Dropbox
**Solution**:
- Re-authenticate with Dropbox in settings
- Check internet connection
- Verify Dropbox app permissions

## Privacy & Security

Lock-Watcher prioritizes your privacy and security:

- **No Third-Party Services**: Data is never sent to external analytics or tracking services
- **Local Storage**: All captures stored locally or in your own cloud accounts
- **Encrypted Storage**: Local database uses encryption
- **Biometric Protection**: Optional Touch ID/Apple Watch authentication
- **Minimal Permissions**: Only requests necessary system permissions

## Contributing

### Before Committing

1. **Format code**: Run `swiftformat .`
2. **Run tests**: Ensure all tests pass
3. **Update docs**: If adding features

### Commit Message Format

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add new trigger type
fix: resolve camera capture issue
chore: update dependencies
docs: improve README
```

## License

Copyright 2025 IGR Soft. All rights reserved.

See [LICENSE](LICENSE) file for details.

## Resources

### Apple Documentation

- [SwiftUI](https://developer.apple.com/xcode/swiftui/)
- [AppKit](https://developer.apple.com/documentation/appkit)
- [XPC Services](https://developer.apple.com/documentation/xpc)
- [Swift Concurrency](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html)

### Community

- [Swift Forums](https://forums.swift.org)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/swift)

## Contact

For issues or questions:
- Create an issue in this repository
- Contact: support@igrsoft.com

---

**Made with care by IGR Soft**
