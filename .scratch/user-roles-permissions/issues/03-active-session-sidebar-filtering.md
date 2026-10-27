# 03: Active Operator Session & Sidebar Role-Based Filtering

**What to build:**
Provide an observable active operator session state at the app level. Connect the navigation shell (\HomePage\) to filter sidebar navigation items dynamically based on the active operator's assigned role:
- \Admin\: Sees all items (POS, Items, Categories, Warehouses, Users, Accounting, Settings)
- \Cashier\: Sees only sales operations (Items, Categories, Invoices); Users, Accounting, and Settings are hidden
- \Accountant\: Sees Invoices, Accounting, and catalog; Users and Settings are hidden

**Blocked by:** 01: Canonical Operator Roles, Legacy Migration & Auto-Seeding

**Status:** completed

- [x] Introduce or configure active operator session state (via Cubit/Service) observable by `HomePage`
- [x] Dynamically filter sidebar items based on the active operator's role
- [x] Display the active operator's name and role badge in the interface
- [x] Widget tests verifying sidebar item visibility for Admin, Cashier, and Accountant roles

