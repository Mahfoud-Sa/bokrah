import 'package:flutter/material.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contacts row
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(7, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.green[200],
                        child: Text(
                          "U$index",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text("User $index"),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),

          // Social Activities
          Expanded(
            child: Row(
              children: [
                // Twitter recent activity
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Twitter Recent Activity",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          Expanded(
                            child: Text(
                                "Example tweet activity goes here...\n(Multiple items in real use)."),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Other recent activity
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Other Recent Activity",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          Expanded(
                            child: Text(
                                "Example other activity goes here...\n(Multiple items in real use)."),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Upcoming Important Dates
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Jordan Kinlaw",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Wednesday, May 20"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Kira Agres",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("Thursday, May 21"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
