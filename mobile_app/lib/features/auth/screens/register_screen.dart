import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/providers/user_profile_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _authService = AuthService();

  String _selectedRole = 'artisan'; // 'artisan' or 'buyer'
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _errorMessage;
  String _selectedCraft = '';

  final List<Map<String, dynamic>> _craftTypes = [
    {'icon': '🧵', 'label': 'Textiles'},
    {'icon': '🏺', 'label': 'Pottery'},
    {'icon': '🪵', 'label': 'Woodcraft'},
    {'icon': '💎', 'label': 'Jewellery'},
    {'icon': '🎨', 'label': 'Paintings'},
    {'icon': '🧶', 'label': 'Weaving'},
    {'icon': '🪨', 'label': 'Stone Art'},
    {'icon': '🪷', 'label': 'Other'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _businessNameController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; _errorMessage = null; });

    await _authService.registerWithEmail(
      email: _emailController.text,
      password: _passwordController.text,
      displayName: _nameController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (_selectedRole == 'artisan') {
      await context.read<UserProfileProvider>().saveNewArtisanProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        craftType: _selectedCraft.isNotEmpty ? _selectedCraft : 'Traditional Art',
      );
      if (mounted) {
        context.go('/home');
      }
    } else {
      await context.read<UserProfileProvider>().saveNewBuyerProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        businessName: _businessNameController.text.trim().isNotEmpty
            ? _businessNameController.text.trim()
            : 'Procurement Partner',
        businessType: 'B2B Retail & Wholesale',
      );
      if (mounted) {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // ── Back Button ───────────────────────────────
              GestureDetector(
                onTap: () => context.go('/login'),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Icon(Icons.arrow_back_ios_new, size: 16, color: AppColors.textPrimary),
                ),
              ),

              const SizedBox(height: 20),

              // ── Header ────────────────────────────────────
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: AppColors.surfaceContainerLowest,
                        boxShadow: [
                          BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 6)),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Join the Artisan Community',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Create your digital storefront',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'अपनी डिजिटल दुकान बनाएं',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),

              const SizedBox(height: 28),

              // ── Error Message ─────────────────────────────
              if (_errorMessage != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: AppColors.error, size: 20),
                      const SizedBox(width: 10),
                      Expanded(child: Text(_errorMessage!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.error))),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ── Register Form ─────────────────────────────
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Role Selector Tabs (Artisan vs Buyer)
                    _buildLabel('I am joining as · माझी भूमिका'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedRole = 'artisan'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: _selectedRole == 'artisan'
                                      ? AppColors.surfaceContainerLowest
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: _selectedRole == 'artisan'
                                      ? [BoxShadow(color: AppColors.cardShadow, blurRadius: 4)]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    '👩‍🎨 Artisan (कारागीर)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: _selectedRole == 'artisan'
                                          ? AppColors.primary
                                          : AppColors.textLight,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedRole = 'buyer'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: _selectedRole == 'buyer'
                                      ? AppColors.surfaceContainerLowest
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: _selectedRole == 'buyer'
                                      ? [BoxShadow(color: AppColors.cardShadow, blurRadius: 4)]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    '🏢 B2B Buyer (खरेदीदार)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: _selectedRole == 'buyer'
                                          ? AppColors.primary
                                          : AppColors.textLight,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    if (_selectedRole == 'buyer') ...[
                      _buildLabel('Company / Business Name · फर्मचे नाव'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _businessNameController,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: 'e.g., Heritage Crafts Boutique Mumbai',
                          prefixIcon: Icon(Icons.business_outlined, color: AppColors.textLight, size: 20),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter business name' : null,
                      ),
                      const SizedBox(height: 18),
                    ],

                    // Full Name
                    _buildLabel('Full Name · पूरा नाम'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: 'e.g., Om Gaikwad',
                        prefixIcon: Icon(Icons.person_outline, color: AppColors.textLight, size: 20),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
                    ),

                    const SizedBox(height: 18),

                    // Email
                    _buildLabel('Email'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: 'artisan@example.com',
                        prefixIcon: Icon(Icons.email_outlined, color: AppColors.textLight, size: 20),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Please enter your email';
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    // Password
                    _buildLabel('Password · पासवर्ड'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: 'Minimum 6 characters',
                        prefixIcon: Icon(Icons.lock_outline, color: AppColors.textLight, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textLight, size: 20),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Please enter a password';
                        if (v.length < 6) return 'Password must be at least 6 characters';
                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    // Confirm Password
                    _buildLabel('Confirm Password'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirm,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: 'Re-enter password',
                        prefixIcon: Icon(Icons.lock_outline, color: AppColors.textLight, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textLight, size: 20),
                          onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Please confirm your password';
                        if (v != _passwordController.text) return 'Passwords do not match';
                        return null;
                      },
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 500.ms).slideY(begin: 0.15, end: 0),

              const SizedBox(height: 24),

              // ── Craft Type Selector (Artisans only) ────────────────────────
              if (_selectedRole == 'artisan') ...[
                Text(
                  'Your Craft Specialty · आपकी कला',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _craftTypes.map((craft) {
                    final isSelected = _selectedCraft == craft['label'];
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCraft = craft['label'] as String),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.divider,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 3))] : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(craft['icon'] as String, style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 6),
                            Text(
                              craft['label'] as String,
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ).animate().fadeIn(delay: 500.ms, duration: 500.ms),
              ],

              const SizedBox(height: 28),

              // ── Register Button ───────────────────────────
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                      : Text('Create Account', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ).animate().fadeIn(delay: 600.ms, duration: 500.ms),

              const SizedBox(height: 20),

              // ── Divider ───────────────────────────────────
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.divider)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('or', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textLight)),
                  ),
                  Expanded(child: Divider(color: AppColors.divider)),
                ],
              ),

              const SizedBox(height: 20),

              // ── Google Sign Up ────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Google Sign-Up coming soon!')),
                    );
                  },
                  icon: Text('G', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.secondary)),
                  label: Text('Sign up with Google', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.textPrimary)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.outline),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ).animate().fadeIn(delay: 700.ms, duration: 500.ms),

              const SizedBox(height: 24),

              // ── Login Link ────────────────────────────────
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/login'),
                      child: Text(
                        'Sign In',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 800.ms, duration: 500.ms),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.textSecondary),
    );
  }
}
