import 'dart:async';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/services/navigation/compass_service.dart';

void main() {
  group('CompassService', () {
    late CompassService compassService;

    setUp(() {
      compassService = CompassService();
    });

    tearDown(() {
      compassService.dispose();
    });

    test('getAdjustedDirection returns correct angle', () {
      compassService.currentDirection = 30.0;
      final adjusted = compassService.getAdjustedDirection(90);
      expect(adjusted, 60);
    });

    test('calculateTargetAngleFromGrid returns correct angle for East', () {
      final angle = compassService.calculateTargetAngleFromGrid([0, 0], [0, 1]);
      expect(angle, closeTo(90, 0.01));
    });

    test('calculateTargetAngleFromGrid returns correct angle for South', () {
      final angle = compassService.calculateTargetAngleFromGrid([0, 0], [1, 0]);
      expect(angle, closeTo(0, 0.01));
    });

    test('calculateTargetAngleFromGrid returns correct angle for North-West', () {
      final angle = compassService.calculateTargetAngleFromGrid([2, 2], [1, 1]);
      expect(angle, closeTo(225, 0.01));
    });

    test('calculateTargetAngleFromGrid returns correct angle for South-West', () {
      final angle = compassService.calculateTargetAngleFromGrid([1, 1], [2, 0]);
      expect(angle, closeTo(315, 0.01));
    });

    test('calculateTargetAngle returns correct angle for NE', () {
      final angle = compassService.calculateTargetAngle(0, 0, 1, 1);
      expect(angle, closeTo(45, 0.01));
    });

    test('calculateTargetAngle returns 0 when facing north', () {
      final angle = compassService.calculateTargetAngle(0, 0, 1, 0);
      expect(angle, closeTo(0, 0.01));
    });

    test('calculateTargetAngle returns correct angle for West with negative coordinates', () {
      final angle = compassService.calculateTargetAngle(-1, -1, -1, -2);
      expect(angle, closeTo(270, 0.01));
    });

    test('calculateTargetAngle returns correct angle for South-West with negative coordinates', () {
      final angle = compassService.calculateTargetAngle(-1, -1, -2, -2);
      expect(angle, closeTo(225, 0.01));
    });

    test('getAdjustedDirectionFromArrow returns correct angle for nord', () {
      compassService.currentDirection = 300.0;
      final angle = compassService.getAdjustedDirectionFromArrow(ArrowDirection.nord);
      expect(angle, closeTo((60 - 300 + 360) % 360, 0.01));
    });

    test('getAdjustedDirectionFromArrow returns correct angle for est', () {
      compassService.currentDirection = 10.0;
      final angle = compassService.getAdjustedDirectionFromArrow(ArrowDirection.est);
      expect(angle, closeTo((150 - 10 + 360) % 360, 0.01));
    });

    test('getAdjustedDirectionFromArrow returns correct angle for ouest', () {
      compassService.currentDirection = 350.0;
      final angle = compassService.getAdjustedDirectionFromArrow(ArrowDirection.ouest);
      expect(angle, closeTo((330 - 350 + 360) % 360, 0.01));
    });

    test('getAdjustedDirectionFromArrow returns correct angle for finish', () {
      compassService.currentDirection = 45.0;
      final angle = compassService.getAdjustedDirectionFromArrow(ArrowDirection.finish);
      expect(angle, closeTo((0 - 45 + 360) % 360, 0.01));
    });

    test('compassStream emits heading from injected stream', () async {
      final controller = StreamController<CompassEvent>();
      final testService = CompassService.test(testStream: controller.stream);

      final values = <double>[];
      final sub = testService.compassStream.listen(values.add);

      controller.add(MockCompassEvent(heading: 123.0));
      await Future.delayed(const Duration(milliseconds: 10));

      expect(values, contains(123.0));

      await sub.cancel();
      await controller.close();
      testService.dispose();
    });
  });
}

/// Classe factice pour simuler CompassEvent
class MockCompassEvent implements CompassEvent {
  @override
  final double? heading;

  @override
  double? get accuracy => null;

  @override
  double? get headingForCameraMode => null;

  MockCompassEvent({this.heading});
}