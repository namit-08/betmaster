import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialRegistrationWidget extends StatelessWidget {
  final Function(String) onSocialLogin;
  final bool isLoading;

  const SocialRegistrationWidget({
    super.key,
    required this.onSocialLogin,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Google Sign Up
        _buildSocialButton(
          context: context,
          provider: 'Google',
          icon: 'g_translate',
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          textColor: AppTheme.lightTheme.colorScheme.onSurface,
          borderColor: AppTheme.lightTheme.colorScheme.outline,
          onTap: () => onSocialLogin('google'),
        ),

        SizedBox(height: 2.h),

        // Apple Sign Up (iOS style)
        _buildSocialButton(
          context: context,
          provider: 'Apple',
          icon: 'apple',
          backgroundColor: AppTheme.lightTheme.colorScheme.onSurface,
          textColor: AppTheme.lightTheme.colorScheme.surface,
          borderColor: AppTheme.lightTheme.colorScheme.onSurface,
          onTap: () => onSocialLogin('apple'),
        ),

        SizedBox(height: 2.h),

        // Facebook Sign Up
        _buildSocialButton(
          context: context,
          provider: 'Facebook',
          icon: 'facebook',
          backgroundColor: Color(0xFF1877F2),
          textColor: Colors.white,
          borderColor: Color(0xFF1877F2),
          onTap: () => onSocialLogin('facebook'),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required String provider,
    required String icon,
    required Color backgroundColor,
    required Color textColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          side: BorderSide(color: borderColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 4.w),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: icon,
                    color: textColor,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Continue with $provider',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
