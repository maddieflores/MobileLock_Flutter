import 'package:flutter/material.dart';
import '../../main.dart';

class LuminousAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final bool showLogo;
  final bool showThemeToggle;
  final bool showNotifications;
  final String title;
  final String? subtitle;

  const LuminousAppBar({
    super.key,
    this.showBackButton = false,
    this.showLogo = true,
    this.showThemeToggle = true,
    this.showNotifications = true,
    this.title = 'MobileLock AI',
    this.subtitle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(115);

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    const contentColor = Colors.white;
    final subtitleColor = const Color(0xFF00F0FF).withValues(alpha: 0.8);

    return Container(
      padding: EdgeInsets.only(
        top: topPadding + 18,
        bottom: 20,
        left: 22,
        right: 22,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1424), // Solid dark blue in both modes
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1.2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (showBackButton)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: contentColor),
              onPressed: () => Navigator.maybePop(context),
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.only(right: 8),
            )
          else if (showLogo) ...[
            const Icon(Icons.shield_outlined, color: contentColor, size: 24),
            const SizedBox(width: 8),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: contentColor,
                  fontFamily: 'Space Grotesk',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: TextStyle(
                    color: subtitleColor,
                    fontFamily: 'Space Grotesk',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
          const Spacer(),
          if (showThemeToggle)
            ValueListenableBuilder<ThemeMode>(
              valueListenable: themeNotifier,
              builder: (context, currentMode, _) {
                final isDarkTheme = currentMode == ThemeMode.dark;
                return IconButton(
                  icon: Icon(
                    isDarkTheme
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    color: contentColor,
                    size: 20,
                  ),
                  onPressed: () {
                    themeNotifier.value = isDarkTheme
                        ? ThemeMode.light
                        : ThemeMode.dark;
                  },
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                );
              },
            ),
          if (showNotifications)
            IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: contentColor,
                size: 20,
              ),
              onPressed: () {
                // Notification action
              },
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.only(left: 8),
            ),
        ],
      ),
    );
  }
}
