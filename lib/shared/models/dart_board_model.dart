import 'dart:math' as math;
import 'package:flutter/material.dart';

class DartBoardConstants {
  static const List<int> numbers = [
    20, 1, 18, 4, 13, 6, 10, 15, 2, 17, 3, 19, 7, 16, 8, 11, 14, 9, 12, 5,
  ];

  static const double outerDoubleRadius = 0.75;
  static const double innerDoubleRadius = 0.70;
  static const double outerSingleRadius = 0.70;
  static const double innerSingleRadius = 0.38;
  static const double outerTripleRadius = 0.38;
  static const double innerTripleRadius = 0.33;
  static const double innerInnerSingleRadius = 0.33;
  static const double outerBullRadius = 0.11;
  static const double innerBullRadius = 0.044;

  static const double toleranceMargin = 0.05;
  static const double segmentAngle = 2 * math.pi / 20;
}

class DartBoardPosition {
  static String? calculateFromOffset(Offset offset, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    final dx = offset.dx - center.dx;
    final dy = offset.dy - center.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    final angle = math.atan2(dy, dx);

    final normalizedDistance = distance / radius;

    if (normalizedDistance > DartBoardConstants.outerDoubleRadius + DartBoardConstants.toleranceMargin) {
      return null;
    }

    if (normalizedDistance <= DartBoardConstants.innerBullRadius) {
      return 'D-BULL';
    } else if (normalizedDistance <= DartBoardConstants.outerBullRadius) {
      return 'S-BULL';
    }

    final normalizedAngle = DartBoardGeometry.normalizeAngle(angle + math.pi / 2);
    final segmentIndex = DartBoardGeometry.calculateSegmentIndex(normalizedAngle);
    final number = DartBoardConstants.numbers[segmentIndex];

    final prefix = _determinePrefix(normalizedDistance);
    if (prefix == null) {
      return null;
    }

    return '$prefix$number';
  }

  static String? _determinePrefix(double normalizedDistance) {
    if (normalizedDistance > DartBoardConstants.innerDoubleRadius &&
        normalizedDistance <= DartBoardConstants.outerDoubleRadius) {
      return 'D';
    } else if (normalizedDistance > DartBoardConstants.innerSingleRadius &&
        normalizedDistance <= DartBoardConstants.innerDoubleRadius) {
      return 'S';
    } else if (normalizedDistance > DartBoardConstants.innerTripleRadius &&
        normalizedDistance <= DartBoardConstants.outerTripleRadius) {
      return 'T';
    } else if (normalizedDistance > DartBoardConstants.outerBullRadius &&
        normalizedDistance <= DartBoardConstants.innerTripleRadius) {
      return 'S';
    }
    return null;
  }
}

class DartBoardGeometry {
  static double normalizeAngle(double angle) {
    double normalized = angle;
    if (normalized < 0) normalized += 2 * math.pi;
    if (normalized >= 2 * math.pi) normalized -= 2 * math.pi;
    return normalized;
  }

  static int calculateSegmentIndex(double normalizedAngle) {
    return (normalizedAngle / DartBoardConstants.segmentAngle).round() % 20;
  }

  static bool isInBullArea(double normalizedDistance) {
    return normalizedDistance <= DartBoardConstants.outerBullRadius;
  }

  static bool isInInnerBull(double normalizedDistance) {
    return normalizedDistance <= DartBoardConstants.innerBullRadius;
  }

  static bool isInOuterBull(double normalizedDistance) {
    return normalizedDistance > DartBoardConstants.innerBullRadius &&
        normalizedDistance <= DartBoardConstants.outerBullRadius;
  }

  static bool isInDoubleArea(double normalizedDistance) {
    return normalizedDistance > DartBoardConstants.innerDoubleRadius &&
        normalizedDistance <= DartBoardConstants.outerDoubleRadius;
  }

  static bool isInTripleArea(double normalizedDistance) {
    return normalizedDistance > DartBoardConstants.innerTripleRadius &&
        normalizedDistance <= DartBoardConstants.outerTripleRadius;
  }

  static bool isInSingleArea(double normalizedDistance) {
    return (normalizedDistance > DartBoardConstants.innerSingleRadius &&
        normalizedDistance <= DartBoardConstants.innerDoubleRadius) ||
        (normalizedDistance > DartBoardConstants.outerBullRadius &&
        normalizedDistance <= DartBoardConstants.innerTripleRadius);
  }

  static bool isValidPosition(double normalizedDistance) {
    return normalizedDistance <= DartBoardConstants.outerDoubleRadius + DartBoardConstants.toleranceMargin;
  }
}

class DartBoardValidator {
  static bool isValidPositionString(String? position) {
    if (position == null) return false;
    
    if (position == 'D-BULL' || position == 'S-BULL') {
      return true;
    }

    final regex = RegExp(r'^([SDT])(\d+)$');
    final match = regex.firstMatch(position);
    
    if (match == null) return false;
    
    final number = int.tryParse(match.group(2)!);
    return number != null && DartBoardConstants.numbers.contains(number);
  }

  static int? getScoreFromPosition(String? position) {
    if (position == null) return null;
    
    if (position == 'D-BULL') return 50;
    if (position == 'S-BULL') return 25;
    
    final regex = RegExp(r'^([SDT])(\d+)$');
    final match = regex.firstMatch(position);
    
    if (match == null) return null;
    
    final prefix = match.group(1)!;
    final number = int.tryParse(match.group(2)!);
    
    if (number == null) return null;
    
    switch (prefix) {
      case 'S':
        return number;
      case 'D':
        return number * 2;
      case 'T':
        return number * 3;
      default:
        return null;
    }
  }
}