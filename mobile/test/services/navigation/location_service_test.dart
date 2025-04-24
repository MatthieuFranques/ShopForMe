import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/models/grid.dart';
import 'package:mobile/services/navigation/location_service.dart';

void main() {
  final locationService = LocationService();

  group('LocationService', () {
    test('findShortestPath should return correct path in simple grid', () {
      final grid = Grid(
        5,
        5,
        [
          [0, 0, 0, 0, 0],
          [0, 1, 1, 1, 0],
          [0, 1, 0, 0, 0],
          [0, 1, 0, 1, 0],
          [0, 0, 0, 0, 0],
        ],
        [],
        [],
      );

      final path = locationService.findShortestPath(grid, [0, 0], [4, 4]);

      expect(path, [
        [0, 0],
        [0, 1],
        [0, 2],
        [0, 3],
        [0, 4],
        [1, 4],
        [2, 4],
        [3, 4],
        [4, 4],
      ]);
    });

    test('isPositionNearPath returns true when position is adjacent to path', () {
      final path = [
        [2, 2],
        [2, 3],
        [2, 4]
      ];
      final currentPosition = [3, 3];

      final result = locationService.isPositionNearPath(currentPosition, path);
      expect(result, true);
    });

    test('isPositionNearPath returns false when position is not near path', () {
      final path = [
        [2, 2],
        [2, 3],
        [2, 4]
      ];
      final currentPosition = [4, 4];

      final result = locationService.isPositionNearPath(currentPosition, path);
      expect(result, false);
    });

    test('getAccessiblePositions returns 9 surrounding positions', () {
      final currentPosition = [3, 3];
      final positions = locationService.getAccessiblePositions(currentPosition);

      expect(positions.length, 9);
      expect(positions, containsAll([
        [2, 2], [2, 3], [2, 4],
        [3, 2], [3, 3], [3, 4],
        [4, 2], [4, 3], [4, 4]
      ]));
    });

    test('updateCachePath returns path starting from last reachable point', () {
      final path = [
        [0, 0], [0, 1], [0, 2],
        [1, 2], [2, 2], [3, 2],
        [4, 2]
      ];
      final currentPosition = [3, 2];

      final newPath = locationService.updateCachePath(currentPosition, path);
      expect(newPath, [
        [3, 2],
        [4, 2]
      ]);
    });
  });
}

