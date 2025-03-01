

enum ArrowDirection { nord, sud, est, ouest }

class DirectionService {
  
  ArrowDirection calculateDirection(List<List<int>> path) {
    if (path.length < 2) return ArrowDirection.nord;

    final current = path[0];
    final next = path[1];

    if (next[0] < current[0]) return ArrowDirection.nord;
    if (next[0] > current[0]) return ArrowDirection.sud;
    if (next[1] < current[1]) return ArrowDirection.ouest;
    return ArrowDirection.est;
  }
  
  
  List<Object> getNextDirection(List<List<int>> path, List<int> currentPosition) {
    if (path.isEmpty || currentPosition == null) {
      print("Aucune instruction disponible");
      return ["Aucune instruction disponible", Null];
    }
    final List<List<int>> fullPath = [currentPosition, ...path];

    // Déterminer la direction initiale
    ArrowDirection initialDirection = calculateDirection(fullPath);
    int distance = 0;

    // Parcourir le chemin jusqu'au premier changement de direction
    for (int i = 0; i < fullPath.length - 1; i++) {
      final nextDirection = calculateDirection([fullPath[i], fullPath[i + 1]]);

      if (nextDirection == initialDirection) {
        distance++;
      } else {
        break;
      }
    }
    print("distance : $distance");
    switch (initialDirection) {
      case ArrowDirection.nord:
        return ["12H00, Avancez de $distance pas", ArrowDirection.nord];
      case ArrowDirection.sud:
        return ["6H00, Avancez de $distance pas", ArrowDirection.sud];
      case ArrowDirection.est:
        return ["3H00, Avancez de $distance pas", ArrowDirection.est];
      case ArrowDirection.ouest:
        return ["9H00, Avancez de $distance pas", ArrowDirection.ouest];
      default:
        print("Direction inconnue, retourne null");
        return ["Direction inconnue", Null];
    }
  }

}