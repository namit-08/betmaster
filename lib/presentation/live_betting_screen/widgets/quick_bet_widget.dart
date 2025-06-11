import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class QuickBetWidget extends StatelessWidget {
  final Map<String, dynamic> odds;
  final Function(String, String, double) onBetSelected;
  final String selectedMarket;

  const QuickBetWidget({
    super.key,
    required this.odds,
    required this.onBetSelected,
    required this.selectedMarket,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: AppTheme.lightTheme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'flash_on',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Quick Bet',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          if (selectedMarket == 'Match Result') _buildMatchResultQuickBets(),
          if (selectedMarket == 'Goals') _buildGoalsQuickBets(),
          if (selectedMarket == 'Cards') _buildCardsQuickBets(),
          if (selectedMarket == 'Corners') _buildCornersQuickBets(),
        ],
      ),
    );
  }

  Widget _buildMatchResultQuickBets() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickBetButton(
            'Home',
            odds['homeWin']?['odds'] ?? 0.0,
            odds['homeWin']?['change'] ?? 'stable',
            'homeWin',
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _buildQuickBetButton(
            'Draw',
            odds['draw']?['odds'] ?? 0.0,
            odds['draw']?['change'] ?? 'stable',
            'draw',
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _buildQuickBetButton(
            'Away',
            odds['awayWin']?['odds'] ?? 0.0,
            odds['awayWin']?['change'] ?? 'stable',
            'awayWin',
          ),
        ),
      ],
    );
  }

  Widget _buildGoalsQuickBets() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickBetButton(
            'Over 2.5',
            odds['over2_5']?['odds'] ?? 0.0,
            odds['over2_5']?['change'] ?? 'stable',
            'over2_5',
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _buildQuickBetButton(
            'Under 2.5',
            odds['under2_5']?['odds'] ?? 0.0,
            odds['under2_5']?['change'] ?? 'stable',
            'under2_5',
          ),
        ),
      ],
    );
  }

  Widget _buildCardsQuickBets() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickBetButton(
            'Over 3.5 Cards',
            odds['over3_5']?['odds'] ?? 0.0,
            odds['over3_5']?['change'] ?? 'stable',
            'cards_over3_5',
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _buildQuickBetButton(
            'Red Card',
            odds['redCard']?['odds'] ?? 0.0,
            odds['redCard']?['change'] ?? 'stable',
            'red_card_yes',
          ),
        ),
      ],
    );
  }

  Widget _buildCornersQuickBets() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickBetButton(
            'Over 8.5',
            odds['over8_5']?['odds'] ?? 0.0,
            odds['over8_5']?['change'] ?? 'stable',
            'corners_over8_5',
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _buildQuickBetButton(
            'Under 8.5',
            odds['under8_5']?['odds'] ?? 0.0,
            odds['under8_5']?['change'] ?? 'stable',
            'corners_under8_5',
          ),
        ),
      ],
    );
  }

  Widget _buildQuickBetButton(
      String label, double oddsValue, String change, String selection) {
    Color changeColor = AppTheme.lightTheme.colorScheme.onSurface;
    Color backgroundColor = AppTheme.lightTheme.colorScheme.surface;

    switch (change) {
      case 'up':
        changeColor = AppTheme.lightTheme.colorScheme.tertiary;
        backgroundColor =
            AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1);
        break;
      case 'down':
        changeColor = AppTheme.lightTheme.colorScheme.error;
        backgroundColor =
            AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1);
        break;
      case 'stable':
        changeColor = AppTheme.lightTheme.colorScheme.onSurface;
        backgroundColor = AppTheme.lightTheme.colorScheme.surface;
        break;
    }

    return InkWell(
      onTap: () => onBetSelected(selectedMarket, selection, oddsValue),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (change != 'stable') ...[
                  CustomIconWidget(
                    iconName: change == 'up' ? 'trending_up' : 'trending_down',
                    color: changeColor,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                ],
                Text(
                  oddsValue.toStringAsFixed(2),
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: changeColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
