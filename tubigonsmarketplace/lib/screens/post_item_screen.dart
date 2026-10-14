
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../models/marketplace_item.dart';

class PostItemScreen extends StatefulWidget {
  final ValueChanged<MarketplaceItem> onAddItem;

  const PostItemScreen({
    super.key,
    required this.onAddItem,
  });

  @override
  State<PostItemScreen> createState() => _PostItemScreenState();
}

class _PostItemScreenState extends State<PostItemScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final itemsToTradeController = TextEditingController();
  final imagePicker = ImagePicker();

  String category = 'Other';
  String listingType = 'Buy';
  Uint8List? imageBytes;

  Future<void> pickImage() async {
    try {
      final image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image == null) return;

      final bytes = await image.readAsBytes();
      if (!mounted) return;
      setState(() => imageBytes = bytes);
    } on PlatformException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not select image: ${error.message}')),
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    itemsToTradeController.dispose();
    super.dispose();
  }

  void submitItem() {
    if (!formKey.currentState!.validate()) return;

    final item = MarketplaceItem(
      id: DateTime.now().millisecondsSinceEpoch,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      price: listingType == 'Trade'
          ? 0
          : double.parse(priceController.text.trim()),
      category: category,
      imageUrl: '',
      imageBytes: imageBytes,
      listingType: listingType,
      location: 'Tubigon, Bohol',
      itemsToTrade: listingType == 'Trade'
          ? itemsToTradeController.text.trim()
          : null,
    );

    widget.onAddItem(item);

    titleController.clear();
    descriptionController.clear();
    priceController.clear();
    itemsToTradeController.clear();
    setState(() {
      imageBytes = null;
      category = 'Other';
      listingType = 'Buy';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item posted successfully!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post an Item'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF6EE),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.upload_outlined, color: Color(0xFF1F8F5F)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Share something useful with your community.',
                        style: TextStyle(
                          color: Color(0xFF123A2B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Item title',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter an item title.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a description.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Electronics',
                    child: Text('Electronics'),
                  ),
                  DropdownMenuItem(
                    value: 'Clothing',
                    child: Text('Clothing'),
                  ),
                  DropdownMenuItem(
                    value: 'Furniture',
                    child: Text('Furniture'),
                  ),
                  DropdownMenuItem(
                    value: 'School Supplies',
                    child: Text('School Supplies'),
                  ),
                  DropdownMenuItem(
                    value: 'Other',
                    child: Text('Other'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => category = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: listingType,
                decoration: const InputDecoration(
                  labelText: 'Listing type',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Buy',
                    child: Text('For Sale'),
                  ),
                  DropdownMenuItem(
                    value: 'Rent',
                    child: Text('For Rent'),
                  ),
                  DropdownMenuItem(
                    value: 'Trade',
                    child: Text('For Trade'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => listingType = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              if (listingType == 'Trade')
                TextFormField(
                  controller: itemsToTradeController,
                  decoration: const InputDecoration(
                    labelText: 'Item(s) to trade for',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter what you want in exchange.';
                    }
                    return null;
                  },
                )
              else
                TextFormField(
                  controller: priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: listingType == 'Rent'
                        ? 'Rental fee (PHP)'
                        : 'Price (PHP)',
                  ),
                  validator: (value) {
                    final price = double.tryParse(value?.trim() ?? '');

                    if (price == null || price < 0) {
                      return 'Enter a valid non-negative amount.';
                    }

                    return null;
                  },
                ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.add_photo_alternate_outlined),
                label: Text(
                  imageBytes == null ? 'Choose image (optional)' : 'Change image',
                ),
              ),
              if (imageBytes != null) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.memory(
                    imageBytes!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => setState(() => imageBytes = null),
                    icon: const Icon(Icons.close_rounded),
                    label: const Text('Remove photo'),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: submitItem,
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: const Text('Publish Listing'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
