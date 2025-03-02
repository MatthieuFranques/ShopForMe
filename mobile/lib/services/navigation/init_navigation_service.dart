import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:mobile/models/grid.dart';
import 'package:permission_handler/permission_handler.dart';

class InitNavigationService {
  ///Converts the json plan to grid type. To know if the path is passable or not
  ///@param : String jsonFilePath : market plan
  ///Return Return the market plan in Grid
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
        beaconPositions.add([16, 3]);
        beaconPositions.add([2, 12]);
        beaconPositions.add([16, 17]);
      }
    }
    return Grid(numRows, numCols, grid, beaconPositions, productPosition);
  }

  Future<List<int>> getProductPosition() async {
    // TODO
    final List<int> productPositions = [17, 12];
    return productPositions;
  }

  Future<void> checkPermissions() async {
    if (!await Permission.bluetoothScan.request().isGranted ||
        !await Permission.bluetoothConnect.request().isGranted ||
        !await Permission.locationWhenInUse.request().isGranted) {
      throw Exception("Permissions not granted.");
    }
  }
}
