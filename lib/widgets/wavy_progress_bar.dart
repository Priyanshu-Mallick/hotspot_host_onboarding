// lib/widgets/wavy_progress_bar.dart

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class WavyProgressBar extends StatelessWidget {
  final double progress; // Progress value (0.0 to 1.0)

  const WavyProgressBar({Key? key, required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double totalWidth = constraints.maxWidth;

        return Stack(
          children: [
            // Bottom: Wavy outline (background)
            CustomPaint(
              size: Size(totalWidth, 20), // Set the height of the progress bar
              painter: _WavyOutlinePainter(
                width: totalWidth, // Full width for the background outline
                color: AppColors.border3, // Outline color
              ),
            ),
            // Top: Wavy progress fill (progress part)
            CustomPaint(
              size: Size(totalWidth * progress, 20), // Width scaled to progress
              painter: _WavyOutlinePainter(
                width: totalWidth * progress, // Scaled to progress value
                color: AppColors.primaryAccent, // Fill color for progress
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WavyOutlinePainter extends CustomPainter {
  final double width;
  final Color color;

  _WavyOutlinePainter({required this.width, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color // Use the dynamic color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5; // Thin outline for the wavy path

    final path = Path();
    _drawWavyPath(path, width, size.height); // Draw wavy path based on width
    canvas.drawPath(path, paint);
  }

  // Shared function to draw the wavy path
  void _drawWavyPath(Path path, double width, double height) {
    double amplitude = height / 4; // Smaller amplitude for a smoother wave
    double waveLength = 20; // Adjust the wave length to match the design

    // Start the path from the left
    path.moveTo(0, height / 2);

    // Add waves
    for (double x = 0; x < width; x += waveLength) {
      path.quadraticBezierTo(
        x + waveLength / 4,
        height / 2 - amplitude, // Control point for the upward curve
        x + waveLength / 2, height / 2, // End point for the upward curve
      );
      path.quadraticBezierTo(
        x + 3 * waveLength / 4,
        height / 2 + amplitude, // Control point for the downward curve
        x + waveLength, height / 2, // End point for the downward curve
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint when progress or color changes
  }
}
