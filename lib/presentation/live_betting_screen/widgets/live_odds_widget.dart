import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class LiveOddsWidget extends StatefulWidget {
  final Map<String, dynamic> odds;
  final Function(String, String, double) onBetSelected;
  final String market;

  const LiveOddsWidget({
    super.key,
    required this.odds,
    required this.onBetSelected,
    required this.market,
  });

  @override
  _LiveOddsWidgetState createState() => _LiveOddsWidgetState();
}

class _LiveOddsWidgetState extends State<LiveOddsWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final Map<String, bool> _recentlyChanged = {};

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(LiveOddsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check for odds changes and trigger animations
    widget.odds.forEach((key, value) {
      if (oldWidget.odds[key] != null &&
          oldWidget.odds[key]['odds'] != value['odds']) {
        _triggerChangeAnimation(key);
      }
    });
  }

  void _triggerChangeAnimation(String key) {
    setState(() {
      _recentlyChanged[key] = true;
    });

    _pulseController.forward().then((_) {
      _pulseController.reverse().then((_) {
        setState(() {
          _recentlyChanged[key] = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                'Live Odds',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                'Last updated: now',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildOddsGrid(),
        ],
      ),
    );
  }

  Widget _buildOddsGrid() {
    final oddsList = widget.odds.entries.toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: oddsList.length,
      itemBuilder: (context, index) {
        final entry = oddsList[index];
        final key = entry.key;
        final value = entry.value as Map<String, dynamic>;

        return _buildOddsCard(key, value);
      },
    );
  }

  Widget _buildOddsCard(String key, Map<String, dynamic> value) {
    final odds = value['odds'] as double;
    final change = value['change'] as String;
    final isRecentlyChanged = _recentlyChanged[key] ?? false;

    Color changeColor = AppTheme.lightTheme.colorScheme.onSurface;
    Color backgroundColor = AppTheme.lightTheme.colorScheme.surface;
    IconData? changeIcon;

    switch (change) {
      case 'up':
        changeColor = AppTheme.lightTheme.colorScheme.tertiary;
        backgroundColor =
            AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1);
        changeIcon = Icons.trending_up;
        break;
      case 'down':
        changeColor = AppTheme.lightTheme.colorScheme.error;
        backgroundColor =
            AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1);
        changeIcon = Icons.trending_down;
        break;
      case 'stable':
        changeColor = AppTheme.lightTheme.colorScheme.onSurface;
        backgroundColor = AppTheme.lightTheme.colorScheme.surface;
        break;
    }

    Widget cardContent = InkWell(
      onTap: () => widget.onBetSelected(widget.market, key, odds),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isRecentlyChanged
                ? changeColor
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
            width: isRecentlyChanged ? 2 : 1,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatSelectionName(key),
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
                    iconName: change == 'up' ? 'trending_up' : 'trending_down',
                    color: changeColor,
                    size: 14,
                  ),
                  SizedBox(width: 4),
                ],
                Text(
                  odds.toStringAsFixed(2),
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

    if (isRecentlyChanged) {
      return AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: cardContent,
          );
        },
      );
    }

    return cardContent;
  }

  String _formatSelectionName(String key) {
    switch (key) {
      case 'homeWin':
        return 'Home Win';
      case 'awayWin':
        return 'Away Win';
      case 'draw':
        return 'Draw';
      case 'over2_5':
        return 'Over 2.5';
      case 'under2_5':
        return 'Under 2.5';
      case 'over3_5':
        return 'Over 3.5';
      case 'under3_5':
        return 'Under 3.5';
      case 'redCard':
        return 'Red Card';
      case 'over8_5':
        return 'Over 8.5';
      case 'under8_5':
        return 'Under 8.5';
      case 'over10_5':
        return 'Over 10.5';
      default:
        return key.replaceAll('_', ' ').toUpperCase();
    }
  }
}
