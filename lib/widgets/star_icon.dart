import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedStar extends StatefulWidget {
  final bool filled;
  final double size;

  const AnimatedStar({super.key, required this.filled, this.size = 64});

  @override
  State<AnimatedStar> createState() => _AnimatedStarState();
}

class _AnimatedStarState extends State<AnimatedStar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 40),
      TweenSequenceItem(
          tween: Tween(begin: 1.3, end: 1.0)
              .chain(CurveTween(curve: Curves.elasticOut)),
          weight: 60),
    ]).animate(_controller);
    _shimmer = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(AnimatedStar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filled && !oldWidget.filled) {
      _controller.forward(from: 0);
    } else if (!widget.filled) {
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.filled ? _scale.value : 1.0,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              painter: _StarPainter(
                filled: widget.filled,
                shimmerProgress: _shimmer.value,
                size: widget.size,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StarPainter extends CustomPainter {
  final bool filled;
  final double shimmerProgress;
  final double size;

  _StarPainter({
    required this.filled,
    required this.shimmerProgress,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    final radius = canvasSize.width * 0.42;

    if (filled) {
      // Draw shimmer rays
      final rayPaint = Paint()
        ..color = Colors.amber.withValues(alpha: 0.6 * shimmerProgress)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;
      for (int i = 0; i < 8; i++) {
        final angle = (i * math.pi / 4) - math.pi / 2;
        final inner = radius * 0.8;
        final outer = radius * 1.4 * shimmerProgress;
        canvas.drawLine(
          Offset(center.dx + inner * math.cos(angle),
              center.dy + inner * math.sin(angle)),
          Offset(center.dx + outer * math.cos(angle),
              center.dy + outer * math.sin(angle)),
          rayPaint,
        );
      }

      // Filled star
      final fillPaint = Paint()..color = Colors.amber;
      canvas.drawPath(_starPath(center, radius), fillPaint);

      // Highlight
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill;
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(center.dx - radius * 0.15, center.dy - radius * 0.2),
            width: radius * 0.5,
            height: radius * 0.35),
        highlightPaint,
      );
    } else {
      // Hollow star
      final strokePaint = Paint()
        ..color = Colors.grey.shade400
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
      canvas.drawPath(_starPath(center, radius), strokePaint);
    }
  }

  Path _starPath(Offset center, double outerRadius) {
    final innerRadius = outerRadius * 0.4;
    final path = Path();
    for (int i = 0; i < 10; i++) {
      final r = i.isEven ? outerRadius : innerRadius;
      final angle = (i * math.pi / 5) - math.pi / 2;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(_StarPainter oldDelegate) {
    return oldDelegate.filled != filled ||
        oldDelegate.shimmerProgress != shimmerProgress;
  }
}
