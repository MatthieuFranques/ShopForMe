import "package:mobile/models/zoneInstruction.dart";
import "package:mobile/services/navigation/compass_service.dart";

class DirectionService {
  /// Calculates the next direction depending on the [path] to follow.
  ///
  /// This function determines the direction from the current position to the next position in the [path]. The possible
  /// directions are nord, sud, est, or ouest. It compares the coordinates of the current and next positions to determine
  /// the direction.
  ///
  /// ### Parameters:
  /// - `path`: A list of lists where each inner list represents a position in the grid (e.g., [x, y]).
  ///
  /// ### Returns:
  /// An [ArrowDirection] representing the calculated direction.
  ///
  /// ### Example:
  /// ```dart
  /// ArrowDirection direction = calculateDirection([[0, 0], [0, 1]]);
  /// print(direction); // Prints ArrowDirection.est
  /// ```
  ArrowDirection calculateDirection(List<List<int>> path) {
    if (path.length < 2) return ArrowDirection.nord;

    final current = path[0];
    final next = path[1];

    if (next[0] < current[0]) return ArrowDirection.nord;
    if (next[0] > current[0]) return ArrowDirection.sud;
    if (next[1] < current[1]) return ArrowDirection.ouest;
    return ArrowDirection.est;
  }

  /// Gets the next direction depending on the [path] to follow and the [currentPosition].
  ///
  /// This function determines the next movement instruction based on the current position and the path to follow. It
  /// calculates the direction and distance to the next change in direction and returns a message with the direction and
  /// the number of steps to take.
  ///
  /// ### Parameters:
  /// - `path`: A list of lists where each inner list represents a position in the grid (e.g., [x, y]) that the user should follow.
  /// - `currentPosition`: The current position of the user represented as a list [x, y].
  ///
  /// ### Returns:
  /// A list containing:
  /// - `instructionMsg`: A string with the direction and distance to move.
  /// - `ArrowDirection`: The direction to move next.
  ///
  /// ### Example:
  /// ```dart
  /// List<Object> nextDirection = getNextDirection([[0, 0], [0, 1]], [0, 0]);
  /// print(nextDirection[0]); // Prints "12H00, Avancez de 1 pas"
  /// print(nextDirection[1]); // Prints ArrowDirection.nord
  /// ```
  List<Object> getNextDirection(
      List<List<int>> path, List<int> currentPosition, List<ZoneInstruction> zoneInstruction) {
    if (path.isEmpty) {
      print("Aucune instruction disponible");
      return ["Aucune instruction disponible", Null];
    }
    // final List<List<int>> fullPath = [currentPosition, ...path];

    // Déterminer la direction initiale
    int distance = 1;

    // Vérifier si l'utilisateur est dans une zone
    for (int i = 0; i < zoneInstruction.length; i++){
      if (zoneInstruction[i].isInRange(currentPosition)) {
        if (i == zoneInstruction.length - 1) {
          return ["Finished", zoneInstruction[i].direction];
        }
        else {
          return ["Avancez de $distance pas", zoneInstruction[i].direction];
        }
      }
    }

    // print("distance : $distance");
    // switch (initialDirection) {
    //   case ArrowDirection.nord:
    //     return ["12H00, Avancez de $distance pas", ArrowDirection.nord];
    //   case ArrowDirection.sud:
    //     return ["6H00, Avancez de $distance pas", ArrowDirection.sud];
    //   case ArrowDirection.est:
    //     return ["3H00, Avancez de $distance pas", ArrowDirection.est];
    //   case ArrowDirection.ouest:
    //     return ["9H00, Avancez de $distance pas", ArrowDirection.ouest];
    //   default:
    //     print("Direction inconnue, retourne null");
    //     return ["Direction inconnue", Null];
    // }
    return [Null, Null];
  }
}
