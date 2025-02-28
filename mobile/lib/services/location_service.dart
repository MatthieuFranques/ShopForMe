import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:mobile/models/grid.dart';
import 'package:mobile/models/node.dart';

class LocationService {
  double tagLeft = 0.0;
  double tagMiddle = 0.0;
  double tagRight = 0.0;

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
          grid[rowIndex][colIndex] = 0;
        } else {
          grid[rowIndex][colIndex] = 1;
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
  Future<List<String>> loadDistances(String jsonInput) async {
    String jsonString;

    // Verif the enter of JSON {  or [
    if (jsonInput.startsWith('{') || jsonInput.startsWith('[')) {
      jsonString = jsonInput;
    } else {
      jsonString = await rootBundle.loadString(jsonInput);
    }

    //Decode JSON to Map
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);

    //Verif if key exist
    if (jsonData.containsKey('Tag 0') &&
        jsonData.containsKey('Tag 1') &&
        jsonData.containsKey('Tag 2')) {
      tagLeft = jsonData['Tag 0'];
      tagMiddle = jsonData['Tag 1'];
      tagRight = jsonData['Tag 2'];

      return [
        tagLeft.toString(),
        tagMiddle.toString(),
        tagRight.toString(),
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
  ///@param : List<int> anchorLeft = first beacon position on type [0.0]
  ///@param : List<int> anchorMiddle = second beacon position on type [0.0]
  ///@param : List<int> anchorRight = third beacon position on type [0.0]
  ///@param : double distanceLeft      = Distance(m or cm)  of the first beacon from the user
  ///@param : double distanceMiddle      = Distance(m or cm)  of the second beacon from the user
  ///@param : double distanceRight      = Distance(m or cm)  of the third beacon from the user
  ///Return the postion of user on matrix
  Future<List<double>> triangulateData(
      List<int> anchorLeft,
      double distanceLeft,
      List<int> anchorMiddle,
      double distanceMiddle,
      List<int> anchorRight,
      double distanceRight) async {
    const double echelle = 50.0; // 1 carreau = 50 cm

    // Convertir les positions en double
    final double x1 = anchorLeft[0].toDouble();
    final double y1 = anchorLeft[1].toDouble();
    final double x2 = anchorMiddle[0].toDouble();
    final double y2 = anchorMiddle[1].toDouble();
    final double x3 = anchorRight[0].toDouble();
    final double y3 = anchorRight[1].toDouble();
    print("x1 : $x1 y1: $y1 x2: $x2 y2: $y2 y3: $y3 x3: $x3");
    print(
        "distanceLeft : $distanceLeft distanceMiddle: $distanceMiddle  distanceRight: $distanceRight");
    // Convertir les distances en carreaux
    final double d1 = distanceLeft / echelle;
    final double d2 = distanceMiddle / echelle;
    final double d3 = distanceRight / echelle;

    // Calcul des coefficients
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

    // Calcul des coordonnées
    final double x = (C * E - F * B) / denominator;
    final double y = (C * D - A * F) / (B * D - A * E);

    return [x, y]; // Coordonnées en unités de carreaux
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

  Future<List<List<int>>> FindPositionFinal(
      String jsonDistanceFile,
      List<int> productPosition,
      List<List<int>> beaconPositions,
      Grid grid) async {
    List<int> sizeGrid = await getMatrixSize('assets/demo/plan28_11_24.json');

    await loadDistances(jsonDistanceFile);

    if (beaconPositions.length >= 3 &&
        tagLeft != 0.0 &&
        tagMiddle != 0.0 &&
        tagRight != 0.0) {
      List<int> anchorLeft = [1, 1];
      List<int> anchorMiddle = [3, 3];
      List<int> anchorRight = [4, 4];

      //[[2, 12] middle, [16, 3]left, [16, 17]Right]
      //TODO To refacto
      ListEquality equality = ListEquality();

      for (int i = 0; i < beaconPositions.length; i++) {
        print("beaconPositions[i] : ${beaconPositions[i]}");

        if (equality.equals(beaconPositions[i], [2, 12])) {
          print("if (beaconPositions[i] == [2, 12])");
          anchorMiddle = beaconPositions[i];
        }
        if (equality.equals(beaconPositions[i], [16, 3])) {
          print("(beaconPositions[i] == [16, 3])");
          anchorLeft = beaconPositions[i];
        }
        if (equality.equals(beaconPositions[i], [16, 17])) {
          print("(beaconPositions[i] == [16, 17])");
          anchorRight = beaconPositions[i];
        }
      }

      print(
          "anchorLeft : $anchorLeft , anchorMiddle : $anchorMiddle , anchorRight : $anchorRight");
      print(
          "tagLeft : $tagLeft , tagMiddle : $tagMiddle , tagRight : $tagRight");

      final List<double> targetPosition = await triangulateData(
        anchorLeft,
        tagLeft,
        anchorMiddle,
        tagMiddle,
        anchorRight,
        tagRight,
      );

      final List<int> currentPosition = [
        targetPosition[0].round(),
        targetPosition[1].round()
      ];
      print(
          "tagLeft : $tagLeft , tagMiddle : $tagMiddle , tagRight: $tagRight");
      print("beaconPositions : $beaconPositions");
      print("currentPosition : $currentPosition");
      print("End : $productPosition");

      //Verif the height of currentPosition if is outh of the grid [[-1000, -1000]]
      if (isPositionValid(sizeGrid, currentPosition) == true) {
        final List<List<int>> path =
            findShortestPath(grid, currentPosition, productPosition);
        print("Chemin le plus court : $path");
        return path;
      } else {
        print("currentPosition : $currentPosition + sizeGrid : $sizeGrid");
        return [
          [-1000, -1000]
        ];
      }
    } else {
      print("Pas assez de beacons pour la triangulation.");
      return [
        [-1000, -1000]
      ];
    }
  }

  Future<List<int>> getMatrixSize(String jsonFilePath) async {
    try {
      final String response = await rootBundle.loadString(jsonFilePath);
      List<dynamic> jsonData = jsonDecode(response);

      if (jsonData is List && jsonData.isNotEmpty && jsonData[0] is List) {
        int rowCount = jsonData.length;
        int columnCount = (jsonData[0] as List).length;
        return [rowCount, columnCount];
      } else {
        print("Erreur : Le JSON ne contient pas une matrice valide.");
        return [0, 0];
      }
    } catch (e) {
      print("Erreur lors du parsing du JSON : $e");
      return [0, 0];
    }
  }

  bool isPositionValid(List<int> sizeGrid, List<int> currentPosition) {
    if (sizeGrid.length != currentPosition.length) {
      return false;
    }
    for (int i = 0; i < sizeGrid.length; i++) {
      if (currentPosition[i] < 0 || currentPosition[i] > sizeGrid[i]) {
        return false;
      }
    }
    return true;
  }
}
