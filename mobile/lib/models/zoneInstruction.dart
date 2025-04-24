import "package:mobile/services/navigation/compass_service.dart";

class ZoneInstruction {
  final List<List<int>> zone;
  final ArrowDirection direction;
  final List<int> center;

  ZoneInstruction({
    required this.zone,
    required this.direction,
    required this.center,
  });

  @override
  String toString() {
    return 'Zone(center: $center, direction: $direction, zone size: ${zone.length}, zone: $zone)';
  }

  List getZoneRange() {
    return [
      zone[0],
      [zone[0][0] + 2, zone[0][1] + 2]
    ];
  }

  bool isInRange(List<int> position) {
    final int firstY = zone[0][0];
    final int firstX = zone[0][1];
    final int lastY = firstY + 2;
    final int lastX = firstX + 2;
    final int y = position[0];
    final int x = position[1];
    return (firstX <= x && x <= lastX && firstY <= y && y <= lastY);
  }
}

List<ZoneInstruction> getDirectionalZones(List<List<int>> path) {
  final List<ZoneInstruction> instructions = [];

  ArrowDirection? lastDirection;

  for (int i = 1; i < path.length - 1; i++) {
    final List<int> prev = path[i - 1];
    final List<int> curr = path[i];
    final List<int> next = path[i + 1];

    final int dLine1 = curr[0] - prev[0];
    final int dCol1 = curr[1] - prev[1];
    final int dLine2 = next[0] - curr[0];
    final int dCol2 = next[1] - curr[1];

    if (dLine1 != dLine2 || dCol1 != dCol2) {
      ArrowDirection direction;
      if (dLine2 == 1) {
        direction = ArrowDirection.sud;
      } else if (dLine2 == -1) {
        direction = ArrowDirection.nord;
      } else if (dCol2 == 1) {
        direction = ArrowDirection.est;
      } else {
        direction = ArrowDirection.ouest;
      }

      final List<List<int>> zone = [];
      for (int x = curr[0] - 1; x <= curr[0] + 1; x++) {
        for (int y = curr[1] - 1; y <= curr[1] + 1; y++) {
          zone.add([x, y]);
        }
      }

      instructions
          .add(ZoneInstruction(zone: zone, direction: direction, center: curr));
      lastDirection = direction; // Store the last known direction
    }
  }

  // Handle last position
  if (path.length >= 2) {
    final last = path[path.length - 1];

    // Fallback direction if no corner detected earlier
    lastDirection ??= () {
      final beforeLast = path[path.length - 2];
      final dLine = last[0] - beforeLast[0];
      final dCol = last[1] - beforeLast[1];
      if (dLine == 1) return ArrowDirection.sud;
      if (dLine == -1) return ArrowDirection.nord;
      if (dCol == 1) return ArrowDirection.est;
      return ArrowDirection.ouest;
    }();

    final List<List<int>> finalZone = [];
    for (int x = last[0] - 1; x <= last[0] + 1; x++) {
      for (int y = last[1] - 1; y <= last[1] + 1; y++) {
        finalZone.add([x, y]);
      }
    }

    instructions.add(ZoneInstruction(
        zone: finalZone, direction: ArrowDirection.nord, center: last));
  }

  return instructions;
}

void printGrid({
  required List<List<int>> path,
  required List<ZoneInstruction> zones,
  int width = 20,
  int height = 20,
}) {
  for (int line = 0; line < height; line++) {
    String row = '';
    for (int col = 0; col < width; col++) {
      if (zones
          .any((zone) => zone.center[0] == line && zone.center[1] == col)) {
        final ZoneInstruction z = zones.firstWhere(
            (zone) => zone.center[0] == line && zone.center[1] == col);
        row += directionArrow(z.direction);
      } else if (zones.any((zone) =>
          zone.zone.any((point) => point[0] == line && point[1] == col))) {
        row += '#';
      } else if (path.any((point) => point[0] == line && point[1] == col)) {
        row += '*';
      } else {
        row += '.';
      }
    }
    print(row);
  }
}

String directionArrow(ArrowDirection dir) {
  switch (dir) {
    case ArrowDirection.nord:
      return '↑';
    case ArrowDirection.sud:
      return '↓';
    case ArrowDirection.ouest:
      return '←';
    case ArrowDirection.est:
      return '→';
    case ArrowDirection.finish:
      return '*';
  }
}
