import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:bokrah_design_system/bokrah_design_system.dart';
import 'package:bokrah/app/config/l10n/app_localizations.dart';
import 'package:bokrah/app/features/autoUpdate/presentation/app_update_screen.dart';
import 'package:bokrah/app/features/autoUpdate/presentation/cubits/app_update_cubit.dart';
import 'package:bokrah/app/features/autoUpdate/presentation/cubits/app_update_state.dart';
import 'package:bokrah/app/features/autoUpdate/presentation/dialogs/update_prompt_dialog.dart';
import 'package:bokrah/app/features/settings/presentation/cubits/settings_cubit.dart';
import 'package:bokrah/app/features/settings/presentation/cubits/settings_state.dart';
import 'package:bokrah/app/features/accounting_playground/accounting.dart';
import 'package:bokrah/app/features/items/presentation/pages/items_page.dart';
import 'package:bokrah/app/features/items/presentation/pages/categories_page.dart';
import 'package:bokrah/app/features/warehouses/presentation/pages/warehouses_page.dart';
import 'package:bokrah/app/features/units/presentation/pages/units_page.dart';
import 'package:bokrah/app/features/barcoders/presentation/pages/barcoders_page.dart';
import 'package:bokrah/app/features/users/presentation/pages/users_page.dart';
import 'package:bokrah/app/features/users/presentation/pages/profile_page.dart';
import 'package:bokrah/app/features/home/main_content.dart';
import 'package:bokrah/app/features/home/side_bar_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  PackageInfo? _packageInfo;
  bool isItemsExpanded = true;
  bool isSettingsExpanded = false;
  bool _hasPromptedUpdateThisSession = false;
  final PlaygroundController _accountingController = PlaygroundController();

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppUpdateCubit>().checkForUpdates(isManual: false);
    });
  }

  @override
  void dispose() {
    _accountingController.dispose();
    super.dispose();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _packageInfo = info;
      });
    }
  }

  void _showVersionInfo() {
    if (_packageInfo == null) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('معلومات التطبيق'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('اسم التطبيق:', _packageInfo!.appName),
              const SizedBox(height: 8),
              _buildInfoRow('الإصدار:', _packageInfo!.version),
              const SizedBox(height: 8),
              _buildInfoRow('رقم البناء:', _packageInfo!.buildNumber),
              const SizedBox(height: 8),
              _buildInfoRow('اسم الحزمة:', _packageInfo!.packageName),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('موافق'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }

  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        final isArabic =
            dialogContext.read<SettingsCubit>().state.locale.languageCode ==
                'ar';
        return Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: AlertDialog(
            title: Text(isArabic ? 'بكرة للمحاسبة' : 'Bokrah Accounting'),
            content: Text(
              isArabic
                  ? 'هل أنت متأكد من رغبتك في تسجيل الخروج؟'
                  : 'Are you sure you want to log out?',
            ),
            actions: <Widget>[
              TextButton(
                child: Text(isArabic ? 'إلغاء' : 'Cancel'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text(isArabic ? 'تسجيل الخروج' : 'Log Out'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  context.go('/login');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserMenu({bool isMobile = false}) {
    final isArabic =
        context.watch<SettingsCubit>().state.locale.languageCode == 'ar';
    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      icon: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: CircleAvatar(
          radius: isMobile ? 14 : 16,
          backgroundColor:
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          child: Icon(
            Icons.person,
            size: isMobile ? 18 : 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      onSelected: (value) {
        if (value == 'profile') {
          setState(() => selectedIndex = 12);
        } else if (value == 'logout') {
          _showLogoutDialog();
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'profile',
          child: ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(isArabic ? 'الملف الشخصي' : 'My Profile'),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'logout',
          child: ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              isArabic ? 'تسجيل الخروج' : 'Log Out',
              style: const TextStyle(color: Colors.red),
            ),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ),
      ],
    );
  }

  String _pageTitle(int index, bool isArabic) {
    if (isArabic) {
      return switch (index) {
        0 => 'لوحة التحكم المحاسبية',
        1 => 'المبيعات والمعاملات',
        2 => 'القيود اليومية',
        3 => 'إدارة الفواتير',
        4 => 'شجرة الحسابات',
        5 => 'التقارير المالية',
        6 => 'قائمة العناصر',
        7 => 'فئات المنتجات',
        8 => 'إدارة المستودعات',
        9 => 'وحدات القياس',
        10 => 'إدارة الباركودات',
        11 => 'إدارة المستخدمين',
        12 => 'الملف الشخصي',
        _ => AppLocalizations.of(context)?.appName ?? 'بكرة للمحاسبة',
      };
    }
    return switch (index) {
      0 => 'Accounting Dashboard',
      1 => 'Sales & Transactions',
      2 => 'Journal Entries',
      3 => 'Invoice Management',
      4 => 'Chart of Accounts',
      5 => 'Financial Reports',
      6 => 'Items Catalogue',
      7 => 'Product Categories',
      8 => 'Warehouse Management',
      9 => 'Units of Measure',
      10 => 'Barcode Management',
      11 => 'User Management',
      12 => 'My Profile',
      _ => AppLocalizations.of(context)?.appName ?? 'Bokrah Accounting',
    };
  }

  IconData _pageIcon(int index) {
    return switch (index) {
      0 => Icons.dashboard_outlined,
      1 => Icons.receipt_long_outlined,
      2 => Icons.edit_note_outlined,
      3 => Icons.description_outlined,
      4 => Icons.account_tree_outlined,
      5 => Icons.analytics_outlined,
      6 => Icons.inventory_2_outlined,
      7 => Icons.category_outlined,
      8 => Icons.warehouse_outlined,
      9 => Icons.straighten_outlined,
      10 => Icons.qr_code_outlined,
      11 => Icons.manage_accounts_outlined,
      12 => Icons.person_outline,
      _ => Icons.circle_outlined,
    };
  }

  IconData _themeIcon(BkThemeMode mode) {
    return switch (mode) {
      BkThemeMode.light => Icons.light_mode_outlined,
      BkThemeMode.dark => Icons.dark_mode_outlined,
      BkThemeMode.highContrast => Icons.contrast,
    };
  }

  String _themeTooltip(BkThemeMode mode, bool isArabic) {
    if (isArabic) {
      return switch (mode) {
        BkThemeMode.light => 'المظهر: فاتح',
        BkThemeMode.dark => 'المظهر: داكن',
        BkThemeMode.highContrast => 'المظهر: عالي التباين',
      };
    }
    return switch (mode) {
      BkThemeMode.light => 'Theme: Light',
      BkThemeMode.dark => 'Theme: Dark',
      BkThemeMode.highContrast => 'Theme: High Contrast',
    };
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    final isArabic =
        context.watch<SettingsCubit>().state.locale.languageCode == 'ar';

    final pages = [
      // 0: Accounting Dashboard
      DashboardContent(controller: _accountingController),
      // 1: Transactions & Sales
      SingleChildScrollView(
        padding: const EdgeInsets.all(BkSpace.lg),
        child: TransactionListPreview(controller: _accountingController),
      ),
      // 2: Journal Entries
      SingleChildScrollView(
        padding: const EdgeInsets.all(BkSpace.lg),
        child: JournalEntryPreview(controller: _accountingController),
      ),
      // 3: Invoices
      const SingleChildScrollView(
        padding: EdgeInsets.all(BkSpace.lg),
        child: InvoiceManagementPreview(),
      ),
      // 4: Chart of Accounts
      const SingleChildScrollView(
        padding: EdgeInsets.all(BkSpace.lg),
        child: ChartOfAccountsPreview(),
      ),
      // 5: Financial Reports
      SingleChildScrollView(
        padding: const EdgeInsets.all(BkSpace.lg),
        child: FinancialReportsPreview(controller: _accountingController),
      ),
      // 6: Items
      const ItemsPage(),
      // 7: Categories
      const CategoriesPage(),
      // 8: Warehouses
      const WarehousesPage(),
      // 9: Units
      const UnitsPage(),
      // 10: Barcodes
      const BarcodesPage(),
      // 11: Users
      const UsersPage(),
      // 12: Profile
      const ProfilePage(),
    ];

    Widget sidebarContent = Container(
      width: 260,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        border: Border(
          right: isArabic
              ? BorderSide.none
              : BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                ),
          left: isArabic
              ? BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                )
              : BorderSide.none,
        ),
      ),
      child: Column(
        children: [
          // Brand Logo Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.account_balance,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? "بكرة للمحاسبة" : "Bokrah Suite",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isArabic ? "المؤسسات" : "Enterprise",
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _packageInfo != null
                                ? 'v${_packageInfo!.version}'
                                : 'v3.4.0',
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Scrollable navigation items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                // 1. Accounting & Finance
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    isArabic ? "المحاسبة والمالية" : "Accounting & Finance",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.85),
                    ),
                  ),
                ),
                SidebarItem(
                  icon: Icons.dashboard_outlined,
                  label: isArabic ? "لوحة التحكم" : "Dashboard",
                  isSelected: selectedIndex == 0,
                  onTap: () {
                    setState(() => selectedIndex = 0);
                    if (isMobile) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                SidebarItem(
                  icon: Icons.receipt_long_outlined,
                  label: isArabic ? "المبيعات والمعاملات" : "Transactions",
                  isSelected: selectedIndex == 1,
                  onTap: () {
                    setState(() => selectedIndex = 1);
                    if (isMobile) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                SidebarItem(
                  icon: Icons.edit_note_outlined,
                  label: isArabic ? "القيود اليومية" : "Journal Entries",
                  isSelected: selectedIndex == 2,
                  onTap: () {
                    setState(() => selectedIndex = 2);
                    if (isMobile) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                SidebarItem(
                  icon: Icons.description_outlined,
                  label: isArabic ? "إدارة الفواتير" : "Invoices",
                  isSelected: selectedIndex == 3,
                  onTap: () {
                    setState(() => selectedIndex = 3);
                    if (isMobile) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                SidebarItem(
                  icon: Icons.account_tree_outlined,
                  label: isArabic ? "شجرة الحسابات" : "Chart of Accounts",
                  isSelected: selectedIndex == 4,
                  onTap: () {
                    setState(() => selectedIndex = 4);
                    if (isMobile) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                SidebarItem(
                  icon: Icons.analytics_outlined,
                  label: isArabic ? "التقارير المالية" : "Financial Reports",
                  isSelected: selectedIndex == 5,
                  onTap: () {
                    setState(() => selectedIndex = 5);
                    if (isMobile) {
                      Navigator.of(context).pop();
                    }
                  },
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Divider(height: 1),
                ),

                // 2. Inventory & Operations
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    isArabic ? "المخزون والعمليات" : "Inventory & Operations",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.85),
                    ),
                  ),
                ),
                SidebarItem(
                  icon: Icons.inventory_2_outlined,
                  label: isArabic ? "العناصر والمخزون" : "Items & Stock",
                  isSelected: selectedIndex >= 6 && selectedIndex <= 10,
                  hasArrow: true,
                  isExpanded: isItemsExpanded,
                  onTap: () =>
                      setState(() => isItemsExpanded = !isItemsExpanded),
                ),
                if (isItemsExpanded) ...[
                  SidebarItem(
                    icon: Icons.list_alt,
                    label: isArabic ? "قائمة العناصر" : "Items List",
                    isSelected: selectedIndex == 6,
                    onTap: () {
                      setState(() => selectedIndex = 6);
                      if (isMobile) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  SidebarItem(
                    icon: Icons.category_outlined,
                    label: isArabic ? "فئات المنتجات" : "Categories",
                    isSelected: selectedIndex == 7,
                    onTap: () {
                      setState(() => selectedIndex = 7);
                      if (isMobile) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  SidebarItem(
                    icon: Icons.warehouse_outlined,
                    label: isArabic ? "إدارة المستودعات" : "Warehouses",
                    isSelected: selectedIndex == 8,
                    onTap: () {
                      setState(() => selectedIndex = 8);
                      if (isMobile) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  SidebarItem(
                    icon: Icons.straighten,
                    label: isArabic ? "وحدات القياس" : "Units",
                    isSelected: selectedIndex == 9,
                    onTap: () {
                      setState(() => selectedIndex = 9);
                      if (isMobile) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  SidebarItem(
                    icon: Icons.qr_code,
                    label: isArabic ? "الباركودات" : "Barcodes",
                    isSelected: selectedIndex == 10,
                    onTap: () {
                      setState(() => selectedIndex = 10);
                      if (isMobile) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Divider(height: 1),
                ),

                // 3. System & Administration
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    isArabic ? "النظام والإدارة" : "System & Settings",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.85),
                    ),
                  ),
                ),
                SidebarItem(
                  icon: Icons.settings_outlined,
                  label: isArabic ? "الإعدادات والمستخدمين" : "Settings",
                  isSelected: selectedIndex == 11 || selectedIndex == 12,
                  hasArrow: true,
                  isExpanded: isSettingsExpanded,
                  onTap: () => setState(
                      () => isSettingsExpanded = !isSettingsExpanded),
                ),
                if (isSettingsExpanded) ...[
                  SidebarItem(
                    icon: Icons.manage_accounts_outlined,
                    label: isArabic ? "إدارة المستخدمين" : "Users Management",
                    isSelected: selectedIndex == 11,
                    onTap: () {
                      setState(() => selectedIndex = 11);
                      if (isMobile) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  SidebarItem(
                    icon: Icons.person_outline,
                    label: isArabic ? "ملفي الشخصي" : "Profile",
                    isSelected: selectedIndex == 12,
                    onTap: () {
                      setState(() => selectedIndex = 12);
                      if (isMobile) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ],
            ),
          ),

          // Version footer
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if (_packageInfo != null) {
                      _showVersionInfo();
                    }
                  },
                  child: Text(
                    _packageInfo != null
                        ? 'v${_packageInfo!.version}'
                        : 'v3.4.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Text(
                  isArabic ? 'بكرة © 2026' : 'Bokrah © 2026',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget topBar = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.15),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Breadcrumb & Page title
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _pageIcon(selectedIndex),
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  isArabic ? "بكرة / " : "Bokrah / ",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.45),
                  ),
                ),
                Flexible(
                  child: Text(
                    _pageTitle(selectedIndex, isArabic),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Actions
          Row(
            children: [
              // Language & Theme Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () =>
                          context.read<SettingsCubit>().toggleLanguage(),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        child: Text(
                          isArabic ? 'EN' : 'العربية',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 16,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.15),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      tooltip: _themeTooltip(
                        context.watch<SettingsCubit>().state.bkThemeMode,
                        isArabic,
                      ),
                      icon: Icon(
                        _themeIcon(
                          context.watch<SettingsCubit>().state.bkThemeMode,
                        ),
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        context.read<SettingsCubit>().cycleThemeMode();
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),
              _buildUserMenu(),
              const SizedBox(width: 4),

              BlocBuilder<AppUpdateCubit, AppUpdateState>(
                builder: (context, updateState) {
                  return Stack(
                    children: [
                      IconButton(
                        icon:
                            const Icon(Icons.notifications_outlined, size: 24),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AppUpdateScreen(),
                            ),
                          );
                        },
                      ),
                      if (updateState.hasUnskippedUpdate)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );

    return BlocListener<AppUpdateCubit, AppUpdateState>(
      listener: (context, state) {
        if (state is AppUpdateAvailable &&
            state.hasUnskippedUpdate &&
            !_hasPromptedUpdateThisSession) {
          _hasPromptedUpdateThisSession = true;
          UpdatePromptDialog.show(
            context,
            release: state.release,
            installedVersion: state.installedVersion,
          );
        }
      },
      child: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          appBar: isMobile
              ? AppBar(
                  title: Text(_pageTitle(selectedIndex, isArabic)),
                  actions: [
                    IconButton(
                      tooltip: _themeTooltip(
                        context.watch<SettingsCubit>().state.bkThemeMode,
                        isArabic,
                      ),
                      icon: Icon(
                        _themeIcon(
                          context.watch<SettingsCubit>().state.bkThemeMode,
                        ),
                      ),
                      onPressed: () {
                        context.read<SettingsCubit>().cycleThemeMode();
                      },
                    ),
                    _buildUserMenu(isMobile: true),
                    BlocBuilder<AppUpdateCubit, AppUpdateState>(
                      builder: (context, updateState) {
                        return Stack(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.notifications_outlined,
                                  size: 22),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AppUpdateScreen(),
                                  ),
                                );
                              },
                            ),
                            if (updateState.hasUnskippedUpdate)
                              Positioned(
                                right: 6,
                                top: 6,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                )
              : null,
          drawer: isMobile
              ? Drawer(
                  child: SafeArea(
                    child: sidebarContent,
                  ),
                )
              : null,
          body: isMobile
              ? pages[selectedIndex]
              : Row(
                  children: [
                    sidebarContent,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          topBar,
                          Expanded(child: pages[selectedIndex]),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
