import 'package:flutter/material.dart';
import 'dart:math' as math;

class UsageCircle extends StatelessWidget {
  final int usedMinutes;
  final int totalMinutes;
  
  const UsageCircle({
    Key? key,
    required this.usedMinutes,
    required this.totalMinutes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = usedMinutes / totalMinutes;
    final remainingMinutes = totalMinutes - usedMinutes;
    final isOverLimit = usedMinutes >= totalMinutes;
    
    return Container(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Progress circle
          CustomPaint(
            size: Size(200, 200),
            painter: CircleProgressPainter(
              progress: math.min(1.0, progress),
              progressColor: isOverLimit 
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).primaryColor,
              backgroundColor: Theme.of(context).dividerColor.withOpacity(0.1),
            ),
          ),
          
          // Usage text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$usedMinutes min',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: isOverLimit 
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isOverLimit ? 'Over limit!' : 'of $totalMinutes min',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              if (!isOverLimit) ...[
                const SizedBox(height: 8),
                Text(
                  '$remainingMinutes min left',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  
  CircleProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;
    
    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;
    
    canvas.drawCircle(center, radius, backgroundPaint);
    
    // Draw progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.progressColor != progressColor ||
           oldDelegate.backgroundColor != backgroundColor;
  }
} 