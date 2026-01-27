class LiveStationAddOn {
  final String id;
  final String name;
  final String description;
  final double price; // Estimated per head or bulk price, used for calculation or display
  final String imageUrl;

  const LiveStationAddOn({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
      };

  factory LiveStationAddOn.fromJson(Map<String, dynamic> json) {
    return LiveStationAddOn(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
