import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/models/grid.dart';
import 'package:mobile/services/navigation/location_service.dart';
// Remplacez par le bon chemin du fichier de votre service

void main() {
  group('LocationService', () {
    test('loadDistances should correctly parse string distances', () {
      final locationService = LocationService();

      // Test with valid distances
      final List<String> anchorDistances = ["100.0", "200.0", "300.0"];
      final List<double> expectedDistances = [100.0, 200.0, 300.0];

      final result = locationService.loadDistances(anchorDistances);

      expect(result, equals(expectedDistances));
    });

    test('loadDistances should throw an exception if input is invalid', () {
      final locationService = LocationService();

      // Test with invalid distance (non-numeric values)
      final List<String> anchorDistances = ["100.0", "invalid", "300.0"];

      expect(() => locationService.loadDistances(anchorDistances),
          throwsFormatException);
    });

    test('findShortestPath should return the correct path', () {
      final locationService = LocationService();

      final grid = Grid(5, 5, [
        [0, 0, 0, 0, 0],
        [0, 1, 1, 1, 0],
        [0, 1, 0, 0, 0],
        [0, 1, 0, 1, 0],
        [0, 0, 0, 0, 0]
      ], [], []);

      final start = [0, 0];
      final goal = [4, 4];

      final path = locationService.findShortestPath(grid, start, goal);

      final expectedPath = [
        [0, 0],
        [1, 0],
        [2, 0],
        [2, 1],
        [2, 2],
        [2, 3],
        [3, 3],
        [4, 3],
        [4, 4]
      ];

      expect(path, equals(expectedPath));
    });
    test('getCurrentPosition should return null if any anchor distance is zero',
        () async {
      final locationService = LocationService();

      final List<String> anchorDistances = ["0.0", "200.0", "300.0"];
      final grid = Grid(5, 5, [
        [0, 0, 0, 0, 0],
        [0, 1, 1, 1, 0],
        [0, 1, 0, 0, 0],
        [0, 1, 0, 1, 0],
        [0, 0, 0, 0, 0]
      ], [], [
        4,
        4
      ]); // Position de l'objectif

      final currentPosition =
          await locationService.getCurrentPosition(anchorDistances, grid);

      expect(currentPosition, isNull);
    });

    test('isPositionNearPath should return true if position is near path', () {
      final locationService = LocationService();

      final currentPosition = [1, 2];
      final path = [
        [1, 1],
        [2, 2],
        [3, 3]
      ];

      final result = locationService.isPositionNearPath(currentPosition, path);

      expect(result, isTrue);
    });
  });
}
