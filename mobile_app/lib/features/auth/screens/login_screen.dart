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
        _emailController.text = 'artisan@shilpsetu.in';
        _passwordController.text = 'artisan123';
      } else if (role == 'buyer') {
        _emailController.text = 'buyer@fabindia.com';
        _passwordController.text = 'buyer123';
      } else if (role == 'admin') {
        _emailController.text = 'admin@shilpsetu.in';
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

    try {
      // Attempt Firebase sign-in with 2-second timeout so it never hangs
      await _authService
          .signInWithEmail(enteredEmail, enteredPassword)
          .timeout(const Duration(seconds: 2), onTimeout: () {
            debugPrint('Firebase sign-in timed out; proceeding with local profile.');
            return (user: null, error: null);
          });
    } catch (e) {
      debugPrint('Firebase sign-in skipped: $e');
    }

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
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset > 0 ? bottomInset + 16 : 24),
              child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── TOP SECTION: Header & Branding ────────────
                      Column(
                        children: [
                          const SizedBox(height: 8),

                          // National Initiative Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('🇮🇳', style: TextStyle(fontSize: 13)),
                                const SizedBox(width: 6),
                                Text(
                                  'GOVT. OF INDIA • VOCAL FOR LOCAL',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryDark,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 400.ms),

                          const SizedBox(height: 16),

                          // Logo / Brand Icon
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.surfaceContainerLowest,
                              border: Border.all(color: _roleAccentColor.withValues(alpha: 0.25), width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: _roleAccentColor.withValues(alpha: 0.18),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => Icon(
                                    Icons.storefront_rounded,
                                    color: _roleAccentColor,
                                    size: 34,
                                  ),
                                ),
                              ),
                            ),
                          ).animate().scale(duration: 450.ms, curve: Curves.easeOutBack),

                          const SizedBox(height: 14),

                          // App Title & Dynamic Portal Subtitle
                          Text(
                            'ShilpSetu',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 26,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: Text(
                              _selectedRole == 'buyer'
                                  ? 'B2B Wholesale Procurement Portal'
                                  : _selectedRole == 'admin'
                                      ? 'Marketplace Operations & Governance'
                                      : 'कारागीर प्रवेश • Craft Cataloging & Digital Mela',
                              key: ValueKey(_selectedRole),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: _roleAccentColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Role Selector Tab Segment
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.outlineVariant),
                            ),
                            child: Row(
                              children: [
                                _buildRoleTab('artisan', 'Artisan', Icons.palette_outlined, AppColors.primary),
                                _buildRoleTab('buyer', 'B2B Buyer', Icons.storefront_outlined, AppColors.secondary),
                                _buildRoleTab('admin', 'Admin', Icons.admin_panel_settings_outlined, AppColors.primaryDark),
                              ],
                            ),
                          ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ── MIDDLE SECTION: Main Login Form Card ───────
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: AppColors.outlineVariant, width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.textPrimary.withValues(alpha: 0.04),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Error Alert (if any)
                              if (_errorMessage != null) ...[
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 14),
                                  decoration: BoxDecoration(
                                    color: AppColors.errorContainer,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.error_outline, color: AppColors.error, size: 18),
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
                              ],

                              // Email / Phone Field Label
                              Text(
                                _selectedRole == 'buyer'
                                    ? 'Procurement Email'
                                    : _selectedRole == 'admin'
                                        ? 'Administrator Email'
                                        : 'Artisan Email / मोबाईल क्रमांक',
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  hintText: _selectedRole == 'buyer'
                                      ? 'buyer@fabindia.com'
                                      : _selectedRole == 'admin'
                                          ? 'admin@shilpsetu.in'
                                          : 'artisan@shilpsetu.in',
                                  filled: true,
                                  fillColor: AppColors.background,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  prefixIcon: Icon(Icons.mail_outline_rounded, color: _roleAccentColor, size: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(color: AppColors.outline),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(color: AppColors.outline),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(color: _roleAccentColor, width: 1.8),
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) return 'Please enter your email or mobile';
                                  if (!v.contains('@') && v.trim().length < 10) return 'Enter a valid email or 10-digit mobile';
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),

                              // Password Field Label & Input
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Password / पासवर्ड',
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _showForgotPasswordDialog(),
                                    child: Text(
                                      'Forgot?',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: _roleAccentColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _handleLogin(),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                decoration: InputDecoration(
                                  hintText: '••••••••',
                                  filled: true,
                                  fillColor: AppColors.background,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  prefixIcon: Icon(Icons.lock_outline_rounded, color: _roleAccentColor, size: 20),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                      color: AppColors.textLight,
                                      size: 20,
                                    ),
                                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(color: AppColors.outline),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(color: AppColors.outline),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(color: _roleAccentColor, width: 1.8),
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Please enter your password';
                                  if (v.length < 5) return 'Password must be at least 5 characters';
                                  return null;
                                },
                              ),

                              const SizedBox(height: 14),

                              // Quick Demo Fill Chips
                              Row(
                                children: [
                                  Text(
                                    'Quick Fill:',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textLight,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildQuickFillChip('Artisan', 'artisan'),
                                  const SizedBox(width: 6),
                                  _buildQuickFillChip('Buyer', 'buyer'),
                                  const SizedBox(width: 6),
                                  _buildQuickFillChip('Admin', 'admin'),
                                ],
                              ),

                              const SizedBox(height: 18),

                              // Primary Sign In Button
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _roleAccentColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    elevation: 2,
                                    shadowColor: _roleAccentColor.withValues(alpha: 0.3),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                        )
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Sign In as ${_selectedRole == 'artisan' ? 'Artisan' : _selectedRole == 'buyer' ? 'B2B Buyer' : 'Administrator'}',
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.2,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Icon(Icons.arrow_forward_rounded, size: 18),
                                          ],
                                        ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Mobile OTP Login Option (for rural artisans)
                              if (_selectedRole == 'artisan') ...[
                                SizedBox(
                                  width: double.infinity,
                                  height: 44,
                                  child: OutlinedButton.icon(
                                    onPressed: () => _showOtpLoginSheet(),
                                    icon: Icon(Icons.phone_android_rounded, size: 18, color: _roleAccentColor),
                                    label: Text(
                                      'Sign In with Mobile OTP',
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                        color: _roleAccentColor,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: _roleAccentColor.withValues(alpha: 0.4)),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                              ],

                              // Register Link
                              if (_selectedRole != 'admin')
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Don't have an account? ",
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textLight),
                                        ),
                                        GestureDetector(
                                          onTap: () => context.go('/register'),
                                          child: Text(
                                            'Register as ${_selectedRole == 'buyer' ? 'Buyer' : 'Artisan'}',
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: _roleAccentColor,
                                              fontWeight: FontWeight.w800,
                                              decoration: TextDecoration.underline,
                                              decorationColor: _roleAccentColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                      const SizedBox(height: 20),

                      // ── BOTTOM SECTION: Govt. Trust & Security Footer ─
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shield_outlined, size: 14, color: AppColors.textLight),
                              const SizedBox(width: 6),
                              Text(
                                '256-Bit SSL Encrypted • ONDC & GeM Enabled',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textLight,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'National Handicrafts Development Programme (NHDP)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textLight.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ).animate().fadeIn(delay: 350.ms, duration: 400.ms),
                    ],
                  ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRoleTab(String role, String title, IconData icon, Color accent) {
    final isSelected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => _applyRoleDefaults(role),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 9),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? accent : AppColors.textLight,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? accent : AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickFillChip(String label, String role) {
    final isCurrent = _selectedRole == role;
    return GestureDetector(
      onTap: () => _applyRoleDefaults(role),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: isCurrent ? _roleAccentColor.withValues(alpha: 0.1) : AppColors.surfaceVariant.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isCurrent ? _roleAccentColor.withValues(alpha: 0.4) : AppColors.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
            color: isCurrent ? _roleAccentColor : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  void _showOtpLoginSheet() {
    final phoneController = TextEditingController(text: '9820123456');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.phone_android_rounded, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mobile OTP Sign In',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        'मोबाईल ओटीपी लॉगिन (कारागीर)',
                        style: TextStyle(fontSize: 12, color: AppColors.textLight),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 1),
                decoration: InputDecoration(
                  prefixText: '+91 ',
                  prefixStyle: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  labelText: '10-digit Mobile Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('OTP sent to +91 9820123456. Verifying demo account...'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                    _handleLogin();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Send & Verify OTP', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        );
      },
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
            Text('Enter your email or phone to receive a password reset link.', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            TextField(
              controller: resetController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Email or Mobile number'),
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
                  SnackBar(content: Text(err ?? 'Reset link sent! Check your inbox.')),
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
