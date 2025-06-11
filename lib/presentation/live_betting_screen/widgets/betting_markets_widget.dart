import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class BettingMarketsWidget extends StatelessWidget {
  final String market;
  final Map<String, dynamic> odds;
  final Function(String, String, double) onBetSelected;

  const BettingMarketsWidget({
    super.key,
    required this.market,
    required this.odds,
    required this.onBetSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            market,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          if (market == 'Match Result') _buildMatchResultMarket(),
          if (market == 'Goals') _buildGoalsMarket(),
          if (market == 'Cards') _buildCardsMarket(),
          if (market == 'Corners') _buildCornersMarket(),
        ],
      ),
    );
  }

  Widget _buildMatchResultMarket() {
    return Column(
      children: [
        // Main Result
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Full Time Result',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildOddsButton(
                        'Home Win',
                        odds['homeWin']?['odds'] ?? 0.0,
                        odds['homeWin']?['change'] ?? 'stable',
                        'homeWin',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildOddsButton(
                        'Draw',
                        odds['draw']?['odds'] ?? 0.0,
                        odds['draw']?['change'] ?? 'stable',
                        'draw',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildOddsButton(
                        'Away Win',
                        odds['awayWin']?['odds'] ?? 0.0,
                        odds['awayWin']?['change'] ?? 'stable',
                        'awayWin',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 16),

        // Double Chance
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Double Chance',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildOddsButton(
                        '1X',
                        1.35,
                        'stable',
                        '1X',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildOddsButton(
                        '12',
                        1.25,
                        'up',
                        '12',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildOddsButton(
                        'X2',
                        1.95,
                        'down',
                        'X2',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalsMarket() {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Goals',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildOddsButton(
                        'Over 2.5',
                        odds['over2_5']?['odds'] ?? 0.0,
                        odds['over2_5']?['change'] ?? 'stable',
                        'over2_5',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildOddsButton(
                        'Under 2.5',
                        odds['under2_5']?['odds'] ?? 0.0,
                        odds['under2_5']?['change'] ?? 'stable',
                        'under2_5',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildOddsButton(
                        'Over 3.5',
                        odds['over3_5']?['odds'] ?? 0.0,
                        odds['over3_5']?['change'] ?? 'stable',
                        'over3_5',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildOddsButton(
                        'Under 3.5',
                        odds['under3_5']?['odds'] ?? 0.0,
                        odds['under3_5']?['change'] ?? 'stable',
                        'under3_5',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Both Teams to Score',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildOddsButton(
                        'Yes',
                        1.75,
                        'up',
                        'btts_yes',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildOddsButton(
                        'No',
                        2.05,
                        'down',
                        'btts_no',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardsMarket() {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Cards',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildOddsButton(
                        'Over 3.5',
                        odds['over3_5']?['odds'] ?? 0.0,
                        odds['over3_5']?['change'] ?? 'stable',
                        'cards_over3_5',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildOddsButton(
                        'Under 3.5',
                        odds['under3_5']?['odds'] ?? 0.0,
                        odds['under3_5']?['change'] ?? 'stable',
                        'cards_under3_5',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Red Card',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildOddsButton(
                        'Yes',
                        odds['redCard']?['odds'] ?? 0.0,
                        odds['redCard']?['change'] ?? 'stable',
                        'red_card_yes',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildOddsButton(
                        'No',
                        1.22,
                        'stable',
                        'red_card_no',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCornersMarket() {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Corners',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildOddsButton(
                        'Over 8.5',
                        odds['over8_5']?['odds'] ?? 0.0,
                        odds['over8_5']?['change'] ?? 'stable',
                        'corners_over8_5',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildOddsButton(
                        'Under 8.5',
                        odds['under8_5']?['odds'] ?? 0.0,
                        odds['under8_5']?['change'] ?? 'stable',
                        'corners_under8_5',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildOddsButton(
                        'Over 10.5',
                        odds['over10_5']?['odds'] ?? 0.0,
                        odds['over10_5']?['change'] ?? 'stable',
                        'corners_over10_5',
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildOddsButton(
                        'Under 10.5',
                        1.65,
                        'down',
                        'corners_under10_5',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOddsButton(
      String label, double oddsValue, String change, String selection) {
    Color changeColor = AppTheme.lightTheme.colorScheme.onSurface;
    IconData? changeIcon;

    switch (change) {
      case 'up':
        changeColor = AppTheme.lightTheme.colorScheme.tertiary;
        changeIcon = Icons.arrow_upward;
        break;
      case 'down':
        changeColor = AppTheme.lightTheme.colorScheme.error;
        changeIcon = Icons.arrow_downward;
        break;
      case 'stable':
        changeColor = AppTheme.lightTheme.colorScheme.onSurface;
        break;
    }

    return InkWell(
      onTap: () => onBetSelected(market, selection, oddsValue),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(8),
          color: AppTheme.lightTheme.colorScheme.surface,
        ),
        child: Column(
          children: [
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (changeIcon != null) ...[
                  CustomIconWidget(
                    iconName:
                        change == 'up' ? 'arrow_upward' : 'arrow_downward',
                    color: changeColor,
                    size: 12,
                  ),
                  SizedBox(width: 4),
                ],
                Text(
                  oddsValue.toStringAsFixed(2),
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
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
