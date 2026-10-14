import 'dart:typed_data';

class MarketplaceItem {
  final int id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final Uint8List? imageBytes;
  final String listingType;
  final String location;
  final String? itemsToTrade;

  MarketplaceItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.imageBytes,
    required this.listingType,
    required this.location,
    this.itemsToTrade,
  });

  factory MarketplaceItem.fromJson(Map<String, dynamic> json) {
    final images = json['images'];
    final firstImage = images is List && images.isNotEmpty
        ? images.first
        : null;
    final imageUrl = json['thumbnail'] ?? firstImage ?? json['imageUrl'];

    return MarketplaceItem(
      id: json['id'] as int,
      title: json['title'] ?? 'Untitled Item',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      category: json['category'] ?? 'Other',
      imageUrl: imageUrl is String ? imageUrl : '',
      listingType: 'Buy',
      location: 'Tubigon, Bohol',
    );
  }
}
