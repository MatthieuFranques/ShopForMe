import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:mobile/models/grid.dart';
import 'package:mobile/models/node.dart';

class LocationService {
  double distance1 = 0.0;
  double distance2 = 0.0;
  double distance3 = 0.0;

  ///Converts the json plan to grid type. To know if the path is passable or not
  ///@param : String jsonFilePath : market plan
  ///Return Return the market plan in Grid
  Future<Grid> loadGridFromJson(String jsonFilePath) async {
    final String response = await rootBundle.loadString(jsonFilePath);
    final List<dynamic> jsonData = jsonDecode(response);

    final List<List<int>> grid = List.generate(
        jsonData.length, (_) => List<int>.filled(jsonData[0].length, 1));

    final List<List<int>> beaconPositions = [];

    for (int rowIndex = 0; rowIndex < jsonData.length; rowIndex++) {
      final List<dynamic> row = jsonData[rowIndex];
      for (int colIndex = 0; colIndex < row.length; colIndex++) {
        final Map<String, dynamic> cell = row[colIndex];
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

  ///Function which allows you to retrieve the distance of the beacons from the user
  ///@param : String jsonFilePath = json text of recive data bluetow
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

  ///Function which allows you to retrieve the distance of the beacons from the user
  ///@param : String jsonFilePath = json text of recive data bluetow
  Future<List<String>> loadDistances2(String jsonInput) async {
    String jsonString;

    // Vérifier si l'entrée est une chaîne JSON brute ou un chemin
    if (jsonInput.startsWith('{') || jsonInput.startsWith('[')) {
      // Traiter comme une chaîne JSON brute
      jsonString = jsonInput;
    } else {
      // Traiter comme un chemin vers un fichier d'assets
      jsonString = await rootBundle.loadString(jsonInput);
    }

    // Décoder le JSON en Map
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);

    // Vérifier que les clés nécessaires existent
    if (jsonData.containsKey('Tag 0') &&
        jsonData.containsKey('Tag 1') &&
        jsonData.containsKey('Tag 2')) {
      // Lire les valeurs
      distance1 = jsonData['Tag 0'];
      distance2 = jsonData['Tag 1'];
      distance3 = jsonData['Tag 2'];

      // Créer une liste des résultats
      return [
        distance1.toString(),
        distance2.toString(),
        distance3.toString(),
      ];
    } else {
      throw Exception('Le JSON ne contient pas les balises nécessaires.');
    }
  }

  /// Function which allows us to know the position of our Beacons on our market
  ///@param : String jsonFilePath = Market
  ///Return all position of Beacon in the market
  Future<List<List<int>>> getBeaconPositions(String jsonFilePath) async {
    final String response = await rootBundle.loadString(jsonFilePath);
    final List<dynamic> jsonData = jsonDecode(response);

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

  /// Function that returns the shortest path
  ///@param : Grid grid       =  Grid of shop
  ///@param : List<int> start =  Position of matrice of start
  ///@param : List<int> goal  =  Position of matrice of goal
  ///Return  the path to the goal  List<List<int>>
  List<List<int>> findShortestPath(Grid grid, List<int> start, List<int> goal) {
    final int n = grid.n;
    final int m = grid.m;
    final List<List<int>> distances =
        List.generate(n, (_) => List<int>.filled(m, 999999));
    final List<List<int>> previous =
        List.generate(n, (_) => List<int>.filled(m, -1));
    final PriorityQueue<Node> queue = PriorityQueue<Node>();

    distances[start[0]][start[1]] = 0;
    queue.add(Node(start[0], start[1], 0));

    final List<List<int>> directions = [
      [0, 1],
      [1, 0],
      [0, -1],
      [-1, 0]
    ];

    while (queue.isNotEmpty) {
      final Node current = queue.removeFirst();
      final int x = current.x;
      final int y = current.y;

      if (x == goal[0] && y == goal[1]) {
        break;
      }

      for (List<int> direction in directions) {
        final int newX = x + direction[0];
        final int newY = y + direction[1];

        if (grid.isValid(newX, newY)) {
          final int newDist = distances[x][y] + 1;

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
      final int prev = previous[x][y];
      x = prev ~/ m;
      y = prev % m;
    }

    path.add(start);
    path = path.reversed.toList();

    return path;
  }

  ///Allows you to calculate the user's position
  ///@param : List<int> pos1 = first beacon position on type [0.0]
  ///@param : List<int> pos2 = second beacon position on type [0.0]
  ///@param : List<int> pos3 = third beacon position on type [0.0]
  ///@param : double r1      = Distance(m or cm)  of the first beacon from the user
  ///@param : double r2      = Distance(m or cm)  of the second beacon from the user
  ///@param : double r3      = Distance(m or cm)  of the third beacon from the user
  ///Return the postion of user on matrix
  Future<List<double>> triangulateData(List<int> pos1, double r1,
      List<int> pos2, double r2, List<int> pos3, double r3) async {
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

  /// Function that executes all the functions of the service
  ///@param : Matrice of product
  ///Return Return the path to the product
  Future<List<List<int>>?> findTargetPosition(List<int> end) async {
    // TODO changé par le cache
    const String jsonFilePath = '../../assets/plan.json';
    const String jsonDistanceFile = '../../assets/beacon.json';
    final Grid grid = await loadGridFromJson(jsonFilePath);

    final List<List<int>> beaconPositions =
        await getBeaconPositions(jsonFilePath);

    await loadDistances(jsonDistanceFile);

    if (beaconPositions.length >= 3) {
      final List<double> targetPosition = await triangulateData(
        beaconPositions[0],
        distance1,
        beaconPositions[1],
        distance2,
        beaconPositions[2],
        distance3,
      );
      //Position actuelle
      final List<int> currentPosition = [
        targetPosition[0].round(),
        targetPosition[1].round()
      ];

      print(
          "distance1 : $distance1 , distance2 : $distance2 , distance3: $distance3");
      print("beaconPositions : $beaconPositions");
      print("currentPosition : $currentPosition");
      print("End : $end");

      final List<List<int>> path = findShortestPath(grid, currentPosition, end);
      print("Chemin le plus court : $path");
      return path;
    } else {
      print("Pas assez de beacons pour la triangulation.");
      return null;
    }
  }

  Future<List<int>> getProductPosition(String jsonFilePath) async {
    // TODO uncomment
    // final String response = await rootBundle.loadString(jsonFilePath);
    // final List<dynamic> jsonData = jsonDecode(response);

    final List<int> productPositions = [17, 12];

    // for (int rowIndex = 0; rowIndex < jsonData.length; rowIndex++) {
    //   final List<dynamic> row = jsonData[rowIndex];
    //   for (int colIndex = 0; colIndex < row.length; colIndex++) {
    //     final Map<String, dynamic> cell = row[colIndex];
    // TODO Mettre la condition qui est bonne
    // if (cell['isBeacon'] == true) {
    //   productPositions.add([rowIndex, colIndex]);
    // }
    // }
    // }

    return productPositions;
  }

  Future<List<List<int>>> findTargetPosition2(String jsonDistanceFile) async {
    // TODO changé par le cache
    const String jsonFilePath = 'assets/demo/plan28_11_24.json';
    print("PLAN UPLOADED ${jsonFilePath}");
    final Grid grid = await loadGridFromJson(jsonFilePath);

    final List<List<int>> beaconPositions =
        await getBeaconPositions(jsonFilePath);

    // Mettre un fonction qui permet de savoir ou est
    final List<int> productPosition = await getProductPosition(jsonFilePath);

    await loadDistances2(jsonDistanceFile);

    if (beaconPositions.length >= 3) {
      final List<double> targetPosition = await triangulateData(
        beaconPositions[0],
        distance1,
        beaconPositions[1],
        distance2,
        beaconPositions[2],
        distance3,
      );
      //Position actuelle
      final List<int> currentPosition = [
        targetPosition[0].round(),
        targetPosition[1].round()
      ];

      print(
          "distance1 : $distance1 , distance2 : $distance2 , distance3: $distance3");
      print("beaconPositions : $beaconPositions");
      print("currentPosition : $currentPosition");
      print("End : $productPosition");

      final List<List<int>> path =
          findShortestPath(grid, currentPosition, productPosition);
      print("Chemin le plus court : $path");
      return path;
    } else {
      print("Pas assez de beacons pour la triangulation.");
      return [
        [-1000, -1000]
      ];
    }
  }
}
