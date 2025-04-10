import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:mobile/models/grid.dart';
import 'package:permission_handler/permission_handler.dart';

class InitNavigationService {
  /// Converts a JSON store plan into a [Grid] object. The plan is stored at [jsonFilePath].
  ///
  /// This function reads the store plan from a JSON file located at [jsonFilePath], decodes it, and creates a grid
  /// based on the data. It initializes the grid with default values and identifies the beacon positions in the store.
  ///
  /// ### Parameters:
  /// - `jsonFilePath`: A string representing the file path to the JSON plan.
  ///
  /// ### Returns:
  /// A [Future] that resolves to a [Grid] object representing the store grid with beacon positions and product location.
  ///
  /// ### Example:
  /// ```dart
  /// Grid grid = await loadGridFromJson('assets/store_plan.json');
  /// print(grid); // Prints the grid object.
  /// ```
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
    beaconPositions.add([3, 0]);
    beaconPositions.add([23, 1]);
    beaconPositions.add([23, 26]);
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
      }
    }
    return Grid(numRows, numCols, grid, beaconPositions, productPosition);
  }

  /// Gets the current product position.
  ///
  /// Currently, this function returns a fixed position for the product (in the future, it will return positions of all
  /// products in the shopping list). TODO
  ///
  /// ### Returns:
  /// A [Future] that resolves to a list of integers representing the product's position in the grid.
  ///
  /// ### Example:
  /// ```dart
  /// List<int> productPosition = await getProductPosition();
  /// print(productPosition); // Prints the product position [17, 12].
  /// ```
  Future<List<int>> getProductPosition() async {
    final List<int> productPositions = [3, 8];
    return productPositions;
  }

  /// Checks if the necessary permissions for Bluetooth scanning, connection, and location are granted.
  ///
  /// This function requests the required permissions for Bluetooth scanning, Bluetooth connection, and location access.
  /// If any of the permissions are not granted, it throws an exception.
  ///
  /// ### Throws:
  /// - `Exception`: If any of the required permissions are not granted.
  ///
  /// ### Example:
  /// ```dart
  /// await checkPermissions(); // Ensures the required permissions are granted.
  /// ```
  Future<void> checkPermissions() async {
    if (!await Permission.bluetoothScan.request().isGranted ||
        !await Permission.bluetoothConnect.request().isGranted ||
        !await Permission.locationWhenInUse.request().isGranted) {
      throw Exception("Permissions not granted.");
    }
  }
}
