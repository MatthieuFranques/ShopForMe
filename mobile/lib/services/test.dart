import 'package:collection/collection.dart';

// Mouvement possible dans les 4 directions: Haut, Bas, Gauche, Droite
final List<List<int>> directions = [
  [0, 1], // Droite
  [1, 0], // Bas
  [0, -1], // Gauche
  [-1, 0], // Haut
];

class Grid {
  final List<List<Map<String, dynamic>>> grid;
  final int n, m;

  Grid(this.grid)
      : n = grid.length,
        m = grid[0].length;

  // Vérifie si une case est valide et peut être visitée (si le type est "VIDE")
  bool isValid(int x, int y) {
    return x >= 0 && x < n && y >= 0 && y < m && grid[x][y]["type"] == "VIDE";
  }
}

class Node {
  final int x, y, distance;

  Node(this.x, this.y, this.distance);

  // Comparaison pour la file de priorité
  bool operator <(Node other) => distance < other.distance;
}

List<List<int>> dijkstra(Grid grid, List<int> start, List<int> goal) {
  final List<List<int>> distances = List.generate(
      grid.n,
      (_) => List.generate(
          grid.m, (_) => 1000000)); // Utiliser 1000000 à la place d'infini
  final List<List<int>> cameFrom = List.generate(
      grid.n, (_) => List.generate(grid.m, (_) => -1)); // Stocker le chemin

  distances[start[0]][start[1]] = 0;

  // File de priorité
  final PriorityQueue<Node> queue =
      PriorityQueue((a, b) => a.distance.compareTo(b.distance));
  queue.add(Node(start[0], start[1], 0));

  while (queue.isNotEmpty) {
    final Node current = queue.removeFirst();

    print(
        "Traitement du noeud: (${current.x}, ${current.y}), Distance: ${current.distance}");

    // Si on atteint l'objectif, reconstruire le chemin
    if (current.x == goal[0] && current.y == goal[1]) {
      return reconstructPath(cameFrom, start, goal);
    }

    // Explorer les voisins
    for (List<int> d in directions) {
      final int nx = current.x + d[0];
      final int ny = current.y + d[1];

      if (grid.isValid(nx, ny)) {
        final int newDist =
            current.distance + 1; // Le coût pour une case est de 1

        if (newDist < distances[nx][ny]) {
          distances[nx][ny] = newDist;
          queue.add(Node(nx, ny, newDist));
          cameFrom[nx][ny] =
              current.x * grid.m + current.y; // Stocker l'origine du noeud

          print("Ajout du voisin: (${nx}, ${ny}), Nouvelle distance: $newDist");
        }
      } else {
        print("Position invalide: ($nx, $ny) ou obstacle rencontré.");
      }
    }
  }

  print("Aucun chemin trouvé.");
  return []; // Aucun chemin trouvé
}

List<List<int>> reconstructPath(
    List<List<int>> cameFrom, List<int> start, List<int> goal) {
  List<List<int>> path = [];
  int x = goal[0], y = goal[1];
  while (x != start[0] || y != start[1]) {
    path.add([x, y]);
    final int prev = cameFrom[x][y];
    x = prev ~/ cameFrom[0].length;
    y = prev % cameFrom[0].length;
  }
  path.add([start[0], start[1]]);
  print("Chemin reconstruit : $path");
  return path.reversed.toList();
}

void main() {
  // Représentation de la grille avec des objets JSON
  List<List<Map<String, dynamic>>> gridData = [
    [
      {"isBeacon": true, "type": "VIDE", "name": "X", "size": 0},
      {"isBeacon": true, "type": "OBSTACLE", "name": "Y", "size": 0},
      {"isBeacon": true, "type": "VIDE", "name": "X", "size": 0},
      {"isBeacon": true, "type": "VIDE", "name": "X", "size": 0},
      {"isBeacon": true, "type": "VIDE", "name": "X", "size": 0},
    ],
    [
      {"isBeacon": true, "type": "VIDE", "name": "X", "size": 0},
      {"isBeacon": true, "type": "OBSTACLE", "name": "Y", "size": 0},
      {"isBeacon": true, "type": "VIDE", "name": "X", "size": 0},
      {"isBeacon": true, "type": "OBSTACLE", "name": "Y", "size": 0},
      {"isBeacon": true, "type": "VIDE", "name": "X", "size": 0},
    ],
    [
      {"isBeacon": true, "type": "VIDE", "name": "X", "size": 0},
      {"isBeacon": true, "type": "VIDE", "name": "X", "size": 0},
      {"isBeacon": true, "type": "VIDE", "name": "X", "size": 0},
      {"isBeacon": true, "type": "OBSTACLE", "name": "Y", "size": 0},
      {"isBeacon": true, "type": "VIDE", "name": "X", "size": 0},
    ],
    [
      {"isBeacon": true, "type": "OBSTACLE", "name": "Y", "size": 0},
      {"isBeacon": true, "type": "OBSTACLE", "name": "Y", "size": 0},
      {"isBeacon": true, "type": "VIDE", "name": "X", "size": 0},
      {"isBeacon": true, "type": "VIDE", "name": "X", "size": 0},
      {"isBeacon": true, "type": "VIDE", "name": "X", "size": 0},
    ],
    [
      {"isBeacon": true, "type": "VIDE", "name": "X", "size": 0},
      {"isBeacon": true, "type": "VIDE", "name": "X", "size": 0},
      {"isBeacon": true, "type": "VIDE", "name": "X", "size": 0},
      {"isBeacon": true, "type": "OBSTACLE", "name": "Y", "size": 0},
      {"isBeacon": true, "type": "VIDE", "name": "X", "size": 0},
    ],
  ];

  Grid grid = Grid(gridData);
  List<int> start = [0, 0];
  List<int> goal = [4, 4];

  print("Démarrage de l'algorithme de Dijkstra");
  List<List<int>> path = dijkstra(grid, start, goal);

  if (path.isNotEmpty) {
    print("Chemin trouvé: $path");
  } else {
    print("Aucun chemin trouvé.");
  }
}
