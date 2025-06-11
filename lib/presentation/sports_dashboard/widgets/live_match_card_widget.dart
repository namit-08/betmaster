import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LiveMatchCardWidget extends StatefulWidget {
  final Map<String, dynamic> match;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onFavoriteToggle;

  const LiveMatchCardWidget({
    super.key,
    required this.match,
    required this.onTap,
    required this.onLongPress,
    required this.onFavoriteToggle,
  });

  @override
  _LiveMatchCardWidgetState createState() => _LiveMatchCardWidgetState();
}

class _LiveMatchCardWidgetState extends State<LiveMatchCardWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.match['isLive'] == true) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String homeTeam = widget.match['homeTeam'] ?? '';
    final String awayTeam = widget.match['awayTeam'] ?? '';
    final String homeOdds = widget.match['homeOdds'] ?? '';
    final String awayOdds = widget.match['awayOdds'] ?? '';
    final String? drawOdds = widget.match['drawOdds'];
    final String? score = widget.match['score'];
    final String time = widget.match['time'] ?? '';
    final String league = widget.match['league'] ?? '';
    final bool isFavorite = widget.match['isFavorite'] ?? false;
    final String? imageUrl = widget.match['image'];

    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Card(
              elevation: 4,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.lightTheme.colorScheme.surface,
                      AppTheme.lightTheme.colorScheme.surface
                          .withValues(alpha: 0.8),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.red.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageHeader(imageUrl),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLiveHeader(),
                            SizedBox(height: 2.h),
                            _buildTeamsAndScore(homeTeam, awayTeam, score),
                            SizedBox(height: 2.h),
                            _buildOddsSection(homeOdds, drawOdds, awayOdds),
                            Spacer(),
                            _buildMatchInfo(league, time),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageHeader(String? imageUrl) {
    return Container(
      height: 12.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: imageUrl != null
                ? CustomImageWidget(
                    imageUrl: imageUrl,
                    width: double.infinity,
                    height: 12.h,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: double.infinity,
                    height: 12.h,
                    color: AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.1),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'sports_soccer',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 32,
                      ),
                    ),
                  ),
          ),
          Positioned(
            top: 2.w,
            right: 2.w,
            child: GestureDetector(
              onTap: widget.onFavoriteToggle,
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: widget.match['isFavorite'] == true
                      ? 'favorite'
                      : 'favorite_border',
                  color: widget.match['isFavorite'] == true
                      ? Colors.red
                      : Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 1.w),
              Text(
                'LIVE',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        Text(
          widget.match['time'] ?? '',
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTeamsAndScore(String homeTeam, String awayTeam, String? score) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                homeTeam,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (score != null) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  score,
                  style: AppTheme.dataTextStyle(
                    isLight: true,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: Text(
                awayTeam,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOddsSection(String homeOdds, String? drawOdds, String awayOdds) {
    return Row(
      children: [
        Expanded(
          child: _buildOddsButton(homeOdds, 'Home'),
        ),
        if (drawOdds != null) ...[
          SizedBox(width: 2.w),
          Expanded(
            child: _buildOddsButton(drawOdds, 'Draw'),
          ),
        ],
        SizedBox(width: 2.w),
        Expanded(
          child: _buildOddsButton(awayOdds, 'Away'),
        ),
      ],
    );
  }

  Widget _buildOddsButton(String odds, String label) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            odds,
            style: AppTheme.dataTextStyle(
              isLight: true,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchInfo(String league, String time) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'sports',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 14,
        ),
        SizedBox(width: 1.w),
        Expanded(
          child: Text(
            league,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
