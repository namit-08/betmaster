import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/registration_form_widget.dart';
import './widgets/registration_header_widget.dart';
import './widgets/social_registration_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Form controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Form state
  bool _isLoading = false;
  bool _acceptTerms = false;
  String _selectedCountry = 'United States';
  DateTime? _selectedDateOfBirth;
  final int _currentStep = 1;
  final int _totalSteps = 3;

  // Mock countries data
  final List<Map<String, dynamic>> _countries = [
    {
      "name": "United States",
      "code": "US",
      "dialCode": "+1",
      "flag": "🇺🇸",
      "minAge": 21,
      "currency": "\$"
    },
    {
      "name": "United Kingdom",
      "code": "GB",
      "dialCode": "+44",
      "flag": "🇬🇧",
      "minAge": 18,
      "currency": "£"
    },
    {
      "name": "Canada",
      "code": "CA",
      "dialCode": "+1",
      "flag": "🇨🇦",
      "minAge": 19,
      "currency": "\$"
    },
    {
      "name": "Australia",
      "code": "AU",
      "dialCode": "+61",
      "flag": "🇦🇺",
      "minAge": 18,
      "currency": "\$"
    }
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegistration() async {
    if (!_formKey.currentState!.validate() || !_acceptTerms) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    // Mock validation
    if (_emailController.text == 'test@example.com') {
      _showErrorDialog(
          'This email is already registered. Please use a different email.');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Check age verification
    if (_selectedDateOfBirth != null) {
      final age =
          DateTime.now().difference(_selectedDateOfBirth!).inDays ~/ 365;
      final selectedCountryData = _countries.firstWhere(
        (country) => country['name'] == _selectedCountry,
        orElse: () => _countries[0],
      );

      if (age < selectedCountryData['minAge']) {
        _showErrorDialog(
            'You must be at least ${selectedCountryData['minAge']} years old to register in $_selectedCountry.');
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    setState(() {
      _isLoading = false;
    });

    // Navigate to email verification
    _showSuccessDialog();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Registration Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Registration Successful!'),
        content: Text('Please check your email for verification instructions.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/login-screen');
            },
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _handleSocialRegistration(String provider) async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    Navigator.pushNamed(context, '/sports-dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            RegistrationHeaderWidget(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              onBackPressed: () =>
                  Navigator.pushNamed(context, '/login-screen'),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    Text(
                      'Create Your Account',
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Join thousands of users and start betting today',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // Social Registration
                    SocialRegistrationWidget(
                      onSocialLogin: _handleSocialRegistration,
                      isLoading: _isLoading,
                    ),

                    SizedBox(height: 3.h),

                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Text(
                            'or continue with email',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),

                    SizedBox(height: 3.h),

                    // Registration Form
                    RegistrationFormWidget(
                      formKey: _formKey,
                      emailController: _emailController,
                      phoneController: _phoneController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      selectedCountry: _selectedCountry,
                      selectedDateOfBirth: _selectedDateOfBirth,
                      acceptTerms: _acceptTerms,
                      countries: _countries,
                      onCountryChanged: (country) {
                        setState(() {
                          _selectedCountry = country;
                        });
                      },
                      onDateOfBirthChanged: (date) {
                        setState(() {
                          _selectedDateOfBirth = date;
                        });
                      },
                      onTermsChanged: (value) {
                        setState(() {
                          _acceptTerms = value;
                        });
                      },
                      onRegister: _handleRegistration,
                      isLoading: _isLoading,
                    ),

                    SizedBox(height: 4.h),

                    // Login link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/login-screen'),
                            child: Text(
                              'Sign In',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
