import 'package:collection/collection.dart';
import 'package:mobile/models/grid.dart';
import 'package:mobile/models/node.dart';

class LocationService {
  /// Converts a list of string distances from anchors into a list of double distances.
  /// 
  /// This function parses the string values of anchor distances from the list [anchorDistances] 
  /// and converts them to double values representing the distances from the user to each anchor.
  ///
  /// ### Parameters:
  /// - `anchorDistances`: A list of strings representing the distances from the user to three anchors.
  ///
  /// ### Returns:
  /// A list of doubles representing the anchor distances from the user.
  ///
  /// ### Example:
  /// ```dart
  /// List<String> distances = ["100.0", "200.0", "300.0"];
  /// List<double> parsedDistances = loadDistances(distances);
  /// print(parsedDistances); // [100.0, 200.0, 300.0]
  /// ```
  List<double> loadDistances(List<String> anchorDistances) {
    final double anchorLeftDistance = double.parse(anchorDistances[0]);
    final double anchorMiddleDistance = double.parse(anchorDistances[1]);
    final double anchorRightDistance = double.parse(anchorDistances[2]);
    return [anchorLeftDistance, anchorMiddleDistance, anchorRightDistance];
  }

  /// Finds the shortest path between the [start] and [goal] within the given [grid].
  /// The function uses a breadth-first search (BFS) algorithm to find the shortest
  /// path and returns the path as a list of `[row, col]` coordinates.
  ///
  /// The function considers 4 possible directions: right, down, left, and up to 
  /// navigate through the grid. It uses a priority queue to explore the grid, 
  /// and tracks visited nodes and their previous nodes to reconstruct the path.
  ///
  /// The [grid] is represented by a list of rows and columns where:
  /// - `grid[posX][posY] == 0` means the position is valid (passable).
  /// - Any position with a value other than 0 is considered blocked.
  ///
  /// ### Parameters:
  /// - `grid`: The grid containing the layout, used to check valid positions.
  /// - `start`: A list representing the `[row, col]` coordinates of the starting position.
  /// - `goal`: A list representing the `[row, col]` coordinates of the goal position.
  ///
  /// ### Returns:
  /// A list of `[row, col]` coordinates representing the shortest path from `start` to `goal`.
  /// If no path is found, an empty list is returned.
  ///
  /// ### Example:
  /// ```dart
  /// Grid grid = Grid(5, 5, [[0, 0, 0, 0, 0], [0, 1, 1, 1, 0], [0, 1, 0, 0, 0], [0, 1, 0, 1, 0], [0, 0, 0, 0, 0]], [], []);
  /// List<int> start = [0, 0];
  /// List<int> goal = [4, 4];
  /// List<List<int>> path = findShortestPath(grid, start, goal);
  /// print(path); // [[0, 0], [0, 1], [1, 1], [2, 1], [3, 1], [4, 1], [4, 2], [4, 3], [4, 4]]
  /// ```
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

  /// Reconstructs the path from the goal to the start using a map of previous nodes.
  ///
  /// This function takes a map of `previous` nodes, a `start` position, a `goal` position, 
  /// and the number of columns (`cols`) in the grid. It traces back from the `goal` to the 
  /// `start` using the `previous` map and reconstructs the path.
  ///
  /// The function returns a list of `[row, col]` positions representing the reconstructed path.
  ///
  /// ### Parameters:
  /// - `previous`: A map where the key is a grid index and the value is the previous index in the path.
  /// - `start`: A list representing the `[row, col]` coordinates of the starting position.
  /// - `goal`: A list representing the `[row, col]` coordinates of the goal position.
  /// - `cols`: The number of columns in the grid (used for index calculations).
  ///
  /// ### Returns:
  /// A list of `[row, col]` coordinates representing the reconstructed path from start to goal.
  ///
  /// ### Example:
  /// ```dart
  /// Map<int, int> previous = {4: 3, 3: 2, 2: 1, 1: -1}; 
  /// List<int> start = [0, 1];
  /// List<int> goal = [1, 1];
  /// int cols = 3;
  ///
  /// List<List<int>> path = reconstructPath(previous, start, goal, cols);
  /// print(path); // [[0, 1], [0, 2], [1, 2], [1, 1]]
  /// ```
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

  /// Triangulates the position of a point based on the distances from three anchor points.
  ///
  /// This method calculates the (x, y) coordinates of a point using trilateration, 
  /// given the positions of three known anchor points and their respective distances 
  /// to the point being located. The distances are provided in centimeters, and the 
  /// function converts them to grid units (carreaux). The grid is assumed to have 
  /// a scale of 1 carreau = 50 cm.
  ///
  /// The triangulation process uses the following formula to solve for the point's coordinates:
  /// - \( x \) is calculated using the formula: 
  ///     \[
  ///     x = \frac{C * E - F * B}{E * A - B * D}
  ///     \]
  /// - \( y \) is calculated using the formula:
  ///     \[
  ///     y = \frac{C * D - A * F}{B * D - A * E}
  ///     \]
  ///
  /// ### Parameters:
  /// - `anchorLeft`: The coordinates of the left anchor point as a list of integers 
  ///   representing [x, y] in grid units.
  /// - `distanceLeft`: The distance from the point to the left anchor in centimeters.
  /// - `anchorMiddle`: The coordinates of the middle anchor point as a list of integers 
  ///   representing [x, y] in grid units.
  /// - `distanceMiddle`: The distance from the point to the middle anchor in centimeters.
  /// - `anchorRight`: The coordinates of the right anchor point as a list of integers 
  ///   representing [x, y] in grid units.
  /// - `distanceRight`: The distance from the point to the right anchor in centimeters.
  ///
  /// ### Returns:
  /// A `Future<List<int>>` that resolves to a list of two integers [x, y], 
  /// which represent the triangulated position in grid units (carreaux).
  ///
  /// ### Throws:
  /// - Throws an `Exception` if the denominator in the triangulation calculation is zero, 
  ///   which would indicate that the given distances are inconsistent or invalid.
  ///
  /// ### Example:
  /// ```dart
  /// List<int> anchorLeft = [0, 0];
  /// double distanceLeft = 100.0;
  /// List<int> anchorMiddle = [50, 0];
  /// double distanceMiddle = 70.0;
  /// List<int> anchorRight = [100, 0];
  /// double distanceRight = 120.0;
  /// 
  /// triangulateData(anchorLeft, distanceLeft, anchorMiddle, distanceMiddle, anchorRight, distanceRight)
  ///     .then((result) => print("Triangulated position: $result"));
  /// ```
  /// This will output the triangulated position based on the given anchor points and distances.
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

  /// Calculates the user's current position based on the distances to three anchor points.
  /// 
  /// This function uses triangulation to compute the user's position using the provided anchor distances.
  /// If any of the anchor distances is zero, the function returns `null` indicating the position cannot be determined.
  ///
  /// ### Parameters:
  /// - `anchorDistances`: A list of strings representing the distances to three anchor points.
  /// - `grid`: An instance of [Grid] that contains information about the grid and beacon positions.
  ///
  /// ### Returns:
  /// A [Future] that resolves to a list of integers representing the user's current position in the grid.
  /// Returns `null` if the distances are invalid (i.e., zero distance).
  ///
  /// ### Example:
  /// ```dart
  /// List<String> distances = ["100.0", "200.0", "300.0"];
  /// Grid grid = Grid(5, 5, [[0, 0], [1, 0], [2, 0]], [], [4, 4]);
  /// List<int>? position = await getCurrentPosition(distances, grid);
  /// print(position); // Prints the user's current position.
  /// ```
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

  /// Retrieves the shortest path from the user's current position to the target (product position) on the grid.
  /// 
  /// This function first calculates the current position using the [getCurrentPosition] function, then checks if
  /// the position is valid on the grid. If valid, it finds and returns the shortest path to the product's position.
  ///
  /// ### Parameters:
  /// - `anchorDistances`: A list of strings representing the distances to three anchor points.
  /// - `grid`: An instance of [Grid] that contains the grid layout and beacon positions.
  ///
  /// ### Returns:
  /// A [Future] that resolves to a list of lists of integers representing the shortest path from the current position to the target.
  /// Returns `null` if the position is invalid or the shortest path cannot be found.
  ///
  /// ### Example:
  /// ```dart
  /// List<String> distances = ["100.0", "200.0", "300.0"];
  /// Grid grid = Grid(5, 5, [[0, 0], [1, 0], [2, 0]], [], [4, 4]);
  /// List<List<int>>? path = await getShortestPath(distances, grid);
  /// print(path); // Prints the shortest path if available, otherwise null.
  /// ```
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

  /// Checks if the user's current position is close to the planned path with a margin of ±1.
  /// 
  /// This function compares the user's current position with each step in the path and returns `true` if the user
  /// is within a margin of ±1 from any step on the path. This is useful to check if the user is still on track
  /// with the planned navigation.
  ///
  /// ### Parameters:
  /// - `currentPosition`: A list of integers representing the user's current position on the grid.
  /// - `path`: A list of lists representing the planned path, with each step being a coordinate in the grid.
  ///
  /// ### Returns:
  /// A boolean indicating whether the user's position is near any step in the path (within ±1 margin).
  ///
  /// ### Example:
  /// ```dart
  /// List<int> position = [1, 2];
  /// List<List<int>> path = [[1, 1], [2, 2], [3, 3]];
  /// bool isNear = isPositionNearPath(position, path);
  /// print(isNear); // Prints true if the user is near the path.
  /// ```
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
