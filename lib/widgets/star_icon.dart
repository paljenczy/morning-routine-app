import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../providers/completion_provider.dart';

export '../providers/completion_provider.dart' show WeeklyStar;

class AnimatedStar extends StatefulWidget {
  /// For the daily star, pass [filled] and leave [weeklyStar] null.
  /// For the weekly star, pass [weeklyStar] and leave [filled] null.
  final bool? filled;
  final WeeklyStar? weeklyStar;
  final double size;

  const AnimatedStar({
    super.key,
    this.filled,
    this.weeklyStar,
    this.size = 64,
  }) : assert(filled != null || weeklyStar != null,
            'Provide either filled or weeklyStar');

  bool get _isLit =>
      (filled == true) || (weeklyStar != null && weeklyStar != WeeklyStar.none);

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
      duration: const Duration(milliseconds: 700),
    );
    _scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.35), weight: 40),
      TweenSequenceItem(
          tween: Tween(begin: 1.35, end: 1.0)
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
    if (widget._isLit && !oldWidget._isLit) {
      _controller.forward(from: 0);
    } else if (!widget._isLit) {
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
          scale: widget._isLit ? _scale.value : 1.0,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              painter: _StarPainter(
                weeklyStar: widget.weeklyStar,
                filled: widget.filled ?? false,
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
  final WeeklyStar? weeklyStar;
  final bool filled;
  final double shimmerProgress;
  final double size;

  _StarPainter({
    required this.weeklyStar,
    required this.filled,
    required this.shimmerProgress,
    required this.size,
  });

  bool get _isLit =>
      filled || (weeklyStar != null && weeklyStar != WeeklyStar.none);
  bool get _isSuperStar => weeklyStar == WeeklyStar.superStar;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    final radius = canvasSize.width * 0.42;

    if (!_isLit) {
      final strokePaint = Paint()
        ..color = Colors.grey.shade400
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
      canvas.drawPath(_starPath(center, radius), strokePaint);
      return;
    }

    if (_isSuperStar) {
      _paintSuperStar(canvas, canvasSize, center, radius);
    } else {
      _paintWeekStar(canvas, canvasSize, center, radius);
    }
  }

  // ── Week star (amber, 8 rays) ────────────────────────────────────────────────
  void _paintWeekStar(
      Canvas canvas, Size canvasSize, Offset center, double radius) {
    // Rays
    final rayPaint = Paint()
      ..color = Colors.amber.withValues(alpha: 0.65 * shimmerProgress)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4) - math.pi / 2;
      final inner = radius * 0.85;
      final outer = radius * 1.45 * shimmerProgress;
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
    final hlPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.30)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(center.dx - radius * 0.15, center.dy - radius * 0.2),
          width: radius * 0.5,
          height: radius * 0.35),
      hlPaint,
    );
  }

  // ── Super star (bright yellow, outer glow, 12 rays, sparkles) ───────────────
  void _paintSuperStar(
      Canvas canvas, Size canvasSize, Offset center, double radius) {
    // Outer glow halo
    final glowPaint = Paint()
      ..color = const Color(0xFFFFE566).withValues(alpha: 0.35 * shimmerProgress)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(center, radius * 1.55 * shimmerProgress, glowPaint);

    // 12 rays — alternating long/short
    for (int i = 0; i < 12; i++) {
      final angle = (i * math.pi / 6) - math.pi / 2;
      final isLong = i.isEven;
      final inner = radius * 0.9;
      final outer = (isLong ? radius * 1.65 : radius * 1.35) * shimmerProgress;
      final rayPaint = Paint()
        ..color = const Color(0xFFFFD700)
            .withValues(alpha: (isLong ? 0.85 : 0.55) * shimmerProgress)
        ..strokeWidth = isLong ? 3.0 : 2.0
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(center.dx + inner * math.cos(angle),
            center.dy + inner * math.sin(angle)),
        Offset(center.dx + outer * math.cos(angle),
            center.dy + outer * math.sin(angle)),
        rayPaint,
      );
    }

    // Star fill — bright yellow gradient effect via two layers
    final basePaint = Paint()..color = const Color(0xFFFFD700);
    canvas.drawPath(_starPath(center, radius), basePaint);

    final brightPaint = Paint()..color = const Color(0xFFFFF176);
    canvas.drawPath(_starPath(center, radius * 0.72), brightPaint);

    // Strong highlight
    final hlPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.55)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(center.dx - radius * 0.15, center.dy - radius * 0.22),
          width: radius * 0.6,
          height: radius * 0.42),
      hlPaint,
    );

    // Sparkle dots at ray tips
    if (shimmerProgress > 0.5) {
      final sparkleAlpha = ((shimmerProgress - 0.5) * 2).clamp(0.0, 1.0);
      final sparklePaint = Paint()
        ..color = Colors.white.withValues(alpha: sparkleAlpha);
      for (int i = 0; i < 4; i++) {
        final angle = (i * math.pi / 2) - math.pi / 4;
        final dist = radius * 1.55;
        canvas.drawCircle(
          Offset(center.dx + dist * math.cos(angle),
              center.dy + dist * math.sin(angle)),
          3.0,
          sparklePaint,
        );
      }
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
        oldDelegate.weeklyStar != weeklyStar ||
        oldDelegate.shimmerProgress != shimmerProgress;
  }
}
