import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:medmind/app/routes/route_names.dart';
import 'package:medmind/app/theme/app_colors.dart';
import 'package:medmind/app/theme/app_typography.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.child, required this.state, super.key});

  final Widget child;
  final GoRouterState state;

  static const _tabs = [
    _TabItem(label: 'Home', icon: LucideIcons.home, path: RouteNames.home),
    _TabItem(
      label: 'Journal',
      icon: LucideIcons.bookOpen,
      path: RouteNames.journal,
    ),
    _TabItem(
      label: 'Insights',
      icon: LucideIcons.barChart2,
      path: RouteNames.insights,
    ),
    _TabItem(
      label: 'Settings',
      icon: LucideIcons.settings,
      path: RouteNames.settings,
    ),
  ];

  int _selectedIndex(String location) {
    if (location.startsWith(RouteNames.journal)) return 1;
    if (location.startsWith(RouteNames.insights)) return 2;
    if (location.startsWith(RouteNames.settings)) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = state.uri.toString();
    final selectedIndex = _selectedIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: _MedMindBottomNav(
        selectedIndex: selectedIndex,
        onTap: (index) => context.go(_tabs[index].path),
        items: _tabs,
      ),
    );
  }
}

class _MedMindBottomNav extends StatelessWidget {
  const _MedMindBottomNav({
    required this.selectedIndex,
    required this.onTap,
    required this.items,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;
  final List<_TabItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.zinc950,
        border: Border(top: BorderSide(color: AppColors.zinc800)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 52,
          child: Row(
            children: List.generate(items.length, (i) {
              final item = items[i];
              final isActive = i == selectedIndex;

              return Expanded(
                child: _NavItem(
                  item: item,
                  isActive: isActive,
                  onTap: () => onTap(i),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final _TabItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 28,
            decoration: isActive
                ? BoxDecoration(
                    color: AppColors.teal500_10,
                    borderRadius: BorderRadius.circular(6),
                  )
                : null,
            child: Icon(
              item.icon,
              size: 20,
              color: isActive ? AppColors.teal400 : AppColors.zinc500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.label,
            style: AppTypography.micro.copyWith(
              color: isActive ? AppColors.teal400 : AppColors.zinc500,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem {
  const _TabItem({required this.label, required this.icon, required this.path});

  final String label;
  final IconData icon;
  final String path;
}
