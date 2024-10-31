class Product {
  final String id;
  final String name;
  final String category;
  final List<int> layout;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.layout,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? 'unknown', 
      name: json['name'] ?? 'Unnamed Product',   
      category: json['category'] ?? 'Misc',     
      layout: List<int>.from(json['layout'] ?? [0, 0]),
    );
  }
}
