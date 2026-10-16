import 'package:flutter/material.dart';

import '../models/marketplace_item.dart';
import '../widgets/marketplace_item_card.dart';
import '../widgets/sign_up_dialog.dart';

class HomeScreen extends StatelessWidget {
  final List<MarketplaceItem> items;
  final bool isLoading;
  final String? errorMessage;
  final Future<void> Function() onRetry;
  final bool Function(MarketplaceItem) onAddToCart;
  final VoidCallback onOpenProfile;
  final bool hasProfileNotification;
  final bool isSignedUp;
  final SignUpCallback onSignUp;

  const HomeScreen({
    super.key,
    required this.items,
    required this.isLoading,
    required this.errorMessage,
    required this.onRetry,
    required this.onAddToCart,
    required this.onOpenProfile,
    required this.hasProfileNotification,
    required this.isSignedUp,
    required this.onSignUp,
  });

  static final List<MarketplaceItem> _sampleItems = [
    MarketplaceItem(
      id: -1,
      title: 'Wooden coffee table',
      description: 'Solid wooden coffee table in excellent condition.',
      price: 1800,
      category: 'Furniture',
      imageUrl:
          'https://images.unsplash.com/photo-1499933374294-4584851497cc?auto=format&fit=crop&w=700&q=80',
      listingType: 'Buy',
      location: 'Tubigon, Bohol',
    ),
    MarketplaceItem(
      id: -2,
      title: 'Wireless headphones',
      description: 'Comfortable wireless headphones with a charging cable.',
      price: 950,
      category: 'Electronics',
      imageUrl:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=700&q=80',
      listingType: 'Buy',
      location: 'Tubigon, Bohol',
    ),
    MarketplaceItem(
      id: -3,
      title: 'Everyday backpack',
      description: 'Spacious backpack in good condition.',
      price: 650,
      category: 'Clothing',
      imageUrl:
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&w=700&q=80',
      listingType: 'Buy',
      location: 'Tubigon, Bohol',
    ),
    MarketplaceItem(
      id: -4,
      title: 'Study desk',
      description: 'Compact desk with a clean, simple finish.',
      price: 2200,
      category: 'Furniture',
      imageUrl:
          'https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?auto=format&fit=crop&w=700&q=80',
      listingType: 'Buy',
      location: 'Tubigon, Bohol',
    ),
    MarketplaceItem(
      id: -5,
      title: 'Classic wristwatch',
      description: 'A classic everyday watch in working condition.',
      price: 1200,
      category: 'Other',
      imageUrl:
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=700&q=80',
      listingType: 'Buy',
      location: 'Tubigon, Bohol',
    ),
    MarketplaceItem(
      id: -6,
      title: 'Folding table and chairs',
      description: 'A sturdy table set for family gatherings and events.',
      price: 350,
      category: 'Furniture',
      imageUrl:
          'https://images.unsplash.com/photo-1519710164239-da123dc03ef4?auto=format&fit=crop&w=700&q=80',
      listingType: 'Rent',
      location: 'Tubigon, Bohol',
    ),
    MarketplaceItem(
      id: -7,
      title: 'Portable karaoke speaker',
      description: 'Portable speaker available for daily rental.',
      price: 500,
      category: 'Electronics',
      imageUrl:
          'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?auto=format&fit=crop&w=700&q=80',
      listingType: 'Rent',
      location: 'Tubigon, Bohol',
    ),
    MarketplaceItem(
      id: -8,
      title: 'Projector for movie night',
      description: 'Bright projector for presentations and movie nights.',
      price: 700,
      category: 'Electronics',
      imageUrl:
          'https://images.unsplash.com/photo-1478720568477-152d9b164e26?auto=format&fit=crop&w=700&q=80',
      listingType: 'Rent',
      location: 'Tubigon, Bohol',
    ),
    MarketplaceItem(
      id: -9,
      title: 'Camping tent',
      description: 'Roomy tent for a weekend outdoors.',
      price: 400,
      category: 'Other',
      imageUrl:
          'https://images.unsplash.com/photo-1478131143081-80f7f84ca84d?auto=format&fit=crop&w=700&q=80',
      listingType: 'Rent',
      location: 'Tubigon, Bohol',
    ),
    MarketplaceItem(
      id: -10,
      title: 'Digital camera',
      description: 'Digital camera and basic accessories for rent.',
      price: 900,
      category: 'Electronics',
      imageUrl:
          'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&w=700&q=80',
      listingType: 'Rent',
      location: 'Tubigon, Bohol',
    ),
    MarketplaceItem(
      id: -11,
      title: 'Mountain bike',
      description: 'Well-kept mountain bike. Open to reasonable swaps.',
      price: 0,
      category: 'Other',
      imageUrl:
          'https://images.unsplash.com/photo-1485965120184-e220f721d03e?auto=format&fit=crop&w=700&q=80',
      listingType: 'Trade',
      location: 'Tubigon, Bohol',
      itemsToTrade: 'A small appliance',
    ),
    MarketplaceItem(
      id: -12,
      title: 'Rice cooker',
      description: 'Working rice cooker, available for a household swap.',
      price: 0,
      category: 'Electronics',
      imageUrl:
          'https://images.unsplash.com/photo-1585515320310-259814833e62?auto=format&fit=crop&w=700&q=80',
      listingType: 'Trade',
      location: 'Tubigon, Bohol',
      itemsToTrade: 'An electric fan',
    ),
    MarketplaceItem(
      id: -13,
      title: 'Acoustic guitar',
      description: 'A well cared for guitar, open to musical gear trades.',
      price: 0,
      category: 'Other',
      imageUrl:
          'https://images.unsplash.com/photo-1510915361894-db8b60106cb1?auto=format&fit=crop&w=700&q=80',
      listingType: 'Trade',
      location: 'Tubigon, Bohol',
      itemsToTrade: 'A keyboard or audio equipment',
    ),
    MarketplaceItem(
      id: -14,
      title: 'Desk chair',
      description: 'Comfortable desk chair in good working condition.',
      price: 0,
      category: 'Furniture',
      imageUrl:
          'https://images.unsplash.com/photo-1505797149-43b0069ec26b?auto=format&fit=crop&w=700&q=80',
      listingType: 'Trade',
      location: 'Tubigon, Bohol',
      itemsToTrade: 'A small bookcase',
    ),
    MarketplaceItem(
      id: -15,
      title: 'Skateboard',
      description: 'Used skateboard with plenty of life left.',
      price: 0,
      category: 'Other',
      imageUrl:
          'https://images.unsplash.com/photo-1520045892732-304bc3ac5d8e?auto=format&fit=crop&w=700&q=80',
      listingType: 'Trade',
      location: 'Tubigon, Bohol',
      itemsToTrade: 'A basketball or sports gear',
    ),
  ];

  void showAbout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Tubigon Marketplace'),
        content: const Text(
          'Tubigon Marketplace is a community marketplace for Tubigon, '
          'Bohol. Discover items for sale, find things to rent, or trade '
          'directly with people in the local community.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void showSignUp(BuildContext context) {
    if (!isSignedUp) {
      showSignUpDialog(context, onSignUp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final saleItems = _itemsFor('Buy');
    final rentItems = _itemsFor('Rent');
    final tradeItems = _itemsFor('Trade');

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/tubigon logo.jpg',
                width: 36,
                height: 36,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tubigon Marketplace System',
                  maxLines: 1,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
        actions: [
          if (!isSignedUp)
            FilledButton(
              onPressed: () => showSignUp(context),
              style: FilledButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                minimumSize: const Size(0, 36),
              ),
              child: const Text('Sign up'),
            ),
          IconButton(
            onPressed: onOpenProfile,
            icon: Badge(
              isLabelVisible: hasProfileNotification,
              smallSize: 10,
              backgroundColor: const Color(0xFFD92D20),
              child: const Icon(Icons.account_circle_outlined),
            ),
            tooltip: 'Profile',
          ),
          PopupMenuButton<_HomeMenuAction>(
            tooltip: 'More options',
            onSelected: (action) {
              switch (action) {
                case _HomeMenuAction.refresh:
                  onRetry();
                  break;
                case _HomeMenuAction.about:
                  showAbout(context);
                  break;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _HomeMenuAction.refresh,
                child: ListTile(
                  leading: Icon(Icons.refresh_rounded),
                  title: Text('Refresh listings'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: _HomeMenuAction.about,
                child: ListTile(
                  leading: Icon(Icons.info_outline_rounded),
                  title: Text('About'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: onRetry,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const _HomeHero(),
            if (isLoading)
              const LinearProgressIndicator(
                minHeight: 2,
                backgroundColor: Color(0xFFE8F1EB),
              ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Material(
                  color: const Color(0xFFFFF4E5),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.wifi_off_rounded,
                          size: 20,
                          color: Color(0xFF8A5A16),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '$errorMessage Showing sample listings where '
                            'available.',
                            style: const TextStyle(
                              color: Color(0xFF704A19),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            _ListingSection(
              title: 'For sale',
              emptyMessage: isLoading
                  ? 'Loading listings…'
                  : 'No items for sale yet.',
              items: saleItems,
              onAddToCart: onAddToCart,
            ),
            _ListingSection(
              title: 'For rent',
              emptyMessage: 'No rental items yet.',
              items: rentItems,
              onAddToCart: onAddToCart,
            ),
            _ListingSection(
              title: 'For trade',
              emptyMessage: 'No trade items yet.',
              items: tradeItems,
              onAddToCart: onAddToCart,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  List<MarketplaceItem> _itemsFor(String listingType) {
    final listedItems = items
        .where((item) => item.listingType == listingType)
        .take(5)
        .toList();
    final remainingSlots = 5 - listedItems.length;
    final demoItems = _sampleItems
        .where((item) => item.listingType == listingType)
        .take(remainingSlots);
    return [...listedItems, ...demoItems];
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 184,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: const Color(0xFF15583C),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF174C36).withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/background/tubigonPlaza.jpg',
            fit: BoxFit.cover,
            alignment: const Alignment(0, 0.48),
            errorBuilder: (context, error, stackTrace) => const ColoredBox(
              color: Color(0xFF15583C),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xE6105037),
                  Color(0xB51C714B),
                  Color(0x6B174B37),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Find it in Tubigon',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Buy, rent, and trade with your local community.',
                  style: TextStyle(
                    color: Color(0xFFE9F4EC),
                    fontSize: 14,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 13),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFFD5EFDC),
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Tubigon, Bohol',
                      style: TextStyle(
                        color: Color(0xFFD5EFDC),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ListingSection extends StatelessWidget {
  final String title;
  final String emptyMessage;
  final List<MarketplaceItem> items;
  final bool Function(MarketplaceItem) onAddToCart;

  const _ListingSection({
    required this.title,
    required this.emptyMessage,
    required this.items,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF183D2E),
                  fontSize: 19,
                  letterSpacing: -0.2,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
            child: Text(
              emptyMessage,
              style: const TextStyle(color: Color(0xFF718579)),
            ),
          )
        else
          SizedBox(
            height: 220,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) => SizedBox(
                width: 320,
                child: MarketplaceItemCard(
                  item: items[index],
                  onAddToCart: onAddToCart,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

enum _HomeMenuAction { refresh, about }
