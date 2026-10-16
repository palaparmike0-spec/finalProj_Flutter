import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

typedef SignUpCallback = void Function(String name, Uint8List? profileImage);

Future<void> showSignUpDialog(
  BuildContext context,
  SignUpCallback onSignUp,
) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => _SignUpDialog(
      onSubmit: (name, profileImage) {
        onSignUp(name, profileImage);
        Navigator.of(dialogContext).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome to Tubigon, $name!')),
        );
      },
    ),
  );
}

class _SignUpDialog extends StatefulWidget {
  final SignUpCallback onSubmit;

  const _SignUpDialog({required this.onSubmit});

  @override
  State<_SignUpDialog> createState() => _SignUpDialogState();
}

class _SignUpDialogState extends State<_SignUpDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _imagePicker = ImagePicker();

  Uint8List? _profileImage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image == null) return;

      final bytes = await image.readAsBytes();
      if (!mounted) return;
      setState(() => _profileImage = bytes);
    } on PlatformException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not select photo: ${error.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create your account'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Create a local account to personalize your marketplace profile.',
                style: TextStyle(color: Color(0xFF64796D), height: 1.4),
              ),
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 34,
                backgroundColor: const Color(0xFFEAF6EE),
                backgroundImage: _profileImage == null
                    ? null
                    : MemoryImage(_profileImage!),
                child: _profileImage == null
                    ? const Icon(
                        Icons.person_outline_rounded,
                        size: 34,
                        color: Color(0xFF1F8F5F),
                      )
                    : null,
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _pickProfileImage,
                icon: const Icon(Icons.add_a_photo_outlined),
                label: Text(
                  _profileImage == null ? 'Upload profile photo' : 'Change photo',
                ),
              ),
              if (_profileImage != null)
                TextButton.icon(
                  onPressed: () => setState(() => _profileImage = null),
                  icon: const Icon(Icons.close_rounded),
                  label: const Text('Remove photo'),
                ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter your name.'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
                    return 'Enter a valid email.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) => value == null || value.length < 8
                    ? 'Use at least 8 characters.'
                    : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit(
                _nameController.text.trim(),
                _profileImage,
              );
            }
          },
          child: const Text('Sign up'),
        ),
      ],
    );
  }
}
