import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:mobile/models/Grid.dart';
import 'package:mobile/models/node.dart'; // Import de la bibliothèque collection

// TODO
// class LocationService {

double distance1 = 0.0;
double distance2 = 0.0;
double distance3 = 0.0;

Future<Grid> loadGridFromJson(String jsonFilePath) async {
  final String response = await rootBundle.loadString(jsonFilePath);
  final List<dynamic> jsonData = jsonDecode(response);

  List<List<int>> grid = List.generate(jsonData.length,
      (_) => List<int>.filled(jsonData[0].length, 1)); // Grille initiale

  List<List<int>> beaconPositions = [];

  for (int rowIndex = 0; rowIndex < jsonData.length; rowIndex++) {
    List<dynamic> row = jsonData[rowIndex];
    for (int colIndex = 0; colIndex < row.length; colIndex++) {
      Map<String, dynamic> cell = row[colIndex];
      if (cell['type'] == "VIDE") {
        grid[rowIndex][colIndex] = 0; // Accessible
      } else {
        grid[rowIndex][colIndex] = 1; // Inaccessible
      }
      if (cell['isBeacon'] == true) {
        beaconPositions.add([rowIndex, colIndex]);
      }
    }
  }
  return Grid(jsonData.length, jsonData[0].length, grid);
}

Future<void> loadDistances(String jsonFilePath) async {
  final String jsonString = await rootBundle.loadString(jsonFilePath);
  final List<dynamic> jsonData = jsonDecode(jsonString);

  if (jsonData.length >= 3) {
    distance1 = jsonData[0]['distance'];
    distance2 = jsonData[1]['distance'];
    distance3 = jsonData[2]['distance'];
  } else {
    throw Exception('Pas assez de beacons dans le fichier JSON.');
  }
}

Future<List<List<int>>> getBeaconPositions(String jsonFilePath) async {
  final String response = await rootBundle.loadString(jsonFilePath);
  final List<dynamic> jsonData = jsonDecode(response);

  List<List<int>> beaconPositions = [];

  for (int rowIndex = 0; rowIndex < jsonData.length; rowIndex++) {
    List<dynamic> row = jsonData[rowIndex];
    for (int colIndex = 0; colIndex < row.length; colIndex++) {
      Map<String, dynamic> cell = row[colIndex];
      if (cell['isBeacon'] == true) {
        beaconPositions.add([rowIndex, colIndex]);
      }
    }
  }

  return beaconPositions;
}

List<List<int>> findShortestPath(Grid grid, List<int> start, List<int> goal) {
  int n = grid.n;
  int m = grid.m;
  List<List<int>> distances =
      List.generate(n, (_) => List<int>.filled(m, 999999));
  List<List<int>> previous = List.generate(n, (_) => List<int>.filled(m, -1));
  PriorityQueue<Node> queue = PriorityQueue<Node>();

  distances[start[0]][start[1]] = 0;
  queue.add(Node(start[0], start[1], 0));

  List<List<int>> directions = [
    [0, 1],
    [1, 0],
    [0, -1],
    [-1, 0]
  ];

  while (queue.isNotEmpty) {
    Node current = queue.removeFirst();
    int x = current.x;
    int y = current.y;

    if (x == goal[0] && y == goal[1]) {
      break;
    }

    for (List<int> direction in directions) {
      int newX = x + direction[0];
      int newY = y + direction[1];

      if (grid.isValid(newX, newY)) {
        int newDist = distances[x][y] + 1;

        if (newDist < distances[newX][newY]) {
          distances[newX][newY] = newDist;
          previous[newX][newY] = x * m + y;
          queue.add(Node(newX, newY, newDist));
        }
      }
    }
  }

  List<List<int>> path = [];
  int x = goal[0];
  int y = goal[1];

  while (x != start[0] || y != start[1]) {
    path.add([x, y]);
    int prev = previous[x][y];
    x = prev ~/ m;
    y = prev % m;
  }

  path.add(start);
  path = path.reversed.toList();

  return path;
}

Future<List<List<int>>?> findTargetPosition() async {
  String jsonFilePath = '../../assets/plan.json';
  String jsonDistanceFile = '../../assets/beacon.json';
  Grid grid = await loadGridFromJson(jsonFilePath);

  List<List<int>> beaconPositions = await getBeaconPositions(jsonFilePath);

  await loadDistances(jsonDistanceFile);

  if (beaconPositions.length >= 3) {
    List<double> targetPosition = await triangulateData(
      beaconPositions[0],
      distance1,
      beaconPositions[1],
      distance2,
      beaconPositions[2],
      distance3,
    );
    //Position actuelle
    List<int> currentPosition = [
      targetPosition[0].round(),
      targetPosition[1].round()
    ];

    // TODO Position of product
    List<int> end = [5, 8];

    print(
        "distance1 : $distance1 , distance2 : $distance2 , distance3: $distance3");
    print("beaconPositions : $beaconPositions");
    print("currentPosition : $currentPosition");
    print("End : $end");

    List<List<int>> path = findShortestPath(grid, currentPosition, end);
    print("Chemin le plus court : $path");
    return path;
  } else {
    print("Pas assez de beacons pour la triangulation.");
    return null;
  }
}

Future<List<double>> triangulateData(List<int> pos1, double r1, List<int> pos2,
    double r2, List<int> pos3, double r3) async {
  final double x1 = pos1[0].toDouble();
  final double y1 = pos1[1].toDouble();
  final double x2 = pos2[0].toDouble();
  final double y2 = pos2[1].toDouble();
  final double x3 = pos3[0].toDouble();
  final double y3 = pos3[1].toDouble();

  final double d1 = r1;
  final double d2 = r2;
  final double d3 = r3;

  final double A = 2 * (x2 - x1);
  final double B = 2 * (y2 - y1);
  final double C = d1 * d1 - d2 * d2 - x1 * x1 + x2 * x2 - y1 * y1 + y2 * y2;

  final double D = 2 * (x3 - x2);
  final double E = 2 * (y3 - y2);
  final double F = d2 * d2 - d3 * d3 - x2 * x2 + x3 * x3 - y2 * y2 + y3 * y3;

  final double denominator = (E * A - B * D);
  if (denominator == 0) {
    throw Exception('Division par zéro détectée dans la triangulation.');
  }

  final double x = (C * E - F * B) / denominator;
  final double y = (C * D - A * F) / (B * D - A * E);

  return [x, y];
}
// TODO uncoment with location_service
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    List<List<int>>? path = await findTargetPosition();
    if (path == null) {
      print("Aucun chemin trouvé.");
    } else {
      print("Le chemin trouvé est : $path");
    }
  } catch (e) {
    print("Une erreur s'est produite : $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Application',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Test de la Fonction'),
        ),
        body: Center(
          child: Text('Vérifiez la console pour les résultats.'),
        ),
      ),
    );
  }
}
