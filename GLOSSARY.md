# Bokrah

Point-of-sale and business management system for desktop and mobile clients.

## Application Updates

**App Update**:
The procedure of comparing the installed client build against published releases, notifying the user, and delivering the new platform binary.
_Avoid_: Upgrade, patch

**Release**:
A versioned distribution package published to GitHub containing changelogs and platform installer assets.
_Avoid_: Build artifact, tag

**Installer Asset**:
A platform-targeted executable or archive package (e.g., `.exe` for Windows, `.apk` for Android) attached to a Release.
_Avoid_: Download file, payload

**Skipped Version**:
A Release version explicitly dismissed by the user to suppress automated startup update prompts until a higher version is published.
_Avoid_: Ignored update, muted version
