import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/models/node.dart'; // Assurez-vous que le chemin du fichier est correct

void main() {
  group('Node Model Tests', () {
    late Node node1;
    late Node node2;
    late Node node3;

    setUp(() {
      // Initialisation des nodes avec des valeurs spécifiques pour les tests
      node1 = Node(0, 0, 10); // Node avec distance 10
      node2 = Node(1, 1, 20); // Node avec distance 20
      node3 = Node(2, 2, 10); // Node avec distance 10
    });

    // Test de l'initialisation des propriétés
    test('Node should initialize with correct values', () {
      expect(node1.x, 0);
      expect(node1.y, 0);
      expect(node1.distance, 10);
      expect(node2.x, 1);
      expect(node2.y, 1);
      expect(node2.distance, 20);
      expect(node3.x, 2);
      expect(node3.y, 2);
      expect(node3.distance, 10);
    });

    // Test de la méthode compareTo pour comparer deux nodes
    test(
        'compareTo should return a negative value if current node has less distance',
        () {
      expect(node1.compareTo(node2),
          lessThan(0)); // node1 a une distance plus petite que node2
    });

    test(
        'compareTo should return a positive value if current node has greater distance',
        () {
      expect(node2.compareTo(node1),
          greaterThan(0)); // node2 a une distance plus grande que node1
    });

    test('compareTo should return 0 if two nodes have the same distance', () {
      expect(node1.compareTo(node3),
          equals(0)); // node1 et node3 ont la même distance
    });

    // Test de la comparaison avec une instance de Node avec une autre distance
    test('compareTo should correctly compare nodes based on distance', () {
      expect(node1.compareTo(node2),
          lessThan(0)); // node1 a une distance inférieure à node2
      expect(node2.compareTo(node3),
          greaterThan(0)); // node2 a une distance supérieure à node3
    });
  });
}
