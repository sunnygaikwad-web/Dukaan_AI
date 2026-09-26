// lib/features/auth/screens/profile_setup_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shilpsetu_ai/core/constants.dart';
import 'package:shilpsetu_ai/services/local_storage_service.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedCraft = AppConstants.craftTypes[0];
  String _selectedState = AppConstants.states[0];
  int _experience = 5;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate save
    await LocalStorageService().setArtisanName(_nameController.text.trim());
    await LocalStorageService().setArtisanId('artisan_001'); // Demo ID
    await LocalStorageService().setOnboardingDone(true);
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Profile'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Avatar placeholder
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                        ),
                        child: Icon(Icons.person,
                            size: 50, color: Theme.of(context).primaryColor),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _label('Your Name'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Savita Patil',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 20),
                _label('Village / City'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Paithan, Aurangabad',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Please enter your location' : null,
                ),
                const SizedBox(height: 20),
                _label('State'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedState,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.map_outlined),
                  ),
                  items: AppConstants.states
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedState = v!),
                ),
                const SizedBox(height: 20),
                _label('Type of Craft'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCraft,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.brush_outlined),
                  ),
                  items: AppConstants.craftTypes
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedCraft = v!),
                ),
                const SizedBox(height: 20),
                _label('Phone Number'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    hintText: '+91 98765 43210',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Please enter your phone number' : null,
                ),
                const SizedBox(height: 20),
                _label('Years of Experience: $_experience years'),
                Slider(
                  value: _experience.toDouble(),
                  min: 1,
                  max: 50,
                  divisions: 49,
                  label: '$_experience years',
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (v) => setState(() => _experience = v.round()),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  child: _isSaving
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text('Start My Digital Journey →'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
    );
  }
}
