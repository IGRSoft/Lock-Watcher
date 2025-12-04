# Lock-Watcher Architecture

**System architecture for macOS surveillance application**

## Overview

Lock-Watcher is a macOS application that transforms a Mac into a security monitoring system. It detects unauthorized access attempts through various triggers and captures evidence including photos, location data, and network information. The application uses a modern Swift architecture with SwiftUI, following MVVM + Coordinator patterns with strict concurrency compliance.

## Technology Stack

- **Language**: Swift 6.2
- **UI Framework**: SwiftUI with AppKit integration
- **Minimum Platform**: macOS 13.5+
- **Architecture**: MVVM + Coordinator pattern
- **Concurrency**: Swift 6 strict concurrency
- **State Management**: @Published, Combine
- **Storage**: EasyStash (encrypted local storage)
- **Cloud Integration**: iCloud (CloudKit), Dropbox SDK
- **Camera**: PhotoSnap library
- **Auto-Launch**: LaunchAtLogin
- **Localization**: English (en), Ukrainian (uk)

## Project Structure

```
Lock-Watcher/
├── Source/                          # Main application source
│   ├── Application/                 # App entry point
│   │   ├── App.swift               # @main entry point
│   │   ├── AppDelegate.swift       # NSApplicationDelegate
│   │   ├── AppDelegateModel.swift  # Delegate view model
│   │   └── AppCommons.swift        # Common types and enums
│   ├── Coordinator/                # Navigation coordination
│   │   ├── BaseCoordinatorProtocol.swift
│   │   └── MainCoordinator.swift   # Main window/popover management
│   ├── Managers/                   # Core business logic
│   │   ├── TriggerManager.swift    # Listener orchestration
│   │   ├── ThiefManager.swift      # Capture orchestration
│   │   ├── DatabaseManager.swift   # Storage management
│   │   ├── MacOSLockDetectManager.swift
│   │   ├── AuthentificationManager.swift
│   │   └── NotificationManager.swift
│   ├── Listeners/                  # Event trigger listeners
│   │   ├── BaseListenerProtocol.swift
│   │   ├── WakeUpListener.swift
│   │   ├── PowerListener.swift
│   │   ├── USBListener.swift
│   │   ├── LoginListener.swift
│   │   └── WrongPasswordListener.swift  # Non-MAS only
│   ├── Notifiers/                  # Output channels
│   │   ├── NotifierProtocol.swift
│   │   ├── ICloudNotifier.swift
│   │   ├── DropboxNotifier.swift
│   │   ├── MailNotifier.swift      # Non-MAS only
│   │   └── NotificationNotifier.swift
│   ├── Views/                      # SwiftUI interface
│   │   ├── Settings/               # Settings window
│   │   ├── Main/                   # Status bar popover
│   │   ├── FirstLaunch/            # Setup wizard
│   │   └── Custom/                 # Reusable components
│   ├── Models/                     # Data structures
│   │   ├── ThiefDto.swift          # Capture event data
│   │   ├── AppSettings.swift       # User settings
│   │   ├── DatabaseDto.swift       # Snapshot metadata
│   │   └── DatabaseDtoList.swift
│   ├── Extensions/                 # Swift extensions
│   ├── Utils/                      # Utility functions
│   └── Logger/                     # Logging infrastructure
│
├── XPCServices/                    # Privileged helper services
│   ├── XPCAuthentication/          # Authentication (Swift)
│   ├── XPCMail/                    # Mail delivery (Obj-C, Non-MAS)
│   └── XPCPower/                   # Power management
│
├── Tests/                          # Unit tests
│   └── Mocks/                      # Test doubles
├── UITests/                        # UI automation tests
├── Resources/                      # Assets and config
│   ├── Info.plist
│   ├── entitlements/
│   ├── Assets.xcassets/
│   ├── en.lproj/                   # English localization
│   └── uk.lproj/                   # Ukrainian localization
├── Configurations/                 # Build configs
│   ├── base.xcconfig
│   ├── debug.xcconfig
│   ├── release.xcconfig
│   ├── app/                        # MAS config
│   └── app-nomas/                  # Non-MAS config
└── Lock-Watcher.xcodeproj
```

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        SwiftUI App                               │
│                       (App.swift)                                │
│                    @main MainApp                                 │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                      AppDelegate                                 │
│              (NSApplicationDelegate)                             │
│                                                                  │
│  - Application lifecycle management                              │
│  - Status bar icon setup                                         │
│  - Owns: AppDelegateModel (viewModel)                           │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                   MainCoordinator                                │
│                (@MainActor isolated)                             │
│                                                                  │
│  Manages:                                                        │
│  ├── Status bar button and menu                                  │
│  ├── Main popover presentation                                   │
│  ├── Settings window                                             │
│  └── First-launch wizard                                         │
└────────────────────────┬────────────────────────────────────────┘
                         │
          ┌──────────────┼──────────────┐
          ▼              ▼              ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│  TriggerManager │ │  ThiefManager   │ │ DatabaseManager │
│                 │ │                 │ │                 │
│ Orchestrates:   │ │ Orchestrates:   │ │ Manages:        │
│ ├── WakeUp      │ │ ├── Capture     │ │ ├── Storage     │
│ ├── Power       │ │ ├── Metadata    │ │ ├── Retrieval   │
│ ├── USB         │ │ └── Notify      │ │ └── Encryption  │
│ ├── Login       │ │                 │ │                 │
│ └── WrongPwd    │ │                 │ │                 │
└────────┬────────┘ └────────┬────────┘ └─────────────────┘
         │                   │
         ▼                   ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Listener Layer                              │
├─────────────────────────────────────────────────────────────────┤
│ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ │
│ │ WakeUp      │ │ Power       │ │ USB         │ │ Login       │ │
│ │ Listener    │ │ Listener    │ │ Listener    │ │ Listener    │ │
│ └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘ │
│ ┌─────────────┐                                                  │
│ │ WrongPwd    │  (Non-MAS only)                                 │
│ │ Listener    │                                                  │
│ └─────────────┘                                                  │
└─────────────────────────────────────────────────────────────────┘
                         │
                         ▼ (on trigger)
┌─────────────────────────────────────────────────────────────────┐
│                      Notifier Layer                              │
├─────────────────────────────────────────────────────────────────┤
│ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ │
│ │ iCloud      │ │ Dropbox     │ │ Mail        │ │ Notification│ │
│ │ Notifier    │ │ Notifier    │ │ Notifier    │ │ Notifier    │ │
│ └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘ │
│                                  (Non-MAS)                       │
└─────────────────────────────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                     XPC Services                                 │
├─────────────────────────────────────────────────────────────────┤
│ ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐     │
│ │ XPCAuthentication│ │ XPCMail         │ │ XPCPower        │     │
│ │ (Swift)         │ │ (Obj-C, Non-MAS)│ │                 │     │
│ └─────────────────┘ └─────────────────┘ └─────────────────┘     │
└─────────────────────────────────────────────────────────────────┘
```

## Core Architecture Layers

### Application Layer

The application entry point uses SwiftUI's `@main` attribute:

```swift
@main
struct MainApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            appDelegate.viewModel.settingsView
        }
    }
}
```

**Key Components**:
- **App.swift**: @main entry point with Settings scene
- **AppDelegate.swift**: NSApplicationDelegate for lifecycle and status bar
- **AppDelegateModel.swift**: View model for delegate responsibilities
- **AppCommons.swift**: Shared types, enums, and constants

### Coordinator Layer

**MainCoordinator** manages view presentation and navigation:

- **Status Bar Management**: Creates and manages NSStatusItem
- **Popover Presentation**: Shows main view in popover from status bar
- **Window Management**: Settings window and first-launch wizard
- **@MainActor Isolation**: All UI operations on main actor

### Manager Layer

Business logic is encapsulated in manager classes:

| Manager | Responsibility |
|---------|----------------|
| **TriggerManager** | Orchestrates all event listeners, enables/disables triggers |
| **ThiefManager** | Central capture orchestration - photo, metadata, notification |
| **DatabaseManager** | EasyStash-based encrypted storage with Combine publishers |
| **AuthentificationManager** | Password and biometric authentication |
| **MacOSLockDetectManager** | Monitors macOS system lock state |
| **NotificationManager** | System notification delivery |

### Listener Pattern

Event listeners follow `BaseListenerProtocol`:

```swift
protocol BaseListenerProtocol {
    var isEnabled: Bool { get set }
    func startListening()
    func stopListening()
}
```

**Implemented Listeners**:

| Listener | Trigger | Implementation |
|----------|---------|----------------|
| **WakeUpListener** | Mac wakes from sleep | NSWorkspace notifications |
| **PowerListener** | AC/Battery power change | IOKit power assertions |
| **USBListener** | USB device connection | IOKit USB notifications |
| **LoginListener** | User login event | Distributed notifications |
| **WrongPasswordListener** | Failed login attempt | System log monitoring (Non-MAS) |

### Notifier Pattern

Output channels follow `NotifierProtocol`:

```swift
protocol NotifierProtocol {
    func notify(with data: ThiefDto) async throws
}
```

**Implemented Notifiers**:

| Notifier | Destination | Notes |
|----------|-------------|-------|
| **ICloudNotifier** | iCloud Drive | CloudKit integration |
| **DropboxNotifier** | Dropbox | OAuth authentication |
| **MailNotifier** | Email | SMTP via XPCMail (Non-MAS) |
| **NotificationNotifier** | System notifications | UserNotifications framework |

### View Layer

SwiftUI views organized by feature:

- **Settings/**: Configuration interface with sections for triggers, storage, authentication
- **Main/**: Status bar popover showing recent captures and quick actions
- **FirstLaunch/**: Onboarding wizard for new users
- **Custom/**: Reusable view components

## Data Flow

### Trigger Detection Flow

```
System Event (Wake/USB/Power/Login)
    ↓
Listener detects event
    ↓
Listener callback fires
    ↓
TriggerManager.handleTrigger(type:)
    ↓
ThiefManager.captureThief()
    ↓
┌─────────────────────────────────────┐
│ Parallel Operations:                │
│ ├── Camera capture (PhotoSnap)      │
│ ├── Location fetch (CoreLocation)   │
│ ├── IP address lookup               │
│ └── Network trace-route             │
└─────────────────────────────────────┘
    ↓
Create ThiefDto with all metadata
    ↓
┌─────────────────────────────────────┐
│ Storage & Notification:             │
│ ├── DatabaseManager.save()          │
│ ├── ICloudNotifier.notify()         │
│ ├── DropboxNotifier.notify()        │
│ ├── MailNotifier.notify()           │
│ └── NotificationNotifier.notify()   │
└─────────────────────────────────────┘
    ↓
Update UI (Combine publishers)
```

### Data Models

**ThiefDto** - Capture event data:
```swift
struct ThiefDto: Equatable, Sendable {
    let triggerType: TriggerType
    let date: Date
    let location: CLLocationCoordinate2D?
    let ipAddress: String?
    let traceRoute: String?
    let snapshot: Data?
    let filePath: String?
}
```

**AppSettings** - User configuration:
```swift
struct AppSettings: Codable {
    var enabledTriggers: [TriggerType]
    var storageOptions: [StorageType]
    var authenticationEnabled: Bool
    var menuBarIconStyle: IconStyle
    // ... additional settings
}
```

## Concurrency Model

### Swift Strict Concurrency

The app uses `SWIFT_STRICT_CONCURRENCY = complete`:

- **@MainActor**: All UI-related code (Coordinator, ViewModels, Views)
- **Sendable**: All data models (ThiefDto, AppSettings, DatabaseDto)
- **@unchecked Sendable**: Managers with internal synchronization
- **async/await**: All asynchronous operations

### Actor Isolation

```swift
@MainActor
final class MainCoordinator: BaseCoordinatorProtocol {
    // UI operations safely isolated
}

final class ThiefManager: @unchecked Sendable {
    // Thread-safe with internal synchronization
}
```

## XPC Services

Privileged operations are handled by XPC services:

### XPCAuthentication (Swift)
- Biometric authentication (Touch ID, Face ID)
- Apple Watch proximity authentication
- Secure credential storage

### XPCMail (Objective-C, Non-MAS)
- SMTP email delivery
- Attachment handling
- Credential management

### XPCPower
- Power state monitoring
- Battery level tracking
- AC adapter detection

## Build Configurations

### MAS (Mac App Store) Build

```
Scheme: Lock-Watcher
Bundle ID: com.igrsoft.Lock-Watcher
Config: Configurations/app/app.xcconfig

Excludes:
- WrongPasswordListener (requires elevated privileges)
- MailNotifier (direct SMTP not allowed)
```

### Non-MAS (Direct Distribution) Build

```
Scheme: Lock-Watcher-non-mas
Bundle ID: com.igrsoft.Lock-Watcher-nonmas
Config: Configurations/app-nomas/app-no-mas.xcconfig

Includes:
- WrongPasswordListener
- MailNotifier with XPCMail service
```

### Conditional Compilation

```swift
#if MAS
    // Mac App Store compliant code
#else
    // Full feature set including mail and wrong password
#endif
```

## Testing Strategy

### Unit Tests

Located in `Tests/`:
- Manager tests (TriggerManager, ThiefManager, DatabaseManager)
- Listener tests (WakeUp, Power, USB, Login)
- Utility tests (DeviceUtil, SecurityUtil)
- Model tests (ThiefDto, AppSettings)

### UI Tests

Located in `UITests/`:
- Application launch tests
- Settings configuration tests
- First-launch wizard flow

### Mocking

Test doubles in `Tests/Mocks/`:
- Mock listeners for trigger testing
- Mock notifiers for output testing
- Mock managers for integration testing

## Security

### Data Protection

- **Encrypted Storage**: EasyStash with encryption for local database
- **Secure XPC**: Privileged operations isolated in XPC services
- **Hardened Runtime**: Code signing with hardened runtime enabled

### Authentication

- **Password Protection**: App access protected by user password
- **Biometric**: Touch ID and Face ID support via XPCAuthentication
- **Apple Watch**: Proximity-based authentication

### Privacy

- **Local-Only Storage**: No data sent to third-party services
- **User Consent**: Camera and location permissions requested with descriptions
- **Minimal Data**: Only captures what's necessary for security purposes

## Info.plist Permissions

```xml
<!-- Camera access for photo capture -->
<key>NSCameraUsageDescription</key>
<string>Lock-Watcher uses camera to capture photos on security triggers.</string>

<!-- Location for capture metadata -->
<key>NSLocationUsageDescription</key>
<string>Lock-Watcher records location when capturing security events.</string>

<!-- Biometric authentication -->
<key>NSFaceIDUsageDescription</key>
<string>Lock-Watcher uses biometric authentication to protect access.</string>
```

## Resources

### Project Documentation

- [README.md](README.md) - Project overview and setup
- [CLAUDE.md](CLAUDE.md) - AI agent configuration

### Apple Documentation

- [MultipeerConnectivity](https://developer.apple.com/documentation/multipeerconnectivity)
- [SwiftUI](https://developer.apple.com/xcode/swiftui/)
- [XPC Services](https://developer.apple.com/documentation/xpc)
- [Swift Concurrency](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html)

## Architecture Principles

1. **MVVM + Coordinator** - Clean separation of views, view models, and navigation
2. **Protocol-Based Design** - Listeners and notifiers follow protocols for testability
3. **Manager Pattern** - Business logic encapsulated in dedicated managers
4. **Strict Concurrency** - Swift 6 ready with complete concurrency checking
5. **XPC Isolation** - Privileged operations in separate processes
6. **Conditional Compilation** - Clean MAS/Non-MAS feature separation
7. **Reactive State** - Combine publishers for state updates
