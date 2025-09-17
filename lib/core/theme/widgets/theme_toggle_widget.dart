import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

class ThemeToggleWidget extends StatefulWidget {
  final bool showLabel;
  final bool isCompact;
  final VoidCallback? onToggle;

  const ThemeToggleWidget({
    super.key,
    this.showLabel = true,
    this.isCompact = false,
    this.onToggle,
  });

  @override
  State<ThemeToggleWidget> createState() => _ThemeToggleWidgetState();
}

class _ThemeToggleWidgetState extends State<ThemeToggleWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleToggle() async {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    final themeProvider = context.read<ThemeProvider>();
    await themeProvider.toggleTheme();

    widget.onToggle?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return widget.isCompact
            ? _buildCompactToggle(themeProvider)
            : _buildFullToggle(themeProvider);
      },
    );
  }

  Widget _buildCompactToggle(ThemeProvider themeProvider) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: IconButton(
            onPressed: _handleToggle,
            icon: Transform.rotate(
              angle: _rotationAnimation.value * 3.14159,
              child: Icon(
                _getThemeIcon(themeProvider.themeMode),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            tooltip: _getThemeTooltip(themeProvider.themeMode),
          ),
        );
      },
    );
  }

  Widget _buildFullToggle(ThemeProvider themeProvider) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Card(
            child: InkWell(
              onTap: _handleToggle,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.rotate(
                      angle: _rotationAnimation.value * 3.14159,
                      child: Icon(
                        _getThemeIcon(themeProvider.themeMode),
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    if (widget.showLabel) ...[
                      const SizedBox(width: 8),
                      Text(
                        _getThemeLabel(themeProvider.themeMode),
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getThemeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  String _getThemeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  String _getThemeTooltip(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Switch to Dark Mode';
      case ThemeMode.dark:
        return 'Switch to System Mode';
      case ThemeMode.system:
        return 'Switch to Light Mode';
    }
  }
}
