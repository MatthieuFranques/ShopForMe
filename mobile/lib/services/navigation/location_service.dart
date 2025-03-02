import 'package:collection/collection.dart';
import 'package:mobile/models/grid.dart';
import 'package:mobile/models/node.dart';

class LocationService {
  /// Function that returns the distances between the user and the anchors
  ///@param : List<String> anchorDistances: the distances between the user and the anchors (String formatted)
  List<double> loadDistances(List<String> anchorDistances) {
    final double anchorLeftDistance = double.parse(anchorDistances[0]);
    final double anchorMiddleDistance = double.parse(anchorDistances[1]);
    final double anchorRightDistance = double.parse(anchorDistances[2]);
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
    final List<List<int>> path = [];
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


  Future<List<int>?> getCurrentPosition(
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
      print("currentPosition : $currentPosition");
      return currentPosition;
    } else {
      print("Valeur null");
      return null;
    }
  }

  Future<List<List<int>>?> getShortestPath(
      List<String> anchorDistances, Grid grid) async {
    final List<int>? currentPosition =
        await getCurrentPosition(anchorDistances, grid);

    if (currentPosition == null) return null;
    if (grid.isValid(currentPosition[0], currentPosition[1])) {
      final List<List<int>> path =
          findShortestPath(grid, currentPosition, grid.productPosition);
      print("Chemin le plus court : $path");
      return path;
    } else {
      print("Current position is not valid");
      return null;
    }
  }

   ///Check if the user is still on the right path with a margin of ±1
  ///@param : currentPosition
  ///@param : path
  bool isPositionNearPath(List<int> currentPosition, List<List<int>> path) {
    for (var step in path) {
      if ((currentPosition[0] - step[0]).abs() <= 1 &&
          (currentPosition[1] - step[1]).abs() <= 1) {
        print("L'utilisateur est encore proche du chemin prévu");
        return true;
      }
    }
    print("L'utilisateur s'est trop éloigné");
    return false;
  }

}
