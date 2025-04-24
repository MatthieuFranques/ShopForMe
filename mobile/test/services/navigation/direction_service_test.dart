import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/services/navigation/direction_service.dart';
import 'package:mobile/services/navigation/compass_service.dart';
import 'package:mobile/models/zoneInstruction.dart';

void main() {
  final directionService = DirectionService();

  group('DirectionService', () {
    test('calculateDirection returns est', () {
      final direction = directionService.calculateDirection([
        [0, 0],
        [0, 1],
      ]);
      expect(direction, ArrowDirection.est);
    });

    test('calculateDirection returns nord', () {
      final direction = directionService.calculateDirection([
        [1, 0],
        [0, 0],
      ]);
      expect(direction, ArrowDirection.nord);
    });

    test('calculateDirection returns sud', () {
      final direction = directionService.calculateDirection([
        [0, 0],
        [1, 0],
      ]);
      expect(direction, ArrowDirection.sud);
    });

    test('calculateDirection returns ouest', () {
      final direction = directionService.calculateDirection([
        [0, 1],
        [0, 0],
      ]);
      expect(direction, ArrowDirection.ouest);
    });

    test('calculateDirection with insufficient path returns nord by default', () {
      final direction = directionService.calculateDirection([
        [0, 0],
      ]);
      expect(direction, ArrowDirection.nord);
    });

    test('getNextDirection returns correct instruction inside zone', () {
      final path = [
        [0, 0],
        [0, 1],
        [1, 1],
        [2, 1]
      ];
      final zones = getDirectionalZones(path);
      final instruction = directionService.getNextDirection(path, [1, 1], zones);
      expect(instruction[0], contains("Avancez"));
      expect(instruction[1], isA<ArrowDirection>());
    });

    test('getNextDirection returns Finished for last zone', () {
      final path = [
        [0, 0],
        [0, 1],
        [1, 1],
        [2, 1]
      ];
      final zones = getDirectionalZones(path);
      final lastCenter = zones.last.center;
      final instruction = directionService.getNextDirection(path, lastCenter, zones);
      expect(instruction[0], equals("Finished"));
      expect(instruction[1], zones.last.direction);
    });

    test('getNextDirection returns [null, null] if not in any zone', () {
      final path = [
        [0, 0],
        [0, 1],
        [1, 1],
        [2, 1]
      ];
      final zones = getDirectionalZones(path);
      final instruction = directionService.getNextDirection(path, [5, 5], zones);
      expect(instruction[0], isNull);
      expect(instruction[1], isNull);
    });

    test('ZoneInstruction isInRange returns true for position inside zone', () {
      final zone = ZoneInstruction(
        zone: [
          [2, 2],
          [2, 3],
          [2, 4],
          [3, 2],
          [3, 3],
          [3, 4],
          [4, 2],
          [4, 3],
          [4, 4],
        ],
        direction: ArrowDirection.est,
        center: [3, 3],
      );

      expect(zone.isInRange([3, 3]), isTrue);
      expect(zone.isInRange([4, 4]), isTrue);
      expect(zone.isInRange([5, 5]), isFalse);
    });

    test('ZoneInstruction getZoneRange returns correct bounding box', () {
      final zone = ZoneInstruction(
        zone: [
          [1, 1],
        ],
        direction: ArrowDirection.sud,
        center: [2, 2],
      );

      final range = zone.getZoneRange();
      expect(range, [
        [1, 1],
        [3, 3]
      ]);
    });
  });
}
