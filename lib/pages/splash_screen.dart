import 'package:flutter/material.dart';
import 'package:to_do_app/data/database.dart';
import 'package:to_do_app/pages/home_page.dart';
import 'package:to_do_app/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  final ToDoDatabase database;
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const SplashScreen({
    super.key,
    required this.database,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _openHomeAfterSplash();
  }

  Future<void> _openHomeAfterSplash() async {
    await Future<void>.delayed(const Duration(milliseconds: 1450));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (context, animation, secondaryAnimation) => HomePage(
          database: widget.database,
          onThemeToggle: widget.onThemeToggle,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = widget.isDarkMode;
    final Color textColor = isDarkMode ? darkInkColor : inkColor;
    final Color subtitleColor = isDarkMode
        ? const Color(0xFFA6B4B0)
        : const Color(0xFF75817D);

    return Scaffold(
      backgroundColor: isDarkMode ? darkCanvasColor : canvasColor,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.86, end: 1),
          duration: const Duration(milliseconds: 850),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) => Opacity(
            opacity: scale.clamp(0.0, 1.0),
            child: Transform.scale(scale: scale, child: child),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/branding/app_icon.png',
                width: 112,
                height: 112,
              ),
              const SizedBox(height: 22),
              Text(
                'Daymark',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                'Small steps. Big progress.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: subtitleColor,
                  letterSpacing: 0.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
