import 'package:flutter/material.dart';
import 'dart:math' as math;

class MonetaryRewardsWidget extends StatefulWidget {
  final double amount;
  final String currency;
  final VoidCallback? onComplete;

  const MonetaryRewardsWidget({
    super.key,
    required this.amount,
    this.currency = 'USD',
    this.onComplete,
  });

  @override
  State<MonetaryRewardsWidget> createState() => _MonetaryRewardsWidgetState();
}

class _MonetaryRewardsWidgetState extends State<MonetaryRewardsWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late AnimationController _sparkleController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  final List<Widget> _sparkles = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _sparkleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startAnimation();
  }

  void _startAnimation() async {
    // Start main animation
    _controller.forward();

    // Start pulse animation
    _pulseController.repeat(reverse: true);

    // Start sparkle animation
    _sparkleController.forward();

    // Generate sparkles
    _generateSparkles();

    // Complete after animation
    await Future.delayed(const Duration(milliseconds: 3000));
    widget.onComplete?.call();
  }

  void _generateSparkles() {
    setState(() {
      _sparkles.clear();
      for (int i = 0; i < 20; i++) {
        _sparkles.add(_buildSparkle());
      }
    });
  }

  Widget _buildSparkle() {
    final random = math.Random();
    final size = random.nextDouble() * 8 + 4;
    final left = random.nextDouble() * 200;
    final top = random.nextDouble() * 200;
    final delay = random.nextInt(1000);

    return Positioned(
      left: left,
      top: top,
      child: TweenAnimationBuilder<double>(
        duration: Duration(milliseconds: 1000 + delay),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.scale(
              scale: value,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.yellow.withOpacity(0.8),
                      blurRadius: 4,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Sparkles
          ..._sparkles,

          // Main reward content
          Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _scaleAnimation,
                _rotationAnimation,
                _pulseAnimation,
              ]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value * _pulseAnimation.value,
                  child: Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: _buildRewardContent(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardContent() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [Colors.yellow[300]!, Colors.orange[400]!, Colors.red[500]!],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.yellow.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Dollar sign
          Center(
            child: Text(
              '\$',
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),

          // Amount text
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Text(
              widget.amount.toStringAsFixed(0),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Currency
          Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: Text(
              widget.currency,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class FloatingMoneyWidget extends StatefulWidget {
  final double amount;
  final VoidCallback? onComplete;

  const FloatingMoneyWidget({super.key, required this.amount, this.onComplete});

  @override
  State<FloatingMoneyWidget> createState() => _FloatingMoneyWidgetState();
}

class _FloatingMoneyWidgetState extends State<FloatingMoneyWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<AnimationController> _moneyControllers;
  late List<Animation<double>> _moneyAnimations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _moneyControllers = List.generate(
      10,
      (index) => AnimationController(
        duration: Duration(milliseconds: 2000 + (index * 100)),
        vsync: this,
      ),
    );

    _moneyAnimations = _moneyControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    }).toList();

    _startAnimation();
  }

  void _startAnimation() async {
    _controller.forward();

    // Start money animations with delays
    for (int i = 0; i < _moneyControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        _moneyControllers[i].forward();
      });
    }

    await Future.delayed(const Duration(milliseconds: 3000));
    widget.onComplete?.call();
  }

  @override
  void dispose() {
    _controller.dispose();
    for (final controller in _moneyControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Floating money bills
          ...List.generate(10, (index) {
            return AnimatedBuilder(
              animation: _moneyAnimations[index],
              builder: (context, child) {
                final progress = _moneyAnimations[index].value;
                final random = math.Random(index);
                final startX = random.nextDouble() * 200;
                final startY = random.nextDouble() * 200;
                final endX = startX + (random.nextDouble() - 0.5) * 100;
                final endY = startY - 100;

                final currentX = startX + (endX - startX) * progress;
                final currentY = startY + (endY - startY) * progress;

                return Positioned(
                  left: currentX,
                  top: currentY,
                  child: Transform.rotate(
                    angle: progress * 2 * math.pi,
                    child: Opacity(
                      opacity: 1 - progress,
                      child: Container(
                        width: 40,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: const Center(
                          child: Text(
                            '\$',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
