import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SportsFilterWidget extends StatelessWidget {
  final String sport;
  final bool isSelected;
  final VoidCallback onTap;

  const SportsFilterWidget({
    super.key,
    required this.sport,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.secondary
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.secondary
                : AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSportIcon(),
            SizedBox(width: 2.w),
            Text(
              sport,
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.onSecondary
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSportIcon() {
    String iconName;
    switch (sport.toLowerCase()) {
      case 'football':
        iconName = 'sports_soccer';
        break;
      case 'basketball':
        iconName = 'sports_basketball';
        break;
      case 'tennis':
        iconName = 'sports_tennis';
        break;
      case 'american football':
        iconName = 'sports_football';
        break;
      case 'baseball':
        iconName = 'sports_baseball';
        break;
      case 'hockey':
        iconName = 'sports_hockey';
        break;
      default:
        iconName = 'sports';
        break;
    }

    return CustomIconWidget(
      iconName: iconName,
      color: isSelected
          ? AppTheme.lightTheme.colorScheme.onSecondary
          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      size: 18,
    );
  }
}
