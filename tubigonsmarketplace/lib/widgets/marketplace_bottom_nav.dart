
import 'package:flutter/material.dart';

class MarketplaceBottomNav extends StatelessWidget {
  final int currentIndex;
  final bool hasProfileNotification;
  final ValueChanged<int> onTap;

  const MarketplaceBottomNav({
    super.key,
    required this.currentIndex,
    this.hasProfileNotification = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE5EFE8), width: 1),
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1F8F5F),
        unselectedItemColor: const Color(0xFF7E9C8D),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        elevation: 0,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle_rounded),
            label: 'Post Item',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message_rounded),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: _ProfileNavigationIcon(
              icon: Icons.person_outline,
              showNotification: hasProfileNotification,
            ),
            activeIcon: _ProfileNavigationIcon(
              icon: Icons.person_rounded,
              showNotification: hasProfileNotification,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _ProfileNavigationIcon extends StatelessWidget {
  final IconData icon;
  final bool showNotification;

  const _ProfileNavigationIcon({
    required this.icon,
    required this.showNotification,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        if (showNotification)
          Positioned(
            top: 0,
            right: -5,
            child: Semantics(
              label: 'New listing notification',
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xFFD92D20),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
