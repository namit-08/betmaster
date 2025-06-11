import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialLoginWidget extends StatelessWidget {
  final bool isLoading;
  final Function(String) onSocialLogin;

  const SocialLoginWidget({
    super.key,
    required this.isLoading,
    required this.onSocialLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Continue with',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 3.h),
        Row(
          children: [
            Expanded(
              child: _buildSocialButton(
                context: context,
                provider: 'Google',
                icon: 'g_translate',
                color: Color(0xFF4285F4),
                backgroundColor: Color(0xFF4285F4).withValues(alpha: 0.1),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: _buildSocialButton(
                context: context,
                provider: 'Apple',
                icon: 'apple',
                color: Colors.black,
                backgroundColor: Colors.black.withValues(alpha: 0.1),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: _buildSocialButton(
                context: context,
                provider: 'Facebook',
                icon: 'facebook',
                color: Color(0xFF1877F2),
                backgroundColor: Color(0xFF1877F2).withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required String provider,
    required String icon,
    required Color color,
    required Color backgroundColor,
  }) {
    return SizedBox(
      height: 7.h,
      child: OutlinedButton(
        onPressed: isLoading ? null : () => onSocialLogin(provider),
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.w),
          ),
          padding: EdgeInsets.symmetric(vertical: 2.h),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: color,
              size: 6.w,
            ),
            SizedBox(height: 0.5.h),
            Text(
              provider,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
