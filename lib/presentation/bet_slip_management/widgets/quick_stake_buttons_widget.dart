import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class QuickStakeButtonsWidget extends StatelessWidget {
  final Function(double) onStakeSelected;
  final double accountBalance;

  const QuickStakeButtonsWidget({
    super.key,
    required this.onStakeSelected,
    required this.accountBalance,
  });

  @override
  Widget build(BuildContext context) {
    final quickStakes = [10.0, 50.0, 100.0, accountBalance];
    final labels = ['₹10', '₹50', '₹100', 'Max'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Stakes',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 12),
        Row(
          children: List.generate(quickStakes.length, (index) {
            final stake = quickStakes[index];
            final label = labels[index];
            final isMax = index == quickStakes.length - 1;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index < quickStakes.length - 1 ? 8 : 0,
                ),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onStakeSelected(stake);
                  },
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: isMax
                          ? AppTheme.lightTheme.colorScheme.tertiary
                              .withValues(alpha: 0.1)
                          : AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isMax
                            ? AppTheme.lightTheme.colorScheme.tertiary
                            : AppTheme.lightTheme.colorScheme.primary,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            label,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: isMax
                                  ? AppTheme.lightTheme.colorScheme.tertiary
                                  : AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (isMax) ...[
                            Text(
                              '₹${accountBalance.toStringAsFixed(0)}',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.tertiary,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
