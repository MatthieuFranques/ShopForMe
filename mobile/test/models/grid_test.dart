import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/models/grid.dart';

void main() {
  group('Grid Model Tests', () {
    // Créer une instance de Grid avec des valeurs spécifiques pour les tests
    late Grid grid;

    setUp(() {
      // Initialisation de la grille avec 5 lignes, 5 colonnes, des positions de balises vides et une position produit
      grid = Grid(
        5, // rows
        5, // cols
        [
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0]
        ], // grid
        [
          [1, 1],
          [3, 3],
          [4, 4]
        ], // beaconPositions (for future use, not used in isValid)
        [2, 2], // productPosition (for future use, not used in isValid)
      );
    });

    test('Grid should be initialized with correct dimensions', () {
      expect(grid.rows, 5);
      expect(grid.cols, 5);
    });

    // Test de la méthode isValid pour une position valide
    test('isValid should return true for valid position inside the grid', () {
      expect(grid.isValid(0, 0), true);
      expect(grid.isValid(4, 4), true);
      expect(grid.isValid(2, 2), true);
    });

    // Test de la méthode isValid pour une position invalide
    test('isValid should return false for invalid position outside the grid',
        () {
      expect(grid.isValid(-1, 0), false); // Position en dehors de la grille
      expect(grid.isValid(0, -1), false); // Position en dehors de la grille
      expect(grid.isValid(5, 5), false); // Position en dehors de la grille
      expect(grid.isValid(6, 0), false); // Position en dehors de la grille
      expect(grid.isValid(0, 6), false); // Position en dehors de la grille
    });

    // Test d'une position à la frontière (valide)
    test('isValid should return true for boundary positions', () {
      expect(grid.isValid(0, 4), true); // Bord supérieur droit
      expect(grid.isValid(4, 0), true); // Bord inférieur gauche
      expect(grid.isValid(4, 3), true); // Bord inférieur droit
      expect(grid.isValid(3, 4), true); // Bord supérieur gauche
    });
  });
}
