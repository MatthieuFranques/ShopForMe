import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_compass/flutter_compass.dart';

/// Service for managing the compass and calculating orientation
class CompassService {
  /// Stream controller for compass events
  final _compassController = StreamController<double>.broadcast();
  
  /// Stream used to track compass orientation in degrees
  Stream<double> get compassStream => _compassController.stream;
  
  /// Current orientation in degrees (0-360)
  double _currentDirection = 0.0;
  
  /// Current orientation in degrees (0-360)
  double get currentDirection => _currentDirection;
  
  /// Unique instance of the service (Singleton)
  static final CompassService _instance = CompassService._internal();
  
  /// Factory constructor for the Singleton implementation
  factory CompassService() => _instance;
  
  /// Private constructor for the Singleton implementation
  CompassService._internal() {
    _initCompass();
  }
  
  /// Initialize listening to compass events
  void _initCompass() {
    FlutterCompass.events?.listen((CompassEvent event) {
      if (event.heading != null) {
        _currentDirection = event.heading!;
        _compassController.add(_currentDirection);
      }
    });
  }
  
  /// Calculates the angle between the current direction and the target
  /// @param targetAngle Target angle in degrees (0-360)
  /// @returns Adjusted angle in degrees (0-360)
  double getAdjustedDirection(double targetAngle) {
    return (targetAngle - _currentDirection + 360) % 360;
  }
  
  /// Calculates the angle towards a target position
  /// @param currentLat Current latitude
  /// @param currentLng Current longitude
  /// @param targetLat Target latitude
  /// @param targetLng Target longitude
  /// @returns Angle in degrees towards the target (0-360)
  double calculateTargetAngle(
    double currentLat, 
    double currentLng, 
    double targetLat, 
    double targetLng
  ) {
    final double deltaLat = targetLat - currentLat;
    final double deltaLng = targetLng - currentLng;
    final double angle = math.atan2(deltaLng, deltaLat) * (180 / math.pi);
    
    return (angle + 360) % 360;
  }
  
  /// Calculates the angle towards a target position on the grid
  /// @param currentPosition Current position [x, y]
  /// @param targetPosition Target position [x, y]
  /// @returns Angle in degrees towards the target (0-360)
  double calculateTargetAngleFromGrid(
    List<int> currentPosition, 
    List<int> targetPosition
  ) {
    final double deltaY = (targetPosition[0] - currentPosition[0]).toDouble();
    final double deltaX = (targetPosition[1] - currentPosition[1]).toDouble();
    final double angle = math.atan2(deltaX, deltaY) * (180 / math.pi);
    
    return (angle + 360) % 360;
  }
  
  /// Converts an ArrowDirection to degrees
  /// @param direction Direction as an enumeration
  /// @returns Corresponding angle in degrees
  double arrowDirectionToDegrees(ArrowDirection direction) {
    switch (direction) {
      case ArrowDirection.nord: return 0;
      case ArrowDirection.est: return 90;
      case ArrowDirection.sud: return 180;
      case ArrowDirection.ouest: return 270;
    }
  }
  
  /// Releases resources
  void dispose() {
    _compassController.close();
  }
}

/// Enumeration for cardinal directions
enum ArrowDirection { nord, sud, est, ouest }