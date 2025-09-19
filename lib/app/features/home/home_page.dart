import 'package:bokrah/app/features/autoUpdate/presentation/app_update_screen.dart';
import 'package:bokrah/app/features/home/main_content.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:go_router/go_router.dart';
class SystemHomePage extends StatefulWidget {
  final PackageInfo packageInfo;
  const SystemHomePage({super.key, required this.packageInfo});

  @override
  State<SystemHomePage> createState() => _SystemHomePageState();
}

class _SystemHomePageState extends State<SystemHomePage> {
  bool _sidebarExpanded = true;
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  String _searchQuery = '';

  final List<SystemFeature> _features = [
    SystemFeature(
      icon: Icons.dashboard,
      title: 'Dashboard',
      description: 'Overview of your system metrics',
      enabled: true,
    ),
    SystemFeature(
      icon: Icons.security,
      title: 'Security',
      description: 'Manage security settings and permissions',
      enabled: true,
    ),
    SystemFeature(
      icon: Icons.storage,
      title: 'Storage',
      description: 'View and manage system storage',
      enabled: false,
    ),
    SystemFeature(
      icon: Icons.settings,
      title: 'Settings',
      description: 'Configure system preferences',
      enabled: true,
    ),
    SystemFeature(
      icon: Icons.analytics,
      title: 'Analytics',
      description: 'View system performance data',
      enabled: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _sidebarExpanded ? 250 : 80,
            decoration: BoxDecoration(
              color: _darkMode ? Colors.grey[900] : Colors.blue[700],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                // Sidebar Header
                Container(
                  height: 80,
                  padding: const EdgeInsets.all(16),
                  child: _sidebarExpanded
                      ? const Row(
                          children: [
                            Icon(Icons.memory, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              'System UI',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : const Center(
                          child: Icon(Icons.memory, color: Colors.white),
                        ),
                ),
                Divider(color: Colors.white.withOpacity(0.3)),
                // Sidebar Menu Items
                Expanded(
                  child: ListView(
                    children: [
                      _buildSidebarItem(Icons.dashboard, 'Dashboard', 0),
                      _buildSidebarItem(Icons.people, 'Users', 1),
                      _buildSidebarItem(Icons.devices, 'Devices', 2),
                      _buildSidebarItem(Icons.settings, 'Settings', 3),
                      _buildSidebarItem(Icons.help, 'Help', 4),
                    ],
                  ),
                ),
                // Sidebar Footer
                Divider(color: Colors.white.withOpacity(0.3)),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.white),
                  title: _sidebarExpanded
                      ? Text('Logout', style: TextStyle(color: Colors.white))
                      : null,
                  onTap: () {
                   //context.go('/');
                   Navigator.of(context).pop(context);
                  },
                ),
              ],
            ),
          ),

          // Main Content Area
          Expanded(
            child: Container(
              color: _darkMode ? Colors.grey[800] : Colors.grey[100],
              child: Column(
                children: [
                  // Top App Bar
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: _darkMode ? Colors.grey[900] : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            _sidebarExpanded ? Icons.menu_open : Icons.menu,
                            color: _darkMode ? Colors.white : Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _sidebarExpanded = !_sidebarExpanded;
                            });
                          },
                        ),
                        const SizedBox(width: 10),

                        // Search Bar
                        Expanded(
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: _darkMode
                                  ? Colors.grey[800]
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: _darkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                                hintText: 'Search...',
                                hintStyle: TextStyle(
                                  color: _darkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                              ),
                              style: TextStyle(
                                color: _darkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),

                        // Notification Icon with Badge
                        Stack(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.notifications,
                                color: _darkMode ? Colors.white : Colors.black,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => AppUpdateScreen(
                                      packageInfo: widget.packageInfo,
                                    ),
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: const Text(
                                  '3',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Settings Icon
                        IconButton(
                          icon: Icon(
                            Icons.settings,
                            color: _darkMode ? Colors.white : Colors.black,
                          ),
                          onPressed: () {
                            // Settings logic
                          },
                        ),

                        // Dark Mode Toggle
                        Switch(
                          value: _darkMode,
                          onChanged: (value) {
                            setState(() {
                              _darkMode = value;
                            });
                          },
                          activeColor: Colors.blue,
                        ),
                      ],
                    ),
                  ),

                  // Main Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // System Features Title
                          Text(
                            'System Features',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _darkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Features Grid
                          Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                    childAspectRatio: 1.5,
                                  ),
                              itemCount: _features.length,
                              itemBuilder: (context, index) {
                                final feature = _features[index];
                                return _buildFeatureCard(feature);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: _sidebarExpanded
          ? Text(title, style: const TextStyle(color: Colors.white))
          : null,
      onTap: () {
        // Handle navigation
      },
    );
  }

  Widget _buildFeatureCard(SystemFeature feature) {
    return Card(
      elevation: 3,
      color: _darkMode ? Colors.grey[700] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  feature.icon,
                  color: feature.enabled
                      ? _darkMode
                            ? Colors.lightBlue[200]
                            : Colors.blue
                      : Colors.grey,
                  size: 30,
                ),
                Switch(
                  value: feature.enabled,
                  onChanged: (value) {
                    setState(() {
                      _features[_features.indexOf(feature)] = feature.copyWith(
                        enabled: value,
                      );
                    });
                  },
                  activeColor: _darkMode ? Colors.lightBlue[200] : Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              feature.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _darkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              feature.description,
              style: TextStyle(
                color: _darkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SystemFeature {
  final IconData icon;
  final String title;
  final String description;
  final bool enabled;

  SystemFeature({
    required this.icon,
    required this.title,
    required this.description,
    required this.enabled,
  });

  SystemFeature copyWith({
    IconData? icon,
    String? title,
    String? description,
    bool? enabled,
  }) {
    return SystemFeature(
      icon: icon ?? this.icon,
      title: title ?? this.title,
      description: description ?? this.description,
      enabled: enabled ?? this.enabled,
    );
  }
}



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FLOKK UI',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF6FAF7),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    DashboardPage(),
    ContactsPage(),
    NotificationsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 220,
            color: const Color(0xFF2E7D64),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  "FLÖKK",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                SidebarItem(
                  icon: Icons.space_dashboard,
                  label: "Dashboard",
                  isSelected: selectedIndex == 0,
                  onTap: () => setState(() => selectedIndex = 0),
                ),
                SidebarItem(
                  icon: Icons.people,
                  label: "Contacts",
                  isSelected: selectedIndex == 1,
                  onTap: () => setState(() => selectedIndex = 1),
                ),
                SidebarItem(
                  icon: Icons.notifications,
                  label: "Notifications",
                  isSelected: selectedIndex == 2,
                  onTap: () => setState(() => selectedIndex = 2),
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                      Text(
                        selectedIndex == 0
                            ? "Dashboard"
                            : selectedIndex == 1
                                ? "Contacts"
                                : "Notifications",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      // Notification bell
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined,
                                size: 28),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "You have new system notifications.")),
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
                ),

                // Dynamic page
                Expanded(
                  child: pages[selectedIndex],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Sidebar item
class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isSelected ? Colors.black26 : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
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
    return const DashboardContent(); // moved out
  }
}

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "This is the Contacts Page",
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "This is the Notifications Page",
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
