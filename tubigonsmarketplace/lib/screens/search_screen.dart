import 'package:flutter/material.dart';

import '../models/marketplace_item.dart';
import '../widgets/marketplace_item_card.dart';
import '../widgets/empty_view.dart';

class SearchScreen extends StatefulWidget {
  final List<MarketplaceItem> items;
  final bool Function(MarketplaceItem) onAddToCart;

  const SearchScreen({
    super.key,
    required this.items,
    required this.onAddToCart,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchText = '';
  String selectedType = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredItems = widget.items.where((item) {
      final query = searchText.toLowerCase();

      final matchesText = item.title.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query);

      final matchesType =
          selectedType == 'All' || item.listingType == selectedType;

      return matchesText && matchesType;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search for items',
                prefixIcon:
                    Icon(Icons.search_rounded, color: Color(0xFF1F8F5F)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<String>(
              initialValue: selectedType,
              decoration: const InputDecoration(
                labelText: 'Listing type',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'All',
                  child: Text('All'),
                ),
                DropdownMenuItem(
                  value: 'Buy',
                  child: Text('Buy'),
                ),
                DropdownMenuItem(
                  value: 'Rent',
                  child: Text('Rent'),
                ),
                DropdownMenuItem(
                  value: 'Trade',
                  child: Text('Trade'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedType = value;
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filteredItems.isEmpty
                ? const EmptyView(
                    message: 'No matching items found.',
                  )
                : ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      return MarketplaceItemCard(
                        item: filteredItems[index],
                        onAddToCart: widget.onAddToCart,
                        showAddToCart: true,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
