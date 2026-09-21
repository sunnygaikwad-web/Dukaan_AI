// lib/features/auth/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/providers/user_profile_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  // Selected login role: 'artisan', 'buyer', 'admin'
  String _selectedRole = 'artisan';

  @override
  void initState() {
    super.initState();
    _applyRoleDefaults('artisan');
  }

  void _applyRoleDefaults(String role) {
    setState(() {
      _selectedRole = role;
      _errorMessage = null;
      if (role == 'artisan') {
        _emailController.text = 'artisan@dukaan.app';
        _passwordController.text = 'artisan123';
      } else if (role == 'buyer') {
        _emailController.text = 'buyer@fabindia.com';
        _passwordController.text = 'buyer123';
      } else if (role == 'admin') {
        _emailController.text = 'admin@dukaan.app';
        _passwordController.text = 'admin123';
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final enteredEmail = _emailController.text.trim();
    final enteredPassword = _passwordController.text.trim();

    // Attempt Firebase sign-in first
    await _authService.signInWithEmail(enteredEmail, enteredPassword);

    if (!mounted) return;
    setState(() => _isLoading = false);

    final provider = context.read<UserProfileProvider>();

    if (_selectedRole == 'buyer') {
      final username = enteredEmail.split('@').first;
      final buyerName = username.isNotEmpty
          ? '${username[0].toUpperCase()}${username.substring(1)}'
          : 'Aarav Mehta';
      await provider.saveNewBuyerProfile(
        name: buyerName,
        email: enteredEmail,
        businessName: 'FabIndia Sourcing Mumbai',
        businessType: 'Handicraft & Textile Retailer',
      );
      await provider.switchRole('buyer');
    } else if (_selectedRole == 'admin') {
      await provider.switchRole('admin');
    } else {
      // Artisan
      final username = enteredEmail.split('@').first;
      final artisanName = username.isNotEmpty
          ? '${username[0].toUpperCase()}${username.substring(1)}'
          : 'Om Gaikwad';
      await provider.saveNewArtisanProfile(
        name: artisanName,
        email: enteredEmail,
        craftType: 'Traditional Paithani & Pottery',
      );
      await provider.switchRole('artisan');
    }

    if (mounted) {
      context.go('/home');
    }
  }

  Color get _roleAccentColor {
    switch (_selectedRole) {
      case 'buyer':
        return AppColors.secondary;
      case 'admin':
        return AppColors.primaryDark;
      default:
        return AppColors.primary;
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
              const SizedBox(height: 32),

              // ── Top Logo ──────────────────────────────────
              Center(
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: AppColors.surfaceContainerLowest,
                    boxShadow: [
                      BoxShadow(
                        color: _roleAccentColor.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
                  ),
                ),
              ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),

              const SizedBox(height: 24),

              // ── Header Text (Changes with Role) ───────────
              Center(
                child: Column(
                  children: [
                    Text(
                      _selectedRole == 'buyer'
                          ? 'B2B Buyer Portal'
                          : _selectedRole == 'admin'
                              ? 'Admin Command Center'
                              : 'Artisan Portal',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _selectedRole == 'buyer'
                          ? 'Wholesale Procurement & Direct Artisan Connect'
                          : _selectedRole == 'admin'
                              ? 'Platform Oversight & Live AI Engine Controls'
                              : 'कारागीर प्रवेश • Craft Cataloging & Digital Mela',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _roleAccentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 24),

              // ── Role Selector Tabs ────────────────────────
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: Row(
                  children: [
                    _buildRoleTab('artisan', '👩‍🎨 Artisan', AppColors.primary),
                    _buildRoleTab('buyer', '🏢 B2B Buyer', AppColors.secondary),
                    _buildRoleTab('admin', '🛡️ Admin', AppColors.primaryDark),
                  ],
                ),
              ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

              const SizedBox(height: 20),

              // ── Role Info Banner ──────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: _roleAccentColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _roleAccentColor.withValues(alpha: 0.25)),
                ),
                child: Row(
                  children: [
                    Icon(
                      _selectedRole == 'buyer'
                          ? Icons.storefront_outlined
                          : _selectedRole == 'admin'
                              ? Icons.admin_panel_settings_outlined
                              : Icons.palette_outlined,
                      color: _roleAccentColor,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _selectedRole == 'buyer'
                          ? 'Sign in to access wholesale catalog, MOQ pricing & bulk RFQs'
                          : _selectedRole == 'admin'
                              ? 'Sign in to monitor artisans, inspect live Gemini API & analytics'
                              : 'Sign in to access AI Studio, manage listings & join live Mela',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Error Message ─────────────────────────────
              if (_errorMessage != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: AppColors.error, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // ── Login Form ────────────────────────────────
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email
                    Text(
                      _selectedRole == 'buyer'
                          ? 'Procurement Email'
                          : _selectedRole == 'admin'
                              ? 'Admin Email'
                              : 'Artisan Email / मोबाईल',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: _selectedRole == 'buyer'
                            ? 'buyer@fabindia.com'
                            : _selectedRole == 'admin'
                                ? 'admin@dukaan.app'
                                : 'artisan@dukaan.app',
                        prefixIcon: Icon(Icons.email_outlined, color: _roleAccentColor, size: 20),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Please enter your email';
                        if (!v.contains('@')) return 'Enter a valid email address';
                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    // Password
                    Text(
                      'Password',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _handleLogin(),
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        prefixIcon: Icon(Icons.lock_outline, color: _roleAccentColor, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: AppColors.textLight,
                            size: 20,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Please enter your password';
                        if (v.length < 5) return 'Password must be at least 5 characters';
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    // Quick autofill chip
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ActionChip(
                        avatar: Icon(Icons.auto_fix_high, size: 14, color: _roleAccentColor),
                        label: Text(
                          'Autofill Demo ${_selectedRole[0].toUpperCase()}${_selectedRole.substring(1)} Login',
                          style: TextStyle(fontSize: 11, color: _roleAccentColor, fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: _roleAccentColor.withValues(alpha: 0.08),
                        side: BorderSide(color: _roleAccentColor.withValues(alpha: 0.3)),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        onPressed: () => _applyRoleDefaults(_selectedRole),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _showForgotPasswordDialog(),
                        child: Text(
                          'Forgot Password?',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: _roleAccentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 250.ms, duration: 400.ms),

              const SizedBox(height: 12),

              // ── Sign In Button ────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _roleAccentColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                      : Text(
                          'Sign In as ${_selectedRole == 'artisan' ? 'Artisan' : _selectedRole == 'buyer' ? 'B2B Buyer' : 'Admin'}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ).animate().fadeIn(delay: 350.ms, duration: 400.ms),

              const SizedBox(height: 28),

              // ── Register Link (For Artisans & Buyers) ──────
              if (_selectedRole != 'admin')
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/register'),
                        child: Text(
                          'Register as ${_selectedRole == 'buyer' ? 'Buyer' : 'Artisan'}',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: _roleAccentColor,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                            decorationColor: _roleAccentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 450.ms, duration: 400.ms),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleTab(String role, String title, Color accent) {
    final isSelected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => _applyRoleDefaults(role),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surfaceContainerLowest : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected ? Border.all(color: accent, width: 1.5) : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? accent : AppColors.textLight,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final resetController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Reset Password', style: Theme.of(context).textTheme.headlineSmall),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter your email to receive a password reset link.', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            TextField(
              controller: resetController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Email address'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: AppColors.textLight)),
          ),
          ElevatedButton(
            onPressed: () async {
              final err = await _authService.sendPasswordReset(resetController.text);
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(err ?? 'Reset link sent! Check your email.')),
                );
              }
            },
            child: const Text('Send Reset Link'),
          ),
        ],
      ),
    );
  }
}
