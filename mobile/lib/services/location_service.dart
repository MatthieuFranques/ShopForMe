import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:mobile/models/grid.dart';
import 'package:mobile/models/node.dart';

class LocationService {
  ///Converts the json plan to grid type. To know if the path is passable or not
  ///@param : String jsonFilePath : market plan
  ///Return Return the market plan in Grid
  Future<Grid> loadGridFromJson(String jsonFilePath) async {
    print("Chargement du PLAN depuis $jsonFilePath");

    // Load the plan from the JSON file
    final String response = await rootBundle.loadString(jsonFilePath);
    final List<dynamic> plan = jsonDecode(response);
    final int numRows = plan.length;
    final int numCols = plan[0].length;
    final List<int> productPosition = await getProductPosition();

    // TODO
    // Modifier Grid charger les rayons disponibles dans Grid

    // Initialize the grid with default values
    final List<List<int>> grid =
        List.generate(numRows, (_) => List<int>.filled(numCols, 1));
    final List<List<int>> beaconPositions = [];

    for (int row = 0; row < numRows; row++) {
      final List<dynamic> rowData = plan[row];

      for (int col = 0; col < numCols; col++) {
        final Map<String, dynamic> cell = rowData[col];

        // Assign grid values based on cell type
        grid[row][col] = (cell['type'] == "VIDE") ? 0 : 1;

        // Check if the cell is a beacon
        // TODO
        // if (cell['isBeacon'] == true) {
        //   beaconPositions.add([row, col]);
        // }
        beaconPositions.add([16, 3]);
        beaconPositions.add([2, 12]);
        beaconPositions.add([16, 17]);
      }
    }
    return Grid(numRows, numCols, grid, beaconPositions, productPosition);
  }

  /// Function that returns the distances between the user and the anchors
  ///@param : List<String> anchorDistances: the distances between the user and the anchors (String formatted)
  List<double> loadDistances(List<String> anchorDistances) {
    double anchorLeftDistance = double.parse(anchorDistances[0]);
    double anchorMiddleDistance = double.parse(anchorDistances[1]);
    double anchorRightDistance = double.parse(anchorDistances[2]);
    return [anchorLeftDistance, anchorMiddleDistance, anchorRightDistance];
  }

  /// Function that returns the shortest path
  ///@param : Grid grid       =  Grid of shop
  ///@param : List<int> start =  Position of matrice of start
  ///@param : List<int> goal  =  Position of matrice of goal
  ///Return  the path to the goal  List<List<int>>
  List<List<int>> findShortestPath(Grid grid, List<int> start, List<int> goal) {
    final PriorityQueue<Node> queue = PriorityQueue<Node>();
    final Map<int, int> previous =
        {}; // Stores previous node in 1D index format
    final Set<int> visited = {}; // Track visited nodes
    final List<List<int>> directions = [
      [0, 1],
      [1, 0],
      [0, -1],
      [-1, 0]
    ];
    final int cols = grid.cols;

    queue.add(Node(start[0], start[1], 0));
    previous[start[0] * cols + start[1]] = -1; // Mark start

    while (queue.isNotEmpty) {
      final Node current = queue.removeFirst();
      final int x = current.x, y = current.y;
      final int index = x * cols + y;

      if (visited.contains(index)) continue;
      visited.add(index);

      if (x == goal[0] && y == goal[1]) break; // Stop if goal reached

      for (var dir in directions) {
        final int newX = x + dir[0], newY = y + dir[1];
        final int newIndex = newX * cols + newY;

        if (grid.isValid(newX, newY) && !visited.contains(newIndex)) {
          queue.add(Node(newX, newY, current.distance + 1));
          previous[newIndex] = index;
        }
      }
    }

    return reconstructPath(previous, start, goal, cols);
  }

  List<List<int>> reconstructPath(
      Map<int, int> previous, List<int> start, List<int> goal, int cols) {
    List<List<int>> path = [];
    int index = goal[0] * cols + goal[1];

    while (index != -1) {
      path.add([index ~/ cols, index % cols]);
      index = previous[index] ?? -1;
    }

    return path.reversed.toList();
  }

  ///Allows you to calculate the user's position
  ///@param : List<int> anchorLeft = first beacon position on type [0.0]
  ///@param : List<int> anchorMiddle = second beacon position on type [0.0]
  ///@param : List<int> anchorRight = third beacon position on type [0.0]
  ///@param : double distanceLeft      = Distance(m or cm)  of the first beacon from the user
  ///@param : double distanceMiddle      = Distance(m or cm)  of the second beacon from the user
  ///@param : double distanceRight      = Distance(m or cm)  of the third beacon from the user
  ///Return the postion of user on matrix
  Future<List<int>> triangulateData(
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

    return [x.round(), y.round()]; // Coordonnées en unités de carreaux
  }

  Future<List<int>> getProductPosition() async {
    final List<int> productPositions = [17, 12];
    return productPositions;
  }

  Future<List<List<int>>?> getShortestPath(
    List<String> anchorDistances, Grid grid) async {

    final List<double> distances = loadDistances(anchorDistances);
    final [anchorLeftDistance, anchorMiddleDistance, anchorRightDistance] =
        distances;

    if (anchorLeftDistance != 0.0 &&
        anchorMiddleDistance != 0.0 &&
        anchorRightDistance != 0.0) {
      final List<int> anchorLeft = grid.beaconPositions[0];
      final List<int> anchorMiddle = grid.beaconPositions[1];
      final List<int> anchorRight = grid.beaconPositions[2];

      print(
          "anchorLeft : $anchorLeft , anchorMiddle : $anchorMiddle , anchorRight : $anchorRight");
      print(
          "tagLeft : $anchorLeftDistance , tagMiddle : $anchorMiddleDistance , tagRight : $anchorRightDistance");

      final List<int> currentPosition = await triangulateData(
        anchorLeft,
        anchorLeftDistance,
        anchorMiddle,
        anchorMiddleDistance,
        anchorRight,
        anchorRightDistance,
      );
      final int gridRowsCount = grid.rows;
      final int gridColsCount = grid.cols; 
      print("currentPosition : $currentPosition, rows: $gridRowsCount, gridColsCount = $gridColsCount");

      if (grid.isValid(currentPosition[0], currentPosition[1])) {
        final List<List<int>> path =
            findShortestPath(grid, currentPosition, grid.productPosition);
        print("Chemin le plus court : $path");
        return path;
      } else {
        print("Current position is not valid");
        return null;
      }
    } else {
      print("Pas assez de beacons pour la triangulation.");
      return null;
    }
  }
}
