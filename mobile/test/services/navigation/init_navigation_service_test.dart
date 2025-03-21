import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/models/grid.dart';
import 'dart:convert';
import 'package:mobile/services/navigation/init_navigation_service.dart';
import 'package:mockito/mockito.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });
  final InitNavigationService initNavigationService = InitNavigationService();
  test('loadGridFromJson should correctly parse JSON and create a Grid',
      () async {
    final jsonFilePath = 'assets/demo/plan28_11_24.json';

    Grid grid = await initNavigationService.loadGridFromJson(jsonFilePath);
    print("grid.rows = ${grid.rows}");
    print("grid.cols = ${grid.cols}");
    print("grid.beaconPositions = ${grid.beaconPositions}");

    expect(grid.rows, 20);
    expect(grid.cols, 23);
    expect(grid.beaconPositions, [
      [16, 3],
      [2, 12],
      [16, 17]
    ]);
    expect(grid.productPosition, [17, 12]);
  });
}
