// Sidebar item
import 'package:flutter/material.dart';

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
