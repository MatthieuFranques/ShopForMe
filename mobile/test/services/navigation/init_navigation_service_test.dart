import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/models/grid.dart';
import 'package:mobile/services/navigation/init_navigation_service.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });
  final InitNavigationService initNavigationService = InitNavigationService();
  test('loadGridFromJson should correctly parse JSON and create a Grid',
      () async {
    const jsonFilePath = 'assets/demo/plan28_11_24.json';

    final Grid grid = await initNavigationService.loadGridFromJson(jsonFilePath);
    print("grid.rows = ${grid.rows}");
    print("grid.cols = ${grid.cols}");
    print("grid.beaconPositions = ${grid.beaconPositions}");

    expect(grid.rows, 20);
    expect(grid.cols, 23);
    expect(grid.beaconPositions, [
      [3, 0],
      [23, 1],
      [23, 26]
    ]);
    expect(grid.productPosition, [20, 4]);
  });
}
