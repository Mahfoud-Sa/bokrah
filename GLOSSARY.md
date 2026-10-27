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

## Users & Access Control

**Operator**:
An authenticated staff member actively interacting with the client application or terminal.
_Avoid_: Active user, cashier (when referring generically to any staff member operating the system)

**Role**:
A named level of access assigned to an operator (`Admin`, `Cashier`, `Accountant`) determining which application areas and pages are accessible.
_Avoid_: Group, profile, user type

**Access Level**:
The scope of screens and operations an operator is authorized to access based on their assigned role.
_Avoid_: Entitlement, privilege, permission matrix


