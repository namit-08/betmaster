import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PasswordStrengthWidget extends StatelessWidget {
  final String strength;

  const PasswordStrengthWidget({
    super.key,
    required this.strength,
  });

  Color _getStrengthColor() {
    switch (strength) {
      case 'Weak':
        return AppTheme.lightTheme.colorScheme.error;
      case 'Medium':
        return Color(0xFFFF6B35);
      case 'Strong':
        return Color(0xFF00D4AA);
      default:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }

  double _getStrengthValue() {
    switch (strength) {
      case 'Weak':
        return 0.33;
      case 'Medium':
        return 0.66;
      case 'Strong':
        return 1.0;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: _getStrengthValue(),
                backgroundColor: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(_getStrengthColor()),
                minHeight: 4,
              ),
            ),
            SizedBox(width: 2.w),
            Text(
              strength,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: _getStrengthColor(),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Text(
          _getPasswordTips(),
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String _getPasswordTips() {
    switch (strength) {
      case 'Weak':
        return 'Use uppercase, lowercase, numbers, and special characters';
      case 'Medium':
        return 'Add more special characters for better security';
      case 'Strong':
        return 'Great! Your password is strong and secure';
      default:
        return 'Password must be at least 8 characters long';
    }
  }
}
