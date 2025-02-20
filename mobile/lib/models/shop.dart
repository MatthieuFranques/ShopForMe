class Shop {
  final String id;
  final String name;
  final String city;
  final String address;
  final List<List<int>> plan;

  Shop({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.plan,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      address: json['address'],
      plan: List<List<int>>.from(
        json['plan'].map((x) => List<int>.from(x)),
      ),
    );
  }
}
