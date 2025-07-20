import 'dart:math' as math;

import 'package:flutter/material.dart';

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
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // タップ位置から中心までの距離と角度を計算
    final dx = offset.dx - center.dx;
    final dy = offset.dy - center.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    final angle = math.atan2(dy, dx);

    // 正規化された距離（0.0 - 1.0）
    final normalizedDistance = distance / radius;

    // 範囲外の場合は無視
    if (normalizedDistance > DartBoardPainter.outerDoubleRadius + 0.05) {
      return null;
    }

    // ブル領域かどうかチェック
    if (normalizedDistance <= DartBoardPainter.innerBullRadius) {
      return 'BULL';
    } else if (normalizedDistance <= DartBoardPainter.outerBullRadius) {
      return 'D-BULL';
    }

    // 角度を正規化 (ダーツボードは上方向が20、時計回り)
    double normalizedAngle = angle + math.pi / 2; // 上方向を0にする
    if (normalizedAngle < 0) normalizedAngle += 2 * math.pi;
    if (normalizedAngle >= 2 * math.pi) normalizedAngle -= 2 * math.pi;

    // セクションインデックスを計算
    final segmentAngle = 2 * math.pi / 20;
    final segmentIndex = (normalizedAngle / segmentAngle).round() % 20;
    final number = DartBoardPainter.numbers[segmentIndex];

    // 領域を判定（外側から内側へ）
    String prefix;
    if (normalizedDistance > DartBoardPainter.innerDoubleRadius &&
        normalizedDistance <= DartBoardPainter.outerDoubleRadius) {
      prefix = 'D';
    } else if (normalizedDistance > DartBoardPainter.innerSingleRadius &&
        normalizedDistance <= DartBoardPainter.innerDoubleRadius) {
      prefix = 'S';
    } else if (normalizedDistance > DartBoardPainter.innerTripleRadius &&
        normalizedDistance <= DartBoardPainter.outerTripleRadius) {
      prefix = 'T';
    } else if (normalizedDistance > DartBoardPainter.outerBullRadius &&
        normalizedDistance <= DartBoardPainter.innerTripleRadius) {
      prefix = 'S';
    } else {
      // ワイヤー部分や判定できない領域
      return null;
    }

    return '$prefix$number';
  }
}

class DartBoardPainter extends CustomPainter {
  final String? highlightedPosition;
  final double highlightIntensity;

  DartBoardPainter({this.highlightedPosition, this.highlightIntensity = 0.0});

  static const List<int> numbers = [
    20,
    1,
    18,
    4,
    13,
    6,
    10,
    15,
    2,
    17,
    3,
    19,
    7,
    16,
    8,
    11,
    14,
    9,
    12,
    5,
  ];

  // レイアウト定数
  static const double anglePerSegment = 2 * math.pi / 20;
  static const double padding = math.pi / 20;

  // 半径比率
  static const double outerDoubleRadius = .75;
  static const double innerDoubleRadius = .70;
  static const double outerSingleRadius = .70;
  static const double innerSingleRadius = .38;
  static const double outerTripleRadius = .38;
  static const double innerTripleRadius = .33;
  static const double innerInnerSingleRadius = .33;
  static const double outerBullRadius = .11;
  static const double innerBullRadius = .044;
  static const double innerRadius = 0.044;

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
      final number = numbers[i];
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

    if (highlightedPosition == 'BULL' || highlightedPosition == 'D-BULL') {
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

    if (highlightedPosition == 'BULL' || highlightedPosition == 'D-BULL') {
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
      radius * innerDoubleRadius,
      radius * outerDoubleRadius,
      startAngle,
      endAngle,
      colors.double,
      highlightType == 'D' ? highlightMultiplier : 0.0,
    );

    // 外側シングル領域
    _drawSegmentSection(
      canvas,
      center,
      radius * innerSingleRadius,
      radius * outerSingleRadius,
      startAngle,
      endAngle,
      colors.single,
      highlightType == 'S' ? highlightMultiplier : 0.0,
    );

    // トリプル領域
    _drawSegmentSection(
      canvas,
      center,
      radius * innerTripleRadius,
      radius * outerTripleRadius,
      startAngle,
      endAngle,
      colors.triple,
      highlightType == 'T' ? highlightMultiplier : 0.0,
    );

    // 内側シングル領域
    _drawSegmentSection(
      canvas,
      center,
      radius * outerBullRadius,
      radius * innerInnerSingleRadius,
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
    final outerBullHighlight = highlightedPosition == 'D-BULL'
        ? highlightIntensity
        : 0.0;
    final innerBullHighlight = highlightedPosition == 'BULL'
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

    canvas.drawCircle(center, radius * outerBullRadius, outerBullPaint);
    canvas.drawCircle(center, radius * innerBullRadius, innerBullPaint);
  }

  void _drawWires(Canvas canvas, Offset center, double radius) {
    final wirePaint = Paint()
      ..color = wireColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = wireStrokeWidth;

    // 同心円のワイヤー
    canvas.drawCircle(center, radius * outerDoubleRadius, wirePaint);
    canvas.drawCircle(center, radius * innerDoubleRadius, wirePaint);
    canvas.drawCircle(center, radius * outerSingleRadius, wirePaint);
    canvas.drawCircle(center, radius * innerSingleRadius, wirePaint);
    canvas.drawCircle(center, radius * outerTripleRadius, wirePaint);
    canvas.drawCircle(center, radius * innerTripleRadius, wirePaint);
    canvas.drawCircle(center, radius * innerInnerSingleRadius, wirePaint);
    canvas.drawCircle(center, radius * outerBullRadius, wirePaint);
    canvas.drawCircle(center, radius * innerBullRadius, wirePaint);

    // セクション分割線
    for (int i = 0; i < 20; i++) {
      final angle = -math.pi / 2 + i * anglePerSegment - padding;
      final outerPoint = Offset(
        center.dx + radius * outerDoubleRadius * math.cos(angle),
        center.dy + radius * outerDoubleRadius * math.sin(angle),
      );
      final innerPoint = Offset(
        center.dx + radius * outerBullRadius * math.cos(angle),
        center.dy + radius * outerBullRadius * math.sin(angle),
      );

      canvas.drawLine(innerPoint, outerPoint, wirePaint);
    }
  }

  void _drawNumbers(Canvas canvas, Offset center, double radius) {
    for (int i = 0; i < 20; i++) {
      final number = numbers[i];
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
