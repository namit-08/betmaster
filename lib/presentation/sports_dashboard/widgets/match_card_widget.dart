import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MatchCardWidget extends StatelessWidget {
  final Map<String, dynamic> match;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onFavoriteToggle;

  const MatchCardWidget({
    super.key,
    required this.match,
    required this.onTap,
    required this.onLongPress,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLive = match['isLive'] ?? false;
    final String? drawOdds = match['drawOdds'];
    final bool isFavorite = match['isFavorite'] ?? false;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppTheme.lightTheme.colorScheme.surface,
            border: isLive
                ? Border.all(
                    color: Colors.red.withValues(alpha: 0.3),
                    width: 1,
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 2.h),
              _buildTeamsAndOdds(),
              SizedBox(height: 2.h),
              _buildMatchInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final bool isLive = match['isLive'] ?? false;
    final bool isFavorite = match['isFavorite'] ?? false;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color:
                isLive ? Colors.red : AppTheme.lightTheme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLive) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 1.w),
              ],
              Text(
                isLive ? 'LIVE' : 'UPCOMING',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: onFavoriteToggle,
          child: CustomIconWidget(
            iconName: isFavorite ? 'favorite' : 'favorite_border',
            color: isFavorite
                ? Colors.red
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildTeamsAndOdds() {
    final String homeTeam = match['homeTeam'] ?? '';
    final String awayTeam = match['awayTeam'] ?? '';
    final String homeOdds = match['homeOdds'] ?? '';
    final String awayOdds = match['awayOdds'] ?? '';
    final String? drawOdds = match['drawOdds'];

    return Column(
      children: [
        _buildTeamRow(homeTeam, homeOdds, true),
        if (drawOdds != null) ...[
          SizedBox(height: 1.h),
          _buildDrawRow(drawOdds),
        ],
        SizedBox(height: 1.h),
        _buildTeamRow(awayTeam, awayOdds, false),
      ],
    );
  }

  Widget _buildTeamRow(String teamName, String odds, bool isHome) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            teamName,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              odds,
              style: AppTheme.dataTextStyle(
                isLight: true,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawRow(String drawOdds) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            'Draw',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              drawOdds,
              style: AppTheme.dataTextStyle(
                isLight: true,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMatchInfo() {
    final String league = match['league'] ?? '';
    final String time = match['time'] ?? '';
    final String? score = match['score'];
    final bool isLive = match['isLive'] ?? false;

    return Row(
      children: [
        CustomIconWidget(
          iconName: 'sports',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 16,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Text(
            league,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isLive && score != null) ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              score,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.tertiary,
              ),
            ),
          ),
          SizedBox(width: 2.w),
        ],
        Text(
          time,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: isLive
                ? Colors.red
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: isLive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
