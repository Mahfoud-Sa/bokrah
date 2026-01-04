import 'package:bokrah/app/features/autoUpdate/presentation/app_update_screen.dart';
import 'package:bokrah/app/features/home/main_content.dart';
import 'package:bokrah/app/features/home/notification_page.dart';
import 'package:bokrah/app/features/home/contact_page.dart';
import 'package:bokrah/app/features/home/side_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  PackageInfo? _packageInfo;

  final List<Widget> pages = const [
    DashboardPage(),
    ContactsPage(),
    NotificationsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  void _showVersionInfo() {
    if (_packageInfo == null) return;

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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D64),
            ),
          ),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(color: Colors.black87)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    Widget sidebarContent = Container(
      width: 220,
      color: const Color(0xFF2E7D64),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            "نجم التقنية",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          SidebarItem(
            icon: Icons.space_dashboard,
            label: "لوحة التحكم",
            isSelected: selectedIndex == 0,
            onTap: () => setState(() => selectedIndex = 0),
          ),
          SidebarItem(
            icon: Icons.people,
            label: "المبيعات",
            isSelected: selectedIndex == 1,
            onTap: () => setState(() => selectedIndex = 1),
          ),
          SidebarItem(
            icon: Icons.notifications,
            label: "القيود",
            isSelected: selectedIndex == 2,
            onTap: () => setState(() => selectedIndex = 2),
          ),
          SidebarItem(
            icon: Icons.inventory_2,
            label: "العناصر",
            isSelected: false,
            onTap: () => context.go('/items'),
          ),
        ],
      ),
    );

    Widget topBar = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title
          Text(
            selectedIndex == 0
                ? "لوحة التحكم"
                : selectedIndex == 1
                ? "المبيعات"
                : "القيود",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          // Actions (settings, logout, notifications)
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.settings, size: 26),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Settings clicked")),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout, size: 26),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, size: 28),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AppUpdateScreen(
                            packageInfo: PackageInfo(
                              appName: 'appName',
                              packageName: 'packageName',
                              version: 'version',
                              buildNumber: 'buildNumber',
                            ),
                          ),
                        ),
                      );
                    },
                  ),
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
              ),
            ],
          ),
        ],
      ),
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: isMobile
            ? AppBar(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                elevation: 1,
                title: Text(
                  selectedIndex == 0
                      ? "لوحة التحكم"
                      : selectedIndex == 1
                      ? "المبيعات"
                      : "القيود",
                ),
                actions: [
                  // IconButton(
                  //   icon: const Icon(Icons.settings, size: 26),
                  //   onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(content: Text("Settings clicked")),
                  //   ),
                  // ),
                  IconButton(
                    icon: const Icon(Icons.logout, size: 26),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, size: 28),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AppUpdateScreen(
                          packageInfo: PackageInfo(
                            appName: 'appName',
                            packageName: 'packageName',
                            version: 'version',
                            buildNumber: 'buildNumber',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : null,
        drawer: isMobile
            ? Drawer(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF153B2E), Color(0xFF2E7D64)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 20,
                            ),
                            child: Row(
                              children: const [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.white24,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'عبدالله سالم بن زقر',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'مرحبا بك',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.close, color: Colors.white),
                              ],
                            ),
                          ),
                          const Divider(color: Colors.white24, height: 1),
                          Expanded(
                            child: ListView(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              children: [
                                ListTile(
                                  leading: const Icon(
                                    Icons.space_dashboard,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  title: const Text(
                                    'لوحة التحكم',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  selected: selectedIndex == 0,
                                  selectedTileColor: Colors.white24,
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    setState(() => selectedIndex = 0);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(
                                    Icons.people,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  title: const Text(
                                    'المبيعات',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  selected: selectedIndex == 1,
                                  selectedTileColor: Colors.white24,
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    setState(() => selectedIndex = 1);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  title: const Text(
                                    'القيود',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  selected: selectedIndex == 2,
                                  selectedTileColor: Colors.white24,
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    setState(() => selectedIndex = 2);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(
                                    Icons.inventory_2,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  title: const Text(
                                    'العناصر',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    context.go('/items');
                                  },
                                ),
                                const SizedBox(height: 8),
                                const Divider(color: Colors.white24),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    'الإعدادات',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  leading: const Icon(
                                    Icons.settings,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                  title: const Text(
                                    'الإعدادات',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Divider(color: Colors.white24),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
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
                                        ? 'v${_packageInfo!.version}+${_packageInfo!.buildNumber}'
                                        : 'v...',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                const Text(
                                  'حقوق النشر ©',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : null,
        body: isMobile
            ? Column(
                children: [
                  // top bar is provided by AppBar on mobile
                  Expanded(child: pages[selectedIndex]),
                ],
              )
            : Row(
                children: [
                  // desktop sidebar
                  sidebarContent,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top bar
                        topBar,
                        // Dynamic page
                        Expanded(child: pages[selectedIndex]),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// Pages
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardContent(); // moved out
  }
}
