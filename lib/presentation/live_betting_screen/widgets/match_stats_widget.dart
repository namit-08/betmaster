import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class MatchStatsWidget extends StatelessWidget {
  final Map<String, dynamic> matchData;

  const MatchStatsWidget({
    super.key,
    required this.matchData,
  });

  @override
  Widget build(BuildContext context) {
    // Mock match statistics
    final Map<String, dynamic> matchStats = {
      "possession": {"home": 58, "away": 42},
      "shots": {"home": 12, "away": 8},
      "shotsOnTarget": {"home": 6, "away": 3},
      "corners": {"home": 7, "away": 4},
      "fouls": {"home": 11, "away": 14},
      "yellowCards": {"home": 2, "away": 3},
      "redCards": {"home": 0, "away": 0},
      "offsides": {"home": 3, "away": 2},
    };

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'bar_chart',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Match Statistics',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Team names header
            Row(
              children: [
                Expanded(
                  child: Text(
                    matchData['homeTeam'] ?? '',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    'Stats',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    matchData['awayTeam'] ?? '',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Statistics rows
            _buildStatRow('Possession', matchStats['possession']),
            _buildStatRow('Shots', matchStats['shots']),
            _buildStatRow('Shots on Target', matchStats['shotsOnTarget']),
            _buildStatRow('Corners', matchStats['corners']),
            _buildStatRow('Fouls', matchStats['fouls']),
            _buildStatRow('Yellow Cards', matchStats['yellowCards']),
            _buildStatRow('Red Cards', matchStats['redCards']),
            _buildStatRow('Offsides', matchStats['offsides']),

            SizedBox(height: 16),

            // Recent events
            _buildRecentEvents(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String statName, Map<String, dynamic> values) {
    final homeValue = values['home'] as int;
    final awayValue = values['away'] as int;
    final total = homeValue + awayValue;
    final homePercentage = total > 0 ? homeValue / total : 0.0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  homeValue.toString(),
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 100,
                child: Text(
                  statName,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  awayValue.toString(),
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          if (statName == 'Possession') ...[
            SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  flex: (homePercentage * 100).round(),
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(2),
                        bottomLeft: Radius.circular(2),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: ((1 - homePercentage) * 100).round(),
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(2),
                        bottomRight: Radius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            SizedBox(height: 4),
            Container(
              height: 1,
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecentEvents() {
    final events = matchData['events'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Events',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        if (events.isEmpty)
          Text(
            'No events yet',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          )
        else
          ...events.reversed
              .take(3)
              .map((event) => _buildEventItem(event))
              ,
      ],
    );
  }

  Widget _buildEventItem(Map<String, dynamic> event) {
    IconData eventIcon;
    Color eventColor;

    switch (event['type']) {
      case 'GOAL':
        eventIcon = Icons.sports_soccer;
        eventColor = AppTheme.lightTheme.colorScheme.tertiary;
        break;
      case 'YELLOW_CARD':
        eventIcon = Icons.rectangle;
        eventColor = Colors.yellow;
        break;
      case 'RED_CARD':
        eventIcon = Icons.rectangle;
        eventColor = AppTheme.lightTheme.colorScheme.error;
        break;
      default:
        eventIcon = Icons.info;
        eventColor = AppTheme.lightTheme.colorScheme.onSurface;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              "${event['time']}",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 8),
          CustomIconWidget(
            iconName: event['type'] == 'GOAL' ? 'sports_soccer' : 'rectangle',
            color: eventColor,
            size: 16,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "${event['player']} - ${event['description']}",
              style: AppTheme.lightTheme.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
