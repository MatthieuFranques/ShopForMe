import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'dart:collection';

class LocationService {
  final String apiKey;

  LocationService(this.apiKey);

  static const esp1 = {
    "id": "ESP01",
    "layout": [1, 3]
  };

  static const esp2 = {
    "id": "ESP02",
    "layout": [15, 25]
  };

  static const esp3 = {
    "id": "ESP03",
    "layout": [7, 36]
  };

  static const product_test = {
    "name": "Brocolie",
    "layout": [7, 36]
  };
  // TODO Test : Qui renvoie bien la bonne position
  //
  // Fonction pour trianguler les données
  Future<List<double>> triangulateData(Map<String, dynamic> esp1,
      Map<String, dynamic> esp2, Map<String, dynamic> esp3) async {
    // Positions  ESP
    final double x1 = esp1['layout'][0];
    final double y1 = esp1['layout'][1];
    final double x2 = esp2['layout'][0];
    final double y2 = esp2['layout'][1];
    final double x3 = esp3['layout'][0];
    final double y3 = esp3['layout'][1];

    // Range ESP
    final double r1 = esp1['distance'];
    final double r2 = esp2['distance'];
    final double r3 = esp3['distance'];

    // Calculate the coefficients for the linear equations
    final double A =
        2 * x2 - 2 * x1; // Difference in x-coordinates between ESP2 and ESP1
    final double B =
        2 * y2 - 2 * y1; // Difference in y-coordinates between ESP2 and ESP1
    final double C = r1 * r1 -
        r2 * r2 -
        x1 * x1 +
        x2 * x2 -
        y1 * y1 +
        y2 * y2; // Combination of distances and coordinates for ESP1 and ESP2

    final double D =
        2 * x3 - 2 * x2; // Difference in x-coordinates between ESP3 and ESP2
    final double E =
        2 * y3 - 2 * y2; // Difference in y-coordinates between ESP3 and ESP2
    final double F = r2 * r2 -
        r3 * r3 -
        x2 * x2 +
        x3 * x3 -
        y2 * y2 +
        y3 * y3; // Combination of distances and coordinates for ESP2 and ESP3

// Solve the linear equations to find the x-coordinate of the target position
    final double x = (C * E - F * B) / (E * A - B * D);

// Solve the linear equations to find the y-coordinate of the target position
    final double y = (C * D - A * F) / (B * D - A * E);

    return [x, y];
  }
}

// Mouvement possible dans les 4 directions: Haut, Bas, Gauche, Droite
final List<List<int>> directions = [
  [0, 1], // Droite
  [1, 0], // Bas
  [0, -1], // Gauche
  [-1, 0], // Haut
];
