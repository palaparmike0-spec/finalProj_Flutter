import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'models/marketplace_item.dart';
import 'services/api_service.dart';

import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/post_item_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/profile_screen.dart';

import 'widgets/marketplace_bottom_nav.dart';

void main() {
  runApp(const TubigonMarketplaceApp());
}

class TubigonMarketplaceApp extends StatelessWidget {
  const TubigonMarketplaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tubigon Marketplace System',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16, height: 1.45),
          bodyMedium: TextStyle(fontSize: 14, height: 1.4),
          bodySmall: TextStyle(fontSize: 12, height: 1.35),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.25,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F9F6),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1F8F5F),
          brightness: Brightness.light,
          primary: const Color(0xFF1F8F5F),
          secondary: const Color(0xFF8BCF9E),
          surface: Colors.white,
          onSurface: const Color(0xFF123A2B),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF123A2B),
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Color(0xFF123A2B),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.25,
          ),
        ),
        cardTheme: CardThemeData(
          margin: EdgeInsets.zero,
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFDDEDE3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFDDEDE3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF1F8F5F), width: 1.6),
          ),
          labelStyle: const TextStyle(color: Color(0xFF45675F)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1F8F5F),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
      ),
      home: const MarketplaceMainPage(),
    );
  }
}

class MarketplaceMainPage extends StatefulWidget {
  const MarketplaceMainPage({super.key});

  @override
  State<MarketplaceMainPage> createState() => _MarketplaceMainPageState();
}

class _MarketplaceMainPageState extends State<MarketplaceMainPage> {
  int selectedIndex = 0;
  String? accountName;
  Uint8List? profileImageBytes;
  bool hasNewListingNotification = false;

  final ApiService apiService = ApiService();

  List<MarketplaceItem> apiItems = [];
  List<MarketplaceItem> myItems = [];
  List<MarketplaceItem> cartItems = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final items = await apiService.fetchItems();

      if (!mounted) return;

      setState(() {
        apiItems = items;
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        errorMessage =
            'Unable to load products. Check your internet connection.';
        isLoading = false;
      });
    }
  }

  void addItem(MarketplaceItem item) {
    setState(() {
      myItems.insert(0, item);
      hasNewListingNotification = true;
    });
  }

  void openProfile() {
    setState(() {
      selectedIndex = 4;
      hasNewListingNotification = false;
    });
  }

  void deleteItem(int id) {
    setState(() {
      myItems.removeWhere((item) => item.id == id);
    });
  }

  bool addToCart(MarketplaceItem item) {
    if (cartItems.any((cartItem) => cartItem.id == item.id)) return false;

    setState(() {
      cartItems.insert(0, item);
    });
    return true;
  }

  void removeFromCart(int id) {
    setState(() {
      cartItems.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final allItems = [...myItems, ...apiItems];

    final screens = [
      HomeScreen(
        items: allItems,
        isLoading: isLoading,
        errorMessage: errorMessage,
        onRetry: loadItems,
        onAddToCart: addToCart,
        hasProfileNotification: hasNewListingNotification,
        isSignedUp: accountName != null,
        onOpenProfile: openProfile,
        onSignUp: (name, imageBytes) {
          setState(() {
            accountName = name;
            profileImageBytes = imageBytes;
          });
        },
      ),
      SearchScreen(
        items: allItems,
        onAddToCart: addToCart,
      ),
      PostItemScreen(
        onAddItem: addItem,
      ),
      const MessagesScreen(),
      ProfileScreen(
        myItems: myItems,
        onDeleteItem: deleteItem,
        cartItems: cartItems,
        onRemoveCartItem: removeFromCart,
        accountName: accountName,
        profileImageBytes: profileImageBytes,
        isSignedUp: accountName != null,
        onSignUp: (name, imageBytes) {
          setState(() {
            accountName = name;
            profileImageBytes = imageBytes;
          });
        },
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: MarketplaceBottomNav(
        currentIndex: selectedIndex,
        hasProfileNotification: hasNewListingNotification,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
            if (index == 4) {
              hasNewListingNotification = false;
            }
          });
        },
      ),
    );
  }
}
