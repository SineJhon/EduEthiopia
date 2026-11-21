import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/localization/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/animated/animated_widgets.dart';
import '../../core/widgets/language_toggle.dart';
import '../../core/widgets/theme_toggle.dart';
import '../dashboard/dashboard_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({this.isAmharic = false, this.onLanguageChanged, super.key});

  final bool isAmharic;
  final ValueChanged<bool>? onLanguageChanged;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;
  bool _obscurePassword = true;
  late bool _isAmharic;
  String? _selectedUniversity;
  bool _submitting = false;

  static const universities = [
    'Addis Ababa University',
    'Addis Ababa Science and Technology University',
    'Adama Science and Technology University',
    'Arba Minch University',
    'Bahir Dar University',
    'Dilla University',
    'Dire Dawa University',
    'Haramaya University',
    'Hawassa University',
    'Jimma University',
    'Kotebe Metropolitan University',
    'Mekelle University',
    'Wollo University',
    'Wolkite University',
    'University of Gondar',
  ];

  late final AnimationController _modeController;
  late final Animation<double> _modeFade;

  @override
  void initState() {
    super.initState();
    _isAmharic = widget.isAmharic;
    _modeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _modeFade = CurvedAnimation(
      parent: _modeController,
      curve: Curves.easeInOut,
    );
    _modeController.forward();
  }

  @override
  void dispose() {
    _modeController.dispose();
    _emailController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleMode(bool isSignUp) {
    if (_isSignUp == isSignUp) return;
    _modeController.reverse().then((_) {
      setState(() {
        _isSignUp = isSignUp;
        _selectedUniversity = null;
      });
      _formKey.currentState?.reset();
      _modeController.forward();
    });
  }

  void _submit(AppStrings strings) {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _submitting = false);
      slideFadePushReplacement<void>(
        context,
        (_) => DashboardScreen(
          isAmharic: _isAmharic,
          onLanguageChanged: widget.onLanguageChanged,
          userName: _isSignUp
              ? _fullNameController.text.trim()
              : (_emailController.text.trim().split('@').first),
          university: _isSignUp ? _selectedUniversity : null,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(_isAmharic);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -30,
              right: -30,
              child:
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.gold.withValues(alpha: 0.10),
                    ),
                  ).animate().scale(
                    delay: 300.ms,
                    duration: 1500.ms,
                    curve: Curves.easeInOut,
                    begin: const Offset(0.85, 0.85),
                    end: Offset.zero,
                  ),
            ),
            Positioned(
              bottom: -20,
              left: -20,
              child:
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.green.withValues(alpha: 0.08),
                    ),
                  ).animate().scale(
                    delay: 500.ms,
                    duration: 1500.ms,
                    curve: Curves.easeInOut,
                    begin: const Offset(0.85, 0.85),
                    end: Offset.zero,
                  ),
            ),
            Positioned(
              top: 10,
              left: 8,
              child: IconButton(
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
            ),
            Positioned(
              top: 10,
              right: 16,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ThemeToggle(),
                  const SizedBox(width: 10),
                  LanguageToggle(
                    isAmharic: _isAmharic,
                    onChanged: (value) {
                      setState(() => _isAmharic = value);
                      widget.onLanguageChanged?.call(value);
                    },
                  ),
                ],
              ),
            ),
            Positioned.fill(
              top: 58,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 10, 24, 28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Reveal(
                            duration: 700,
                            delay: 100,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipOval(
                                  child: Image.asset(
                                    'assets/images/edu_ethiopia_logo.jpg',
                                    height: 44,
                                    width: 44,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Edu Ethiopia',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Reveal(
                            duration: 700,
                            delay: 250,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _isSignUp
                                      ? strings.signupTitle
                                      : strings.loginTitle,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontWeight: FontWeight.w900,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _isSignUp
                                      ? strings.signupSubtitle
                                      : strings.loginSubtitle,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                        height: 1.4,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Login / Signup toggle with crossfade
                          Reveal(
                            duration: 600,
                            delay: 400,
                            child: FadeTransition(
                              opacity: _modeFade,
                              child: SegmentedButton<bool>(
                                segments: [
                                  ButtonSegment<bool>(
                                    value: false,
                                    label: Text(strings.loginTab),
                                    icon: const Icon(
                                      Icons.login_rounded,
                                      size: 18,
                                    ),
                                  ),
                                  ButtonSegment<bool>(
                                    value: true,
                                    label: Text(strings.signupTab),
                                    icon: const Icon(
                                      Icons.person_add_rounded,
                                      size: 18,
                                    ),
                                  ),
                                ],
                                selected: {_isSignUp},
                                onSelectionChanged: (selection) =>
                                    _toggleMode(selection.first),
                                style: SegmentedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .surface,
                                  foregroundColor: Theme.of(context)
                                      .colorScheme
                                      .onSurface,
                                  selectedBackgroundColor: AppColors.green,
                                  selectedForegroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          // Form card
                          Reveal(
                            duration: 700,
                            delay: 500,
                            child: AnimatedCard(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: 22,
                              padding: const EdgeInsets.all(20),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    if (_isSignUp) ...[
                                      _buildTextField(
                                        controller: _fullNameController,
                                        label: strings.fullName,
                                        icon: Icons.person_outline_rounded,
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().length < 2) {
                                            return strings.invalidName;
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 14),
                                      _buildUniversityDropdown(strings),
                                      const SizedBox(height: 14),
                                    ],
                                    _buildTextField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      label: strings.email,
                                      icon: Icons.email_outlined,
                                      validator: (value) {
                                        if (value == null ||
                                            !value.contains('@')) {
                                          return strings.invalidEmail;
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 14),
                                    _buildTextField(
                                      controller: _passwordController,
                                      obscureText: _obscurePassword,
                                      textInputAction: _isSignUp
                                          ? TextInputAction.next
                                          : TextInputAction.done,
                                      onFieldSubmitted: (_) => _submit(strings),
                                      label: strings.password,
                                      icon: Icons.lock_outline_rounded,
                                      suffixIcon: IconButton(
                                        tooltip: _obscurePassword
                                            ? 'Show password'
                                            : 'Hide password',
                                        onPressed: () => setState(
                                          () => _obscurePassword =
                                              !_obscurePassword,
                                        ),
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.length < 8) {
                                          return strings.invalidPassword;
                                        }
                                        return null;
                                      },
                                    ),
                                    if (!_isSignUp) ...[
                                      const SizedBox(height: 12),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: MagneticTextButton(
                                          label: strings.forgotPassword,
                                          onPressed: () {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  strings.recoveryNotice,
                                                ),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor: AppColors.green
                                                    .withValues(alpha: 0.9),
                                              ),
                                            );
                                          },
                                          color: AppColors.burgundy,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 20),
                                    MagneticButton(
                                      onPressed: _submitting
                                          ? null
                                          : () => _submit(strings),
                                      backgroundColor: AppColors.green,
                                      foregroundColor: Colors.white,
                                      label: _submitting
                                          ? 'Just a moment...'
                                          : (_isSignUp
                                                ? strings.signupAction
                                                : strings.loginAction),
                                      height: 54,
                                      icon: const Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 20,
                                      ),
                                      duration: 500,
                                      delay: 50,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Reveal(
                            duration: 600,
                            delay: 900,
                            child: MagneticTextButton(
                              label: _isSignUp
                                  ? strings.loginTab
                                  : strings.signupTab,
                              onPressed: () => _toggleMode(!_isSignUp),
                              color: AppColors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    void Function(String)? onFieldSubmitted,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
        ),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }

  Widget _buildUniversityDropdown(AppStrings strings) {
    return DropdownButtonFormField<String>(
      key: ValueKey(_selectedUniversity),
      initialValue: _selectedUniversity,
      isExpanded: true,
      menuMaxHeight: 260,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      decoration: InputDecoration(
        labelText: strings.university,
        prefixIcon: Icon(
          Icons.account_balance_outlined,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
        ),
      ),
      hint: Text(strings.universityHint),
      items: universities
          .map(
            (university) => DropdownMenuItem(
              value: university,
              child: Text(
                university,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          )
          .toList(),
      onChanged: (value) => setState(() => _selectedUniversity = value),
      validator: (value) {
        if (value == null) return strings.invalidUniversity;
        return null;
      },
    );
  }
}
