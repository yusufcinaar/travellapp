import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../generated/l10n.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  // Giriş formu kontrolcüleri
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // Kayıt formu kontrolörleri
  final _registerFullNameController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _registerFullNameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF4285F4), // Google mavi rengi
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    const Icon(
                      Icons.flight,
                      size: 80,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 60),

                    // Tab Controller
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: false,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                          boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
                        ),
                        labelColor: const Color(0xFF4285F4),
                        unselectedLabelColor: Colors.white,
                        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        tabs: [
                          Tab(
                            text:
                                Provider.of<LocaleProvider>(
                                      context,
                                    ).locale.languageCode ==
                                    'de'
                                ? 'Anmelden'
                                : (Provider.of<LocaleProvider>(
                                            context,
                                          ).locale.languageCode ==
                                          'en'
                                      ? 'Login'
                                      : 'Giriş Yap'),
                          ),
                          Tab(
                            text:
                                Provider.of<LocaleProvider>(
                                      context,
                                    ).locale.languageCode ==
                                    'de'
                                ? 'Registrieren'
                                : (Provider.of<LocaleProvider>(
                                            context,
                                          ).locale.languageCode ==
                                          'en'
                                      ? 'Register'
                                      : 'Kayıt Ol'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Tab View
                    SizedBox(
                      height: 400,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Login Tab
                          _buildLoginForm(),

                          // Register Tab
                          _buildRegisterForm(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // App subtitle only
                    Text(
                      Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                          ? 'Planen und entdecken Sie Ihre Reisen einfach'
                          : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                              ? 'Plan and discover your travels easily'
                              : 'Seyahatlerini kolayca planla ve keşfet'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 100),

                    // Google ile Giriş Butonu
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: ElevatedButton.icon(
                            onPressed: authProvider.isLoading
                                ? null
                                : () => _signInWithGoogle(context),
                            icon: authProvider.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.grey,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    Icons.g_mobiledata,
                                    color: Colors.red,
                                    size: 24,
                                  ),
                            label: Text(
                              authProvider.isLoading
                                  ? (Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                                      ? 'Bitte warten...'
                                      : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                                          ? 'Please wait...'
                                          : 'Lütfen bekleyin...'))
                                  : (Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                                      ? 'Mit Google anmelden'
                                      : (Provider.of<LocaleProvider>(context).locale.languageCode == 'en'
                                          ? 'Sign in with Google'
                                          : 'Google ile Giriş Yap')),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black87,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              disabledBackgroundColor: Colors.white.withValues(
                                red: 255,
                                green: 255,
                                blue: 255,
                                alpha: 179,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // Hata Mesajı
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        if (authProvider.error != null) {
                          return Container(
                            margin: const EdgeInsets.only(top: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(
                                red: 255,
                                green: 255,
                                blue: 255,
                                alpha: 179,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.red.withValues(
                                  red: 255,
                                  green: 0,
                                  blue: 0,
                                  alpha: 77,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red[300],
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    authProvider.error!,
                                    style: TextStyle(color: Colors.red[300]),
                                  ),
                                ),
                                IconButton(
                                  onPressed: authProvider.clearError,
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.red[300],
                                  ),
                                  iconSize: 20,
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          red: 255,
          green: 255,
          blue: 255,
          alpha: 204,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 280,
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText:
                      Provider.of<LocaleProvider>(context).locale.languageCode ==
                          'de'
                      ? 'Ihre E-Mail-Adresse'
                      : (Provider.of<LocaleProvider>(
                                  context,
                                ).locale.languageCode ==
                                'en'
                            ? 'Your email address'
                            : 'E-posta adresiniz'),
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return Provider.of<LocaleProvider>(
                            context,
                            listen: false,
                          ).locale.languageCode ==
                          'de'
                      ? 'Bitte geben Sie Ihre E-Mail-Adresse ein'
                      : (Provider.of<LocaleProvider>(
                                  context,
                                  listen: false,
                                ).locale.languageCode ==
                                'en'
                            ? 'Please enter your email address'
                            : 'Lütfen e-posta adresinizi girin');
                }
                if (!value.contains('@') || !value.contains('.')) {
                  return Provider.of<LocaleProvider>(
                            context,
                            listen: false,
                          ).locale.languageCode ==
                          'de'
                      ? 'Bitte geben Sie eine gültige E-Mail-Adresse ein'
                      : (Provider.of<LocaleProvider>(
                                  context,
                                  listen: false,
                                ).locale.languageCode ==
                                'en'
                            ? 'Please enter a valid email address'
                            : 'Geçerli bir e-posta adresi girin');
                }
                return null;
              },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 280,
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText:
                      Provider.of<LocaleProvider>(context).locale.languageCode ==
                          'de'
                      ? 'Ihr Passwort'
                      : (Provider.of<LocaleProvider>(
                                  context,
                                ).locale.languageCode ==
                                'en'
                            ? 'Your password'
                            : 'Şifreniz'),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return Provider.of<LocaleProvider>(
                            context,
                            listen: false,
                          ).locale.languageCode ==
                          'de'
                      ? 'Bitte geben Sie Ihr Passwort ein'
                      : (Provider.of<LocaleProvider>(
                                  context,
                                  listen: false,
                                ).locale.languageCode ==
                                'en'
                            ? 'Please enter your password'
                            : 'Lütfen şifrenizi girin');
                }
                if (value.length < 6) {
                  return Provider.of<LocaleProvider>(
                            context,
                            listen: false,
                          ).locale.languageCode ==
                          'de'
                      ? 'Das Passwort muss mindestens 6 Zeichen lang sein'
                      : (Provider.of<LocaleProvider>(
                                  context,
                                  listen: false,
                                ).locale.languageCode ==
                                'en'
                            ? 'Password must be at least 6 characters'
                            : 'Şifre en az 6 karakter olmalıdır');
                }
                return null;
              },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 280,
              child: ElevatedButton(
                onPressed: _signInWithEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4285F4),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  Provider.of<LocaleProvider>(context).locale.languageCode == 'de'
                      ? 'Anmelden'
                      : (Provider.of<LocaleProvider>(
                                  context,
                                ).locale.languageCode ==
                                'en'
                            ? 'Login'
                            : 'Giriş Yap'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  width: 280,
                  child: TextFormField(
                    controller: _registerFullNameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText:
                        Provider.of<LocaleProvider>(
                              context,
                            ).locale.languageCode ==
                            'de'
                        ? 'Ihr vollständiger Name'
                        : (Provider.of<LocaleProvider>(
                                    context,
                                  ).locale.languageCode ==
                                  'en'
                              ? 'Your full name'
                              : 'Adınız ve soyadınız'),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Provider.of<LocaleProvider>(
                              context,
                              listen: false,
                            ).locale.languageCode ==
                            'de'
                        ? 'Bitte geben Sie Ihren vollständigen Namen ein'
                        : (Provider.of<LocaleProvider>(
                                    context,
                                    listen: false,
                                  ).locale.languageCode ==
                                  'en'
                              ? 'Please enter your full name'
                              : 'Lütfen adınızı ve soyadınızı girin');
                  }
                  if (value.length < 3) {
                    return Provider.of<LocaleProvider>(
                              context,
                              listen: false,
                            ).locale.languageCode ==
                            'de'
                        ? 'Der Name muss mindestens 3 Zeichen lang sein'
                        : (Provider.of<LocaleProvider>(
                                    context,
                                    listen: false,
                                  ).locale.languageCode ==
                                  'en'
                              ? 'Full name must be at least 3 characters'
                              : 'Ad soyad en az 3 karakter olmalıdır');
                  }
                  return null;
                },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 280,
                  child: TextFormField(
                    controller: _registerEmailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText:
                        Provider.of<LocaleProvider>(
                              context,
                            ).locale.languageCode ==
                            'de'
                      ? 'Ihre E-Mail-Adresse'
                      : (Provider.of<LocaleProvider>(
                                  context,
                                ).locale.languageCode ==
                                'en'
                            ? 'Your email address'
                            : 'E-posta adresiniz'),
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Provider.of<LocaleProvider>(
                              context,
                              listen: false,
                            ).locale.languageCode ==
                            'de'
                        ? 'Bitte geben Sie Ihre E-Mail-Adresse ein'
                        : (Provider.of<LocaleProvider>(
                                    context,
                                    listen: false,
                                  ).locale.languageCode ==
                                  'en'
                              ? 'Please enter your email address'
                              : 'Lütfen e-posta adresinizi girin');
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return Provider.of<LocaleProvider>(
                              context,
                              listen: false,
                            ).locale.languageCode ==
                            'de'
                        ? 'Bitte geben Sie eine gültige E-Mail-Adresse ein'
                        : (Provider.of<LocaleProvider>(
                                    context,
                                    listen: false,
                                  ).locale.languageCode ==
                                  'en'
                              ? 'Please enter a valid email address'
                              : 'Geçerli bir e-posta adresi girin');
                  }
                  return null;
                },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 280,
                  child: TextFormField(
                    controller: _registerPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText:
                        Provider.of<LocaleProvider>(
                              context,
                            ).locale.languageCode ==
                            'de'
                        ? 'Passwort erstellen'
                        : (Provider.of<LocaleProvider>(
                                    context,
                                  ).locale.languageCode ==
                                  'en'
                              ? 'Create password'
                              : 'Şifre oluşturun'),
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Provider.of<LocaleProvider>(
                              context,
                              listen: false,
                            ).locale.languageCode ==
                            'de'
                        ? 'Bitte geben Sie ein Passwort ein'
                        : (Provider.of<LocaleProvider>(
                                    context,
                                    listen: false,
                                  ).locale.languageCode ==
                                  'en'
                              ? 'Please enter a password'
                              : 'Lütfen bir şifre girin');
                  }
                  if (value.length < 6) {
                    return Provider.of<LocaleProvider>(
                              context,
                              listen: false,
                            ).locale.languageCode ==
                            'de'
                        ? 'Das Passwort muss mindestens 6 Zeichen lang sein'
                        : (Provider.of<LocaleProvider>(
                                    context,
                                    listen: false,
                                  ).locale.languageCode ==
                                  'en'
                              ? 'Password must be at least 6 characters'
                              : 'Şifre en az 6 karakter olmalıdır');
                  }
                  return null;
                },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  width: 280,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                  onPressed: _signUpWithEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4285F4),
                    foregroundColor: Colors.white,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    Provider.of<LocaleProvider>(context).locale.languageCode ==
                            'de'
                        ? 'Registrieren'
                        : (Provider.of<LocaleProvider>(
                                    context,
                                  ).locale.languageCode ==
                                  'en'
                              ? 'Register'
                              : 'Kayıt Ol'),
                  ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
        ),
      ),
    );
  }

  void _signInWithEmail() async {
    if (_loginFormKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  void _signUpWithEmail() async {
    if (_registerFormKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.signUpWithEmail(
        _registerEmailController.text.trim(),
        _registerPasswordController.text.trim(),
        _registerFullNameController.text.trim(),
      );

      if (success && mounted) {
        // Kayıt başarılıysa kullanıcıya bildir
        // Kayıt başarılı - direkt giriş sekmesine geç

        // Giriş tab'ına geçiş yap
        _tabController.animateTo(0); // 0 = Giriş tab'ı

        // Kayıt formunu temizle
        _registerFullNameController.clear();
        _registerEmailController.clear();
        _registerPasswordController.clear();
      }
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    // Capture context values before async gap
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final googleSignInErrorText = S.of(context).googleSignInError;

    try {
      await authProvider.signInWithGoogle();
      // Navigation will be handled automatically by AuthWrapper
    } catch (e) {
      // Showing error message with previously captured context
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('$googleSignInErrorText: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
