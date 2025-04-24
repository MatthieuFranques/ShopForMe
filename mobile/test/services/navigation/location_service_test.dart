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
        [1, 0],
        [2, 0],
        [3, 0],
        [4, 0],
        [4, 1],
        [4, 2],
        [4, 3],
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
        [4, 2]
      ]);
    });

    test('loadDistances correctly parses distances from strings', () {
      final parsed = locationService.loadDistances(["150.0", "200.5", "300.25"]);
      expect(parsed, [150.0, 200.5, 300.25]);
    });

    test('loadDistances throws on invalid input', () {
      expect(() => locationService.loadDistances(["abc", "200.5", "300.25"]), throwsA(isA<FormatException>()));
    });

    test('triangulateData returns correct position with known values', () async {
      final position = await locationService.triangulateData(
        [0, 0], 70.71,
        [0, 10], 70.71,
        [10, 0], 70.71,
      );
      expect(position.length, 2);
      expect(position[0], closeTo(5, 1));
      expect(position[1], closeTo(5, 1));
    });

    test('triangulateData throws if denominator is zero (bad anchor config)', () async {
      expect(
        () async => await locationService.triangulateData(
          [0, 0], 100,
          [0, 0], 100,
          [0, 0], 100,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('getCurrentPosition returns null when any distance is 0', () async {
      final grid = Grid(5, 5, List.generate(5, (_) => List.filled(5, 0)), [[0, 0], [1, 1], [2, 2]], [4, 4]);
      final position = await locationService.getCurrentPosition(["100.0", "0.0", "300.0"], grid);
      expect(position, isNull);
    });

    test('getAccessiblePositions works for edge of grid (e.g. [0, 0])', () {
      final currentPosition = [0, 0];
      final positions = locationService.getAccessiblePositions(currentPosition);
      expect(positions.length, 9);
      expect(positions.toString(), contains("[0, 0]"));
    });

    test('findShortestPath returns empty path if no path exists', () {
      final grid = Grid(3, 3, [
        [0, 1, 0],
        [1, 1, 1],
        [0, 1, 0],
      ], [], []);
      final path = locationService.findShortestPath(grid, [0, 0], [2, 2]);
      expect(path, [[2, 2]]);
    });

    test('updateCachePath returns full path if current position is not in it', () {
      final path = [
        [0, 0], [0, 1], [0, 2]
      ];
      final currentPosition = [2, 2];
      final newPath = locationService.updateCachePath(currentPosition, path);
      expect(newPath, path);
    });
  });
}
