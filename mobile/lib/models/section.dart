import 'package:hive/hive.dart';

part 'section.g.dart';

@HiveType(typeId: 3)
class Section extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  Section({
    required this.id,
    required this.name,
  });


  factory Section.fromJson(Map<String, dynamic> json) {
    try {
      return Section(
        id: json['id']?.toString() ?? 'unknown',
        name: json['name']?.toString() ?? 'Unnamed Section',
      );
    } catch (e) {
      print('❌ Error creating Section from JSON: $e');
      print('❌ Problematic JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name
  };

  @override
  String toString() {
    return 'Section(id: $id, name: $name)';
  }
}