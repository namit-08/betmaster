import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MatchHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> matchData;
  final bool isCollapsed;

  const MatchHeaderWidget({
    super.key,
    required this.matchData,
    required this.isCollapsed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primaryContainer,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!isCollapsed) ...[
                // Competition and Stadium
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      matchData['competition'] ?? '',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary
                            .withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      matchData['stadium'] ?? '',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary
                            .withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],

              // Teams and Score
              Row(
                children: [
                  // Home Team
                  Expanded(
                    child: Column(
                      children: [
                        CustomImageWidget(
                          imageUrl: matchData['homeTeamLogo'] ?? '',
                          width: isCollapsed ? 30 : 50,
                          height: isCollapsed ? 30 : 50,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 8),
                        Text(
                          matchData['homeTeam'] ?? '',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            fontSize: isCollapsed ? 12.sp : 14.sp,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Score and Time
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${matchData['homeScore']}',
                                style: AppTheme
                                    .lightTheme.textTheme.headlineMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isCollapsed ? 18.sp : 24.sp,
                                ),
                              ),
                              SizedBox(width: 16),
                              Text(
                                '-',
                                style: AppTheme
                                    .lightTheme.textTheme.headlineMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  fontSize: isCollapsed ? 18.sp : 24.sp,
                                ),
                              ),
                              SizedBox(width: 16),
                              Text(
                                '${matchData['awayScore']}',
                                style: AppTheme
                                    .lightTheme.textTheme.headlineMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isCollapsed ? 18.sp : 24.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            matchData['matchTime'] ?? '',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: isCollapsed ? 10.sp : 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Away Team
                  Expanded(
                    child: Column(
                      children: [
                        CustomImageWidget(
                          imageUrl: matchData['awayTeamLogo'] ?? '',
                          width: isCollapsed ? 30 : 50,
                          height: isCollapsed ? 30 : 50,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 8),
                        Text(
                          matchData['awayTeam'] ?? '',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            fontSize: isCollapsed ? 12.sp : 14.sp,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (!isCollapsed) ...[
                SizedBox(height: 16),
                // Live Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'LIVE',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
