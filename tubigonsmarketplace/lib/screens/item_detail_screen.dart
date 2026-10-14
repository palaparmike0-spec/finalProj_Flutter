import 'package:flutter/material.dart';

import '../models/marketplace_item.dart';

class ItemDetailScreen extends StatelessWidget {
  final MarketplaceItem item;
  final bool Function(MarketplaceItem)? onAddToCart;

  const ItemDetailScreen({
    super.key,
    required this.item,
    this.onAddToCart,
  });

  Widget _buildImage() {
    final bytes = item.imageBytes;
    if (bytes != null) {
      return Image.memory(
        bytes,
        height: 280,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
      );
    }

    if (item.imageUrl.isEmpty) return _imagePlaceholder();

    return Image.network(
      item.imageUrl,
      height: 280,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const SizedBox(
          height: 280,
          child: Center(child: CircularProgressIndicator()),
        );
      },
      errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 280,
      width: double.infinity,
      color: const Color(0xFFEAF6EE),
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_not_supported_outlined,
        size: 56,
        color: Color(0xFF1F8F5F),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTrade = item.listingType == 'Trade';

    return Scaffold(
      appBar: AppBar(title: const Text('Item details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF6EE),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${item.listingType} · ${item.category}',
                      style: const TextStyle(
                        color: Color(0xFF1F8F5F),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Color(0xFF123A2B),
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: Color(0xFF5A7B6B),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.location,
                          style: const TextStyle(
                            color: Color(0xFF5A7B6B),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!isTrade) ...[
                    const SizedBox(height: 16),
                    Text(
                      '₱${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF1F8F5F),
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                  if (isTrade && item.itemsToTrade?.isNotEmpty == true) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Item(s) wanted in trade',
                      style: TextStyle(
                        color: Color(0xFF123A2B),
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.itemsToTrade!,
                      style: const TextStyle(
                        color: Color(0xFF45675F),
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  const Text(
                    'Description',
                    style: TextStyle(
                      color: Color(0xFF123A2B),
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description,
                    style: const TextStyle(
                      color: Color(0xFF45675F),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  if (onAddToCart != null) ...[
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          final added = onAddToCart!(item);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                added
                                    ? 'Added to cart.'
                                    : 'This item is already in your cart.',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_shopping_cart_outlined),
                        label: const Text('Add to cart'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
