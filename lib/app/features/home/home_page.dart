import 'package:bokrah/app/features/autoUpdate/presentation/app_update_screen.dart';
import 'package:bokrah/app/features/home/main_content.dart';
import 'package:bokrah/app/features/home/notification_page.dart';
import 'package:bokrah/app/features/home/contact_page.dart';
import 'package:bokrah/app/features/home/side_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';



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
    return Directionality(
      textDirection: TextDirection.rtl, // 👈 RTL
      child: Scaffold(
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
                            // Settings button
                            IconButton(
                              icon: const Icon(Icons.settings, size: 26),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Settings clicked")),
                                );
                              },
                            ),

                            // Logout button
                            IconButton(
                              icon: const Icon(Icons.logout, size: 26),
                              onPressed: () {
                                // Example logout logic
                                Navigator.of(context).pop();
                              },
                            ),

                            // Notifications
                            Stack(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.notifications_outlined,
                                      size: 28),
                                  onPressed: () 
                                     {
                                Navigator.of(context).push(
                                  
                                  MaterialPageRoute(
                                    builder: (context) => AppUpdateScreen(
                                      packageInfo: PackageInfo(appName: 'appName', packageName: 'packageName', version: 'version', buildNumber: 'buildNumber')
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
      ),
    );
  }
}



// Pages
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  DashboardContent(); // moved out
  }
}
