# 01: Canonical Operator Roles, Legacy Migration & Auto-Seeding

**What to build:**
Define the canonical operator roles (\Admin\, \Cashier\, \Accountant\) in the domain model. Update user entity persistence so legacy stored roles (e.g. \'Admin'\, \'Staff'\) cleanly map to canonical roles without losing user accounts. Provide automatic seeding of a default \Admin\ account when the local user storage is newly initialized and empty, ensuring the system is never locked out.

**Blocked by:** None (can start immediately)

**Status:** completed

- [x] Define canonical `OperatorRole` enum or typed constants with `Admin`, `Cashier`, and `Accountant`
- [x] Update `UserEntity` to support canonical role with safe default and JSON serialization
- [x] Update `UsersService` to migrate legacy roles and auto-seed initial Admin user on empty storage
- [x] Unit tests for role serialization, legacy migration, and empty storage auto-seeding

