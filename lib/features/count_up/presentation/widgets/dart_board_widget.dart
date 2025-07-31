import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ble_darts/shared/models/dart_board_model.dart';

class DartBoardWidget extends StatefulWidget {
  final String? highlightedPosition;
  final Duration highlightDuration;
  final VoidCallback? onHighlightEnd;
  final Function(String position)? onPositionTapped;

  const DartBoardWidget({
    super.key,
    this.highlightedPosition,
    this.highlightDuration = const Duration(milliseconds: 1500),
    this.onHighlightEnd,
    this.onPositionTapped,
  });

  @override
  State<DartBoardWidget> createState() => _DartBoardWidgetState();
}

class _DartBoardWidgetState extends State<DartBoardWidget>
    with TickerProviderStateMixin {
  late AnimationController _highlightController;
  late Animation<double> _highlightAnimation;

  @override
  void initState() {
    super.initState();
    _highlightController = AnimationController(
      duration: widget.highlightDuration,
      vsync: this,
    );
    _highlightAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _highlightController, curve: Curves.easeInOut),
    );

    _highlightController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _highlightController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        widget.onHighlightEnd?.call();
      }
    });
  }

  @override
  void didUpdateWidget(DartBoardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.highlightedPosition != null &&
        widget.highlightedPosition != oldWidget.highlightedPosition) {
      _highlightController.forward();
    }
  }

  @override
  void dispose() {
    _highlightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return AnimatedBuilder(
          animation: _highlightAnimation,
          builder: (context, child) {
            return GestureDetector(
              onTapDown: (details) {
                if (widget.onPositionTapped != null) {
                  final position = _getPositionFromOffset(
                    details.localPosition,
                    size,
                  );
                  if (position != null) {
                    widget.onPositionTapped!(position);
                  }
                }
              },
              child: CustomPaint(
                painter: DartBoardPainter(
                  highlightedPosition: widget.highlightedPosition,
                  highlightIntensity: _highlightAnimation.value,
                ),
                size: size,
              ),
            );
          },
        );
      },
    );
  }

  String? _getPositionFromOffset(Offset offset, Size size) {
    return DartBoardPosition.calculateFromOffset(offset, size);
  }
}

class DartBoardPainter extends CustomPainter {
  final String? highlightedPosition;
  final double highlightIntensity;

  DartBoardPainter({this.highlightedPosition, this.highlightIntensity = 0.0});

  // レイアウト定数
  static const double anglePerSegment = 2 * math.pi / 20;
  static const double padding = math.pi / 20;

  // テキスト位置
  static const double numberRadius = 0.88;

  // 色定数
  static const Color backgroundColor = Color(0xFF1a1a1a);
  static const Color wireColor = Color(0xFF2c2c2c);
  static const Color highlightColor = Color(0xFFffd700);
  static const Color textColor = Color(0xFFffffff);
  static const Color blackSegment = Color(0xFF000000);
  static const Color whiteSegment = Color(0xFFe8e6d3);
  static const Color blueSegment = Color.fromARGB(255, 43, 69, 187);
  static const Color redSegment = Color.fromARGB(255, 185, 20, 70);

  // アニメーション定数
  static const double highlightIntensityMultiplier = 0.9;
  static const double wireStrokeWidth = 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    _drawBackground(canvas, center, radius);
    _drawNumberSegments(canvas, center, radius);
    _drawBullsEye(canvas, center, radius);
    _drawWires(canvas, center, radius);
    _drawNumbers(canvas, center, radius);
  }

  void _drawBackground(Canvas canvas, Offset center, double radius) {
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, backgroundPaint);
  }

  void _drawNumberSegments(Canvas canvas, Offset center, double radius) {
    for (int i = 0; i < 20; i++) {
      final number = DartBoardConstants.numbers[i];
      final startAngle = -math.pi / 2 + i * anglePerSegment - padding;
      final endAngle = startAngle + anglePerSegment;

      final isHighlighted = _isPositionHighlighted(number);
      final highlightMultiplier = isHighlighted ? highlightIntensity : 0.0;

      _drawSingleSegment(
        canvas,
        center,
        radius,
        startAngle,
        endAngle,
        i,
        number,
        highlightMultiplier,
      );
    }
  }

  bool _isPositionHighlighted(int number) {
    if (highlightedPosition == null) return false;

    if (highlightedPosition == 'D-BULL' || highlightedPosition == 'S-BULL') {
      return false;
    }

    final regex = RegExp(r'([SDT])(\d+)');
    final match = regex.firstMatch(highlightedPosition!);

    if (match == null) return false;

    final targetNumber = int.parse(match.group(2)!);
    return targetNumber == number;
  }

  String? _getHighlightedType() {
    if (highlightedPosition == null) return null;

    if (highlightedPosition == 'D-BULL' || highlightedPosition == 'S-BULL') {
      return highlightedPosition;
    }

    final regex = RegExp(r'([SDT])(\d+)');
    final match = regex.firstMatch(highlightedPosition!);

    return match?.group(1);
  }

  void _drawSingleSegment(
    Canvas canvas,
    Offset center,
    double radius,
    double startAngle,
    double endAngle,
    int index,
    int number,
    double highlightMultiplier,
  ) {
    final highlightType = _getHighlightedType();
    final colors = _getSegmentColors(index);

    // ダブル領域
    _drawSegmentSection(
      canvas,
      center,
      radius * DartBoardConstants.innerDoubleRadius,
      radius * DartBoardConstants.outerDoubleRadius,
      startAngle,
      endAngle,
      colors.double,
      highlightType == 'D' ? highlightMultiplier : 0.0,
    );

    // 外側シングル領域
    _drawSegmentSection(
      canvas,
      center,
      radius * DartBoardConstants.innerSingleRadius,
      radius * DartBoardConstants.outerSingleRadius,
      startAngle,
      endAngle,
      colors.single,
      highlightType == 'S' ? highlightMultiplier : 0.0,
    );

    // トリプル領域
    _drawSegmentSection(
      canvas,
      center,
      radius * DartBoardConstants.innerTripleRadius,
      radius * DartBoardConstants.outerTripleRadius,
      startAngle,
      endAngle,
      colors.triple,
      highlightType == 'T' ? highlightMultiplier : 0.0,
    );

    // 内側シングル領域
    _drawSegmentSection(
      canvas,
      center,
      radius * DartBoardConstants.outerBullRadius,
      radius * DartBoardConstants.innerInnerSingleRadius,
      startAngle,
      endAngle,
      colors.single,
      highlightType == 'S' ? highlightMultiplier : 0.0,
    );
  }

  ({Color single, Color double, Color triple}) _getSegmentColors(int index) {
    final isBlack = index % 2 == 1;

    if (isBlack) {
      return (single: blackSegment, double: blueSegment, triple: blueSegment);
    } else {
      return (single: whiteSegment, double: redSegment, triple: redSegment);
    }
  }

  void _drawSegmentSection(
    Canvas canvas,
    Offset center,
    double innerRadius,
    double outerRadius,
    double startAngle,
    double endAngle,
    Color baseColor,
    double highlightMultiplier,
  ) {
    Color color = baseColor;
    if (highlightMultiplier > 0) {
      color =
          Color.lerp(
            baseColor,
            highlightColor,
            highlightMultiplier * highlightIntensityMultiplier,
          ) ??
          baseColor;
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(
      center.dx + innerRadius * math.cos(startAngle),
      center.dy + innerRadius * math.sin(startAngle),
    );

    path.arcTo(
      Rect.fromCircle(center: center, radius: innerRadius),
      startAngle,
      endAngle - startAngle,
      false,
    );

    path.lineTo(
      center.dx + outerRadius * math.cos(endAngle),
      center.dy + outerRadius * math.sin(endAngle),
    );

    path.arcTo(
      Rect.fromCircle(center: center, radius: outerRadius),
      endAngle,
      -(endAngle - startAngle),
      false,
    );

    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawBullsEye(Canvas canvas, Offset center, double radius) {
    final outerBullHighlight = highlightedPosition == 'S-BULL'
        ? highlightIntensity
        : 0.0;
    final innerBullHighlight = highlightedPosition == 'D-BULL'
        ? highlightIntensity
        : 0.0;

    Color outerBullColor = blueSegment;
    Color innerBullColor = redSegment;

    if (outerBullHighlight > 0) {
      outerBullColor =
          Color.lerp(
            outerBullColor,
            highlightColor,
            outerBullHighlight * highlightIntensityMultiplier,
          ) ??
          outerBullColor;
    }
    if (innerBullHighlight > 0) {
      innerBullColor =
          Color.lerp(
            innerBullColor,
            highlightColor,
            innerBullHighlight * highlightIntensityMultiplier,
          ) ??
          innerBullColor;
    }

    final outerBullPaint = Paint()
      ..color = outerBullColor
      ..style = PaintingStyle.fill;

    final innerBullPaint = Paint()
      ..color = innerBullColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * DartBoardConstants.outerBullRadius, outerBullPaint);
    canvas.drawCircle(center, radius * DartBoardConstants.innerBullRadius, innerBullPaint);
  }

  void _drawWires(Canvas canvas, Offset center, double radius) {
    final wirePaint = Paint()
      ..color = wireColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = wireStrokeWidth;

    // 同心円のワイヤー
    canvas.drawCircle(center, radius * DartBoardConstants.outerDoubleRadius, wirePaint);
    canvas.drawCircle(center, radius * DartBoardConstants.innerDoubleRadius, wirePaint);
    canvas.drawCircle(center, radius * DartBoardConstants.outerSingleRadius, wirePaint);
    canvas.drawCircle(center, radius * DartBoardConstants.innerSingleRadius, wirePaint);
    canvas.drawCircle(center, radius * DartBoardConstants.outerTripleRadius, wirePaint);
    canvas.drawCircle(center, radius * DartBoardConstants.innerTripleRadius, wirePaint);
    canvas.drawCircle(center, radius * DartBoardConstants.innerInnerSingleRadius, wirePaint);
    canvas.drawCircle(center, radius * DartBoardConstants.outerBullRadius, wirePaint);
    canvas.drawCircle(center, radius * DartBoardConstants.innerBullRadius, wirePaint);

    // セクション分割線
    for (int i = 0; i < 20; i++) {
      final angle = -math.pi / 2 + i * anglePerSegment - padding;
      final outerPoint = Offset(
        center.dx + radius * DartBoardConstants.outerDoubleRadius * math.cos(angle),
        center.dy + radius * DartBoardConstants.outerDoubleRadius * math.sin(angle),
      );
      final innerPoint = Offset(
        center.dx + radius * DartBoardConstants.outerBullRadius * math.cos(angle),
        center.dy + radius * DartBoardConstants.outerBullRadius * math.sin(angle),
      );

      canvas.drawLine(innerPoint, outerPoint, wirePaint);
    }
  }

  void _drawNumbers(Canvas canvas, Offset center, double radius) {
    for (int i = 0; i < 20; i++) {
      final number = DartBoardConstants.numbers[i];
      final angle =
          -math.pi / 2 + i * anglePerSegment - padding + anglePerSegment / 2;

      final textRadius = radius * numberRadius;
      final textPosition = Offset(
        center.dx + textRadius * math.cos(angle),
        center.dy + textRadius * math.sin(angle),
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: number.toString(),
          style: const TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial',
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          textPosition.dx - textPainter.width / 2,
          textPosition.dy - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(DartBoardPainter oldDelegate) {
    return oldDelegate.highlightedPosition != highlightedPosition ||
        oldDelegate.highlightIntensity != highlightIntensity;
  }
}
