import 'package:flutter/material.dart';
import '../atoms/constants.dart';

class BarakahBarChart extends StatelessWidget {
  final List<BarData> data;
  final String title;
  final double maxValue;

  const BarakahBarChart({
    super.key,
    required this.data,
    required this.title,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: BarakahTypography.subtitle1),
        const SizedBox(height: BarakahSpacing.md),
        SizedBox(
          height: 200,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: data.map((item) {
              final height = (item.value / maxValue) * 180;
              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: height,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: item.color ?? BarakahColors.primary,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: BarakahSpacing.xs),
                    Text(
                      item.label,
                      style: BarakahTypography.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class BarakahPieChart extends StatelessWidget {
  final List<PieData> data;
  final String title;

  const BarakahPieChart({
    super.key,
    required this.data,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final total = data.fold<double>(0, (sum, item) => sum + item.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: BarakahTypography.subtitle1),
        const SizedBox(height: BarakahSpacing.md),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: AspectRatio(
                aspectRatio: 1,
                child: CustomPaint(
                  painter: _PieChartPainter(data),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data.map((item) {
                  final percentage =
                      (item.value / total * 100).toStringAsFixed(1);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: item.color ?? BarakahColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${item.label} ($percentage%)',
                            style: BarakahTypography.caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<PieData> data;

  _PieChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final total = data.fold<double>(0, (sum, item) => sum + item.value);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width < size.height ? size.width / 2 : size.height / 2;

    var startAngle = -90 * (3.14159 / 180);

    for (final item in data) {
      final sweepAngle = (item.value / total) * 2 * 3.14159;
      final paint = Paint()
        ..color = item.color ?? BarakahColors.primary
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BarData {
  final String label;
  final double value;
  final Color? color;

  const BarData({
    required this.label,
    required this.value,
    this.color,
  });
}

class PieData {
  final String label;
  final double value;
  final Color? color;

  const PieData({
    required this.label,
    required this.value,
    this.color,
  });
}
