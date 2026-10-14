import 'package:flutter/material.dart';

import '../models/marketplace_item.dart';
import '../screens/item_detail_screen.dart';

class MarketplaceItemCard extends StatelessWidget {
  final MarketplaceItem item;
  final VoidCallback? onDelete;
  final VoidCallback? onRemoveFromCart;
  final bool Function(MarketplaceItem)? onAddToCart;
  final bool showAddToCart;

  const MarketplaceItemCard({
    super.key,
    required this.item,
    this.onDelete,
    this.onRemoveFromCart,
    this.onAddToCart,
    this.showAddToCart = false,
  });

  void _openDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ItemDetailScreen(
          item: item,
          onAddToCart: onAddToCart,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3F0E7), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1F8F5F).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 104,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    width: 104,
                    height: 92,
                    child: _buildItemImage(),
                  ),
                ),
                if (showAddToCart && onAddToCart != null)
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: TextButton.icon(
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
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      icon: const Icon(Icons.add_shopping_cart, size: 15),
                      label: const Text('Add to cart'),
                    ),
                  ),
                TextButton(
                  onPressed: () => _openDetails(context),
                  style: TextButton.styleFrom(
                    minimumSize: const Size(0, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('View'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF123A2B),
                        ),
                      ),
                    ),
                    if (onDelete != null || onRemoveFromCart != null)
                      IconButton(
                        onPressed: onRemoveFromCart ?? onDelete,
                        icon: const Icon(Icons.delete_outline, size: 18),
                        tooltip: onRemoveFromCart != null
                            ? 'Remove from cart'
                            : 'Delete listing',
                        color: const Color(0xFF1F8F5F),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF5A7B6B),
                    fontSize: 12,
                  ),
                ),
                if (item.listingType != 'Trade') ...[
                  const SizedBox(height: 8),
                  Text(
                    '₱${item.price.toStringAsFixed(2)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: const TextStyle(
                      color: Color(0xFF1F8F5F),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemImage() {
    if (item.imageBytes != null) {
      return Image.memory(
        item.imageBytes!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
      );
    }

    if (item.imageUrl.isEmpty) return _imagePlaceholder();

    return Image.network(
      item.imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        final expectedBytes = loadingProgress.expectedTotalBytes;
        return Container(
          color: const Color(0xFFEAF6EE),
          alignment: Alignment.center,
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: expectedBytes == null
                  ? null
                  : loadingProgress.cumulativeBytesLoaded / expectedBytes,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: const Color(0xFFEAF6EE),
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_not_supported_outlined,
        size: 36,
        color: Color(0xFF1F8F5F),
      ),
    );
  }
}
