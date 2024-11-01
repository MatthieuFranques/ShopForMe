import 'dart:collection';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';

// Classe pour représenter la grille et vérifier les positions accessibles
class Grid {
  final int n, m;
  final List<List<int>> grid;

  Grid(this.n, this.m, this.grid);

  bool isValid(int x, int y) {
    return x >= 0 && x < n && y >= 0 && y < m && grid[x][y] == 0;
  }
}

// Classe pour représenter un noeud dans la file de priorité
class Node {
  final int x, y;
  final int distance;

  Node(this.x, this.y, this.distance);
}

double distance1 = 0.0;
double distance2 = 0.0;
double distance3 = 0.0;

// Récupère les positions des beacons et crée une grille
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
      // Marque la position comme accessible si le type est "VIDE"
      if (cell['type'] == "VIDE") {
        grid[rowIndex][colIndex] = 0; // Accessible
      } else {
        grid[rowIndex][colIndex] = 1; // Inaccessible
      }
      // Ajoute les positions des beacons
      if (cell['isBeacon'] == true) {
        beaconPositions.add([rowIndex, colIndex]);
      }
    }
  }
  return Grid(jsonData.length, jsonData[0].length, grid);
}

// Fonction pour obtenir les positions des beacons
Future<List<List<int>>> getBeaconPositions(String jsonFilePath) async {
  final String response = await rootBundle.loadString(jsonFilePath);
  final List<dynamic> jsonData = jsonDecode(response);

  List<List<int>> beaconPositions = [];

  for (int rowIndex = 0; rowIndex < jsonData.length; rowIndex++) {
    List<dynamic> row = jsonData[rowIndex];
    for (int colIndex = 0; colIndex < row.length; colIndex++) {
      Map<String, dynamic> cell = row[colIndex];
      // Vérifie si `isBeacon` est true
      if (cell['isBeacon'] == true) {
        beaconPositions
            .add([rowIndex, colIndex]); // Ajoute la position du beacon
      }
    }
  }

  return beaconPositions;
}

// Triangulation
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

  final double x = (C * E - F * B) / (E * A - B * D);
  final double y = (C * D - A * F) / (B * D - A * E);

  return [x, y];
}

// Fonction Dijkstra pour le chemin le plus court dans la grille
List<List<int>> dijkstra(Grid grid, List<int> start, List<int> goal) {
  // Initialiser les distances avec une valeur très élevée
  final List<List<int>> distances =
      List.generate(grid.n, (_) => List.generate(grid.m, (_) => 1000000));

  // 'cameFrom' stocke la provenance de chaque nœud pour reconstruire le chemin à la fin
  final List<List<int>> cameFrom =
      List.generate(grid.n, (_) => List.generate(grid.m, (_) => -1));

  // Distance pour le point de départ
  distances[start[0]][start[1]] =
      0; // La distance du point de départ à lui-même est 0
  print(
      "Distance initiale du point de départ (${start[0]}, ${start[1]}): ${distances[start[0]][start[1]]}");

  // Liste des nœuds à explorer (la "file d'attente")
  List<Node> queue = [];
  queue
      .add(Node(start[0], start[1], 0)); // Ajoute le point de départ à la queue
  print("Point de départ ajouté à la queue : ${start}");

  // Directions possibles pour se déplacer : haut, bas, gauche, droite
  final directions = [
    [-1, 0], // haut
    [1, 0], // bas
    [0, -1], // gauche
    [0, 1] // droite
  ];

  // Tant qu'il y a des nœuds à explorer dans la queue
  while (queue.isNotEmpty) {
    print("Queue actuelle : $queue");
    print("Nombre de nœuds dans la queue : ${queue.length}");

    // Trier la liste pour obtenir le nœud avec la distance minimale
    queue.sort((a, b) =>
        a.distance.compareTo(b.distance)); // Trie la queue par distance
    final Node current = queue
        .removeAt(0); // Récupérer et retirer le premier nœud (le plus proche)

    // Afficher la position du nœud actuel
    print(
        "Nœud actuel : (${current.x}, ${current.y}) avec distance : ${current.distance}");

    // Vérifie si on a atteint l'objectif
    if (current.x == goal[0] && current.y == goal[1]) {
      print("Atteint l'objectif : (${current.x}, ${current.y})");
      print("Chemin reconstruit depuis : $cameFrom");
      return reconstructPath(
          cameFrom, start, goal); // Reconstruire et retourner le chemin
    }

    // Explorer les voisins (nœuds adjacents)
    for (List<int> d in directions) {
      final int nx = current.x + d[0]; // Nouvelle position x
      final int ny = current.y + d[1]; // Nouvelle position y

      // Vérifie si la case est valide (dans les limites de la grille)
      if (grid.isValid(nx, ny)) {
        final int newDist = current.distance +
            1; // Coût pour se déplacer d'une case (tous les déplacements coûtent 1)

        // Si la nouvelle distance est meilleure, met à jour
        if (newDist < distances[nx][ny]) {
          distances[nx][ny] = newDist; // Met à jour la distance minimale connue
          queue.add(Node(nx, ny,
              newDist)); // Ajouter le voisin à la liste des nœuds à explorer
          cameFrom[nx][ny] = current.x * grid.m +
              current.y; // Stocke l'origine pour la reconstruction du chemin
          print(
              "Mise à jour : nouvelle distance pour (${nx}, ${ny}) : $newDist");
          print("Ajout de (${nx}, ${ny}) à la queue");
        } else {
          print(
              "Aucune mise à jour : distance existante pour (${nx}, ${ny}) : ${distances[nx][ny]}, nouvelle distance : $newDist");
        }
      } else {
        print("Position (${nx}, ${ny}) est invalide, ignorée.");
      }
    }
  }

  print("Aucun chemin trouvé vers l'objectif (${goal[0]}, ${goal[1]})");
  return []; // Retourne une liste vide si aucun chemin n'a été trouvé
}

// Fonction pour reconstruire le chemin
List<List<int>> reconstructPath(
    List<List<int>> cameFrom, List<int> start, List<int> goal) {
  List<List<int>> path = [];
  int x = goal[0], y = goal[1];

  // Reconstruire le chemin en remontant jusqu'au point de départ
  while (x != start[0] || y != start[1]) {
    path.add([x, y]);
    final int prev = cameFrom[x][y];
    x = prev ~/ cameFrom[0].length;
    y = prev % cameFrom[0].length;
  }

  path.add([start[0], start[1]]); // Ajouter le point de départ
  return path.reversed
      .toList(); // Inverser le chemin pour avoir l'ordre correct
}

// Fonction pour charger les distances depuis le fichier JSON
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

Future<List<List<int>>?> findTargetPosition() async {
  String jsonFilePath = '../../assets/plan.json';
  String jsonDistanceFlie = '../../assets/beacon.json';
  Grid grid = await loadGridFromJson(jsonFilePath);

  // Récupérer les positions des beacons
  List<List<int>> beaconPositions = await getBeaconPositions(jsonFilePath);

  //Récupération des distance
  await loadDistances(jsonDistanceFlie);

  if (beaconPositions.length >= 3) {
    List<double> targetPosition = await triangulateData(
      beaconPositions[0],
      distance1,
      beaconPositions[1],
      distance2,
      beaconPositions[2],
      distance3,
    );
    List<int> target = [targetPosition[0].round(), targetPosition[1].round()];
    List<int> start = beaconPositions[0];

    print(
        "distance1 : $distance1 , distance2 : $distance2 , distance3: $distance3"); // Ex : démarrer à partir du premier beacon
    print("beaconPositions : $beaconPositions");
    print("target : $target");
    print("start : $start");

    List<List<int>> path = dijkstra(grid, start, target);
    print("Chemin le plus court : $path");
    return path;
  } else {
    print("Pas assez de beacons pour la triangulation.");
    return null; // Retourne null si pas assez de beacons
  }
}

void main() async {
  // Assurez-vous que le binding est initialisé avant d'exécuter du code Flutter.
  WidgetsFlutterBinding.ensureInitialized();

  // Vous pouvez ensuite appeler votre fonction ici.
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

  // Optionnel : Démarrez votre application Flutter ici
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
