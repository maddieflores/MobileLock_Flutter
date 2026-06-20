import 'package:flutter/material.dart';

class LuminousBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const LuminousBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    const bgColor = Color(0xFF0F1424);
    final borderColor = Colors.white.withValues(alpha: 0.08);
    final shadowColor = Colors.black.withValues(alpha: 0.3);

    // Items colors
    const activeColor = Color(0xFF00F0FF);
    const inactiveColor = Colors.white38;
    final selectBgColor = const Color(0xFF00F0FF).withValues(alpha: 0.05);
    final selectBorderColor = const Color(0xFF00F0FF).withValues(alpha: 0.4);
    final selectShadowColor = const Color(0xFF00F0FF).withValues(alpha: 0.15);

    return Container(
      padding: EdgeInsets.only(
        top: 10,
        bottom: bottomPadding > 0 ? bottomPadding : 12,
        left: 12,
        right: 12,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border(top: BorderSide(color: borderColor, width: 1.2)),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, -3), // shadow going upwards
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(
            index: 0,
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            label: 'Inicio',
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            selectBgColor: selectBgColor,
            selectBorderColor: selectBorderColor,
            selectShadowColor: selectShadowColor,
          ),
          _buildItem(
            index: 1,
            icon: Icons.add_moderator_outlined,
            activeIcon: Icons.add_moderator,
            label: 'Registrar',
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            selectBgColor: selectBgColor,
            selectBorderColor: selectBorderColor,
            selectShadowColor: selectShadowColor,
          ),
          _buildItem(
            index: 2,
            icon: Icons.gpp_bad_outlined,
            activeIcon: Icons.gpp_bad,
            label: 'Reportar Robo',
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            selectBgColor: selectBgColor,
            selectBorderColor: selectBorderColor,
            selectShadowColor: selectShadowColor,
          ),
          _buildItem(
            index: 3,
            icon: Icons.account_circle_outlined,
            activeIcon: Icons.account_circle,
            label: 'Perfil',
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            selectBgColor: selectBgColor,
            selectBorderColor: selectBorderColor,
            selectShadowColor: selectShadowColor,
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required Color activeColor,
    required Color inactiveColor,
    required Color selectBgColor,
    required Color selectBorderColor,
    required Color selectShadowColor,
  }) {
    final isSelected = currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: isSelected
              ? BoxDecoration(
                  color: selectBgColor,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: selectBorderColor, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: selectShadowColor,
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                )
              : BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.transparent, width: 1.5),
                ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                color: isSelected ? activeColor : inactiveColor,
                size: 24,
              ),
              const SizedBox(height: 5),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? activeColor : inactiveColor,
                  fontFamily: 'Space Grotesk',
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
