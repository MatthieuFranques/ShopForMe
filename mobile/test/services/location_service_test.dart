import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/models/Grid.dart';
import 'package:mobile/models/node.dart';
import 'package:mobile/services/location_service.dart';

// Sample JSON data directly in code
const String testGridJson = '''
[
  [{"type": "VIDE", "isBeacon": false}, {"type": "VIDE", "isBeacon": false}],
  [{"type": "VIDE", "isBeacon": true}, {"type": "WALL", "isBeacon": false}],
  [{"type": "VIDE", "isBeacon": false}, {"type": "VIDE", "isBeacon": true}]
]
''';

double distance1 = 0.0;
double distance2 = 0.0;
double distance3 = 0.0;

void main() {
  test('loadGridFromJson should create grid and detect beacons correctly',
      () async {
    final jsonData = jsonDecode(testGridJson);
    final grid = await loadGridFromJsonData(
        jsonData); // Adjusted function for direct data

    expect(grid.grid.length, 3); // 3 rows
    expect(grid.grid[0].length, 2); // 2 columns per row

    // Check if cells are marked correctly
    expect(grid.grid[0][0], 0); // Accessible cell
    expect(grid.grid[1][1], 1); // Wall or inaccessible cell
  });

  test('getBeaconPositions should detect beacon positions correctly', () async {
    final jsonData = jsonDecode(testGridJson);
    final beaconPositions = getBeaconPositionsData(jsonData);

    expect(beaconPositions.length, 2);
    expect(beaconPositions[0], [1, 0]);
    expect(beaconPositions[1], [2, 1]);
  });

  test('loadDistances should correctly load beacon distances', () async {
    final testDistancesJson = [
      {"distance": 5.0},
      {"distance": 3.0},
      {"distance": 4.0}
    ];

    loadDistancesData(testDistancesJson);

    expect(distance1, 5.0);
    expect(distance2, 3.0);
    expect(distance3, 4.0);
  });

  test('triangulateData should return approximate correct position', () async {
    final pos1 = [1, 0];
    final pos2 = [0, 1];
    final pos3 = [2, 1];
    final distance1 = 5.0;
    final distance2 = 3.0;
    final distance3 = 4.0;

    final result = await triangulateData(
        pos1, distance1, pos2, distance2, pos3, distance3);

    expect(result[0], isA<double>());
    expect(result[1], isA<double>());
  });

  test('findShortestPath should return the shortest path between two points',
      () {
    final grid = Grid(3, 2, [
      [0, 1],
      [0, 0],
      [1, 0]
    ]);

    final start = [0, 0];
    final goal = [2, 1];

    final path = findShortestPath(grid, start, goal);

    expect(path, [
      [0, 0],
      [1, 0],
      [1, 1],
      [2, 1]
    ]);
  });

  test('findTargetPosition with 1 beacon :', () async {
    final jsonData = jsonDecode(testGridJson);
    final grid = await loadGridFromJsonData(jsonData);
    final beaconPositions = getBeaconPositionsData(jsonData);

    loadDistancesData([
      {"distance": 5.0},
      {"distance": 3.0},
      {"distance": 4.0}
    ]);

    final path = findTargetPositionData(
        grid, beaconPositions, distance1, distance2, distance3);
    //Is null because the  beaconPositions have 1 beacon but i need 3
    expect(path, isNull);
  });
}

// TODO Add test with 3 beacon
// expect(path, isNotNull);
// expect(path, [
//   [0, 0],
//   [1, 0],
//   [1, 1],
//   [2, 1]
// ]);

// Modified functions to take data directly for testing

Future<Grid> loadGridFromJsonData(List<dynamic> jsonData) async {
  final List<List<int>> grid = List.generate(
      jsonData.length, (_) => List<int>.filled(jsonData[0].length, 1));

  for (int rowIndex = 0; rowIndex < jsonData.length; rowIndex++) {
    final List<dynamic> row = jsonData[rowIndex];
    for (int colIndex = 0; colIndex < row.length; colIndex++) {
      final Map<String, dynamic> cell = row[colIndex];
      grid[rowIndex][colIndex] = (cell['type'] == "VIDE") ? 0 : 1;
    }
  }
  return Grid(jsonData.length, jsonData[0].length, grid);
}

void loadDistancesData(List<dynamic> jsonData) {
  distance1 = jsonData[0]['distance'];
  distance2 = jsonData[1]['distance'];
  distance3 = jsonData[2]['distance'];
}

List<List<int>> getBeaconPositionsData(List<dynamic> jsonData) {
  final List<List<int>> beaconPositions = [];
  for (int rowIndex = 0; rowIndex < jsonData.length; rowIndex++) {
    final List<dynamic> row = jsonData[rowIndex];
    for (int colIndex = 0; colIndex < row.length; colIndex++) {
      final Map<String, dynamic> cell = row[colIndex];
      if (cell['isBeacon'] == true) {
        beaconPositions.add([rowIndex, colIndex]);
      }
    }
  }
  return beaconPositions;
}

List<List<int>>? findTargetPositionData(
    Grid grid,
    List<List<int>> beaconPositions,
    double distance1,
    double distance2,
    double distance3) {
  if (beaconPositions.length >= 3) {
    final List<double> targetPosition = triangulateData(
      beaconPositions[0],
      distance1,
      beaconPositions[1],
      distance2,
      beaconPositions[2],
      distance3,
    ) as List<double>;

    final List<int> currentPosition = [
      targetPosition[0].round(),
      targetPosition[1].round()
    ];

    final List<int> end = [5, 8];
    return findShortestPath(grid, currentPosition, end);
  } else {
    return null;
  }
}
