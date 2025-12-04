# Swift/Apple Project Configuration

> **Base Configuration**: This configuration extends `~/.claude/CLAUDE.md`

## Project Context

| Setting | Value |
|---------|-------|
| Platform | macOS |
| Framework | SwiftUI with AppKit integration |
| Language | Swift 6.2 |
| Architecture | MVVM + Coordinator pattern |
| Concurrency | Swift 6 strict concurrency |

## Key Project Documents

- **[ARCHITECTURE.md](ARCHITECTURE.md)** - System architecture, patterns, and component relationships
- **[README.md](README.md)** - Project specifications, requirements, and getting started guide
- **Source Documentation** - Module-specific documentation:
  - [Source/Managers/](Source/Managers/) - Core business logic managers
  - [Source/Listeners/](Source/Listeners/) - Event trigger listeners
  - [Source/Notifiers/](Source/Notifiers/) - Output channel notifiers
  - [Source/Views/](Source/Views/) - SwiftUI view layer

## Required Rules

These rules from `~/.claude/rules/` apply to this Swift/macOS project:

### Development Rules

| Rule | Description |
|------|-------------|
| `swift.md` | Swift best practices and modern patterns |
| `swift6-concurrency.md` | Swift 6 concurrency, actors, Sendable compliance |
| `swift-observation.md` | Observation framework patterns |
| `mvvm.md` | MVVM + Coordinator architecture patterns |
| `swiftformat.md` | Code formatting with SwiftFormat |

### Critical Rules

| Rule | Priority | Description |
|------|----------|-------------|
| `permissions-guide.md` | **CRITICAL** | macOS permission handling (Camera, Location, Notifications) |
| `security-privacy.md` | High | Security and privacy best practices for surveillance app |

### Quality Rules

| Rule | Description |
|------|-------------|
| `testing-strategy.md` | Unit and UI testing approach |
| `code-review.md` | Code review checklist |

## Recommended Agents

For macOS development on this project, use these specialized agents:

### Primary Agent

- `macos-developer` - macOS-specific: AppKit, menu bar apps, system integration, XPC services

### Supporting Agents

| Agent | Use Case |
|-------|----------|
| `apple-developer` | Cross-platform Apple development guidance |
| `security-auditor` | Security reviews for surveillance functionality |
| `test-automator` | Test automation for managers and listeners |

## Apple Documentation

Reference documentation available in `~/.claude/docs/apple/`:
- AppKit integration patterns
- XPC service development
- System event monitoring
- Camera capture APIs

## Project Customization

### Bundle Identifiers

```
MAS: com.igrsoft.Lock-Watcher
Non-MAS: com.igrsoft.Lock-Watcher-nonmas
```

### Target Versions

```
macOS 12.4+
```

### Build Configurations

```
MAS Build: Lock-Watcher.xcscheme
  - App Store compliant
  - Excludes: Mail notifier, Wrong password listener

Non-MAS Build: Lock-Watcher-non-mas.xcscheme
  - Direct distribution
  - Includes: Mail notifier, Wrong password listener
```

### Feature Flags

```
#if MAS
  // Mac App Store build - restricted features
#else
  // Non-MAS build - full features including mail and wrong password detection
#endif
```

### XPC Services

```
XPCAuthentication - Swift-based authentication service
XPCMail - Objective-C mail service (Non-MAS only)
XPCPower - Power management service
```

### Project-Specific Patterns

```
Manager Pattern - Business logic orchestration (ThiefManager, TriggerManager)
Listener Pattern - Event detection (WakeUpListener, USBListener, etc.)
Notifier Pattern - Output channels (iCloudNotifier, DropboxNotifier, etc.)
Coordinator Pattern - Navigation and view presentation (MainCoordinator)
```
