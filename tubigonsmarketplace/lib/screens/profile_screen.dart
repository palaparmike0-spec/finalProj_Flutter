import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/marketplace_item.dart';
import '../widgets/marketplace_item_card.dart';
import '../widgets/sign_up_dialog.dart';

class ProfileScreen extends StatefulWidget {
  final List<MarketplaceItem> myItems;
  final ValueChanged<int> onDeleteItem;
  final List<MarketplaceItem> cartItems;
  final ValueChanged<int> onRemoveCartItem;
  final String? accountName;
  final Uint8List? profileImageBytes;
  final bool isSignedUp;
  final SignUpCallback onSignUp;

  const ProfileScreen({
    super.key,
    required this.myItems,
    required this.onDeleteItem,
    required this.cartItems,
    required this.onRemoveCartItem,
    required this.accountName,
    required this.profileImageBytes,
    required this.isSignedUp,
    required this.onSignUp,
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
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  backgroundImage: widget.profileImageBytes == null
                      ? null
                      : MemoryImage(widget.profileImageBytes!),
                  child: widget.profileImageBytes == null
                      ? const Icon(
                          Icons.person,
                          color: Color(0xFF1F8F5F),
                          size: 32,
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.isSignedUp)
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                            children: [
                              const TextSpan(text: 'Welcome to Tubigon! '),
                              TextSpan(
                                text: widget.accountName!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        const Text(
                          'Welcome to Tubigon!',
                          style: TextStyle(
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
                      if (!widget.isSignedUp) ...[
                        const SizedBox(height: 10),
                        FilledButton.tonalIcon(
                          onPressed: () =>
                              showSignUpDialog(context, widget.onSignUp),
                          style: FilledButton.styleFrom(
                            foregroundColor: const Color(0xFF15583C),
                            backgroundColor: Colors.white,
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          icon: const Icon(Icons.person_add_alt_1, size: 18),
                          label: const Text('Sign up'),
                        ),
                      ],
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
