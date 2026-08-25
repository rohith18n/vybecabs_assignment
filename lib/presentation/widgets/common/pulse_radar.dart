import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class PulseRadar extends StatefulWidget {
  final double size;
  final Color color;

  const PulseRadar({
    super.key,
    this.size = 240.0,
    this.color = AppColors.primary,
  });

  @override
  State<PulseRadar> createState() => _PulseRadarState();
}

class _PulseRadarState extends State<PulseRadar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _RadarPainter(
              animationValue: _controller.value,
              color: widget.color,
            ),
            child: Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cardElevated,
                  border: Border.all(color: widget.color, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.local_taxi_rounded,
                    color: widget.color,
                    size: 36,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final double animationValue;
  final Color color;

  _RadarPainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // Draw 3 staggered expanding ripple rings
    for (int i = 0; i < 3; i++) {
      final double waveProgress = (animationValue + (i * 0.33)) % 1.0;
      final double radius = 36.0 + ((maxRadius - 36.0) * waveProgress);
      final double opacity = (1.0 - waveProgress).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = color.withValues(alpha: opacity * 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      final fillPaint = Paint()
        ..color = color.withValues(alpha: opacity * 0.08)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, radius, fillPaint);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
