import 'package:flutter/material.dart';

import '../models/marketplace_item.dart';
import '../widgets/marketplace_item_card.dart';

class ProfileScreen extends StatefulWidget {
  final List<MarketplaceItem> myItems;
  final ValueChanged<int> onDeleteItem;
  final List<MarketplaceItem> cartItems;
  final ValueChanged<int> onRemoveCartItem;
  final String accountName;

  const ProfileScreen({
    super.key,
    required this.myItems,
    required this.onDeleteItem,
    required this.cartItems,
    required this.onRemoveCartItem,
    required this.accountName,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> confirmDelete(MarketplaceItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete listing?'),
          content: Text('Are you sure you want to delete "${item.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      widget.onDeleteItem(item.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listing deleted.')),
      );
    }
  }

  Future<void> confirmRemoveFromCart(MarketplaceItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Remove from cart?'),
          content: Text('Remove "${item.title}" from your cart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      widget.onRemoveCartItem(item.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item removed from cart.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 16),
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1F8F5F), Color(0xFF3AA772)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    color: Color(0xFF1F8F5F),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to Tubigon! ${widget.accountName}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Tubigon, Bohol',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                const Text(
                  'My Cart',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF123A2B),
                  ),
                ),
                const Spacer(),
                Text(
                  '${widget.cartItems.length} items · ₱${widget.cartItems.fold<double>(0, (total, item) => total + item.price).toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(0xFF1F8F5F),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (widget.cartItems.isEmpty)
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Text(
                'Your cart is empty.',
                style: TextStyle(color: Color(0xFF5A7B6B)),
              ),
            )
          else
            ...widget.cartItems.map(
              (item) => MarketplaceItemCard(
                item: item,
                onRemoveFromCart: () => confirmRemoveFromCart(item),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                const Text(
                  'My Listings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF123A2B),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF6EE),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${widget.myItems.length} items',
                    style: const TextStyle(
                      color: Color(0xFF1F8F5F),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.myItems.isEmpty)
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Text(
                'You have not posted any items.',
                style: TextStyle(color: Color(0xFF5A7B6B)),
              ),
            )
          else
            ...widget.myItems.map(
              (item) => MarketplaceItemCard(
                item: item,
                onDelete: () => confirmDelete(item),
              ),
            ),
        ],
      ),
    );
  }
}
