import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';

class BetCardWidget extends StatefulWidget {
  final Map<String, dynamic> bet;
  final VoidCallback onRemove;
  final Function(double) onStakeChanged;

  const BetCardWidget({
    super.key,
    required this.bet,
    required this.onRemove,
    required this.onStakeChanged,
  });

  @override
  _BetCardWidgetState createState() => _BetCardWidgetState();
}

class _BetCardWidgetState extends State<BetCardWidget>
    with SingleTickerProviderStateMixin {
  late TextEditingController _stakeController;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _stakeController = TextEditingController(
      text: (widget.bet["stake"] as double).toStringAsFixed(0),
    );

    _shakeController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));
  }

  void _onStakeChanged(String value) {
    final stake = double.tryParse(value) ?? 0.0;
    final maxStake = widget.bet["maxStake"] as double;

    if (stake > maxStake) {
      _shakeController.forward().then((_) => _shakeController.reverse());
      HapticFeedback.heavyImpact();
      return;
    }

    widget.onStakeChanged(stake);
  }

  @override
  void dispose() {
    _stakeController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasOddsChanged = widget.bet["hasOddsChanged"] as bool;
    final currentOdds = widget.bet["odds"] as double;
    final originalOdds = widget.bet["originalOdds"] as double;
    final stake = widget.bet["stake"] as double;
    final potentialReturn = stake * currentOdds;

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: Dismissible(
            key: Key(widget.bet["id"] as String),
            direction: DismissDirection.endToStart,
            onDismissed: (_) {
              setState(() => _isDismissing = true);
              widget.onRemove();
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.error,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'delete',
                    color: AppTheme.lightTheme.colorScheme.onError,
                    size: 24,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Remove',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onError,
                    ),
                  ),
                ],
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasOddsChanged
                      ? AppTheme.lightTheme.colorScheme.tertiary
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                  width: hasOddsChanged ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 12),
                  _buildMatchInfo(),
                  SizedBox(height: 12),
                  _buildOddsSection(hasOddsChanged, currentOdds, originalOdds),
                  SizedBox(height: 16),
                  _buildStakeSection(potentialReturn),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.bet["selection"] as String,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                widget.bet["market"] as String,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: widget.onRemove,
          child: Container(
            padding: EdgeInsets.all(4),
            child: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMatchInfo() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.bet["matchName"] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'sports_soccer',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 14,
              ),
              SizedBox(width: 4),
              Text(
                widget.bet["league"] as String,
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              SizedBox(width: 12),
              CustomIconWidget(
                iconName: 'schedule',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 14,
              ),
              SizedBox(width: 4),
              Text(
                widget.bet["kickoffTime"] as String,
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOddsSection(
      bool hasOddsChanged, double currentOdds, double originalOdds) {
    return Row(
      children: [
        Text(
          'Odds:',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        SizedBox(width: 8),
        if (hasOddsChanged) ...[
          Text(
            originalOdds.toStringAsFixed(2),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(width: 4),
          CustomIconWidget(
            iconName: 'arrow_forward',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 16,
          ),
          SizedBox(width: 4),
        ],
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: hasOddsChanged
                ? (currentOdds > originalOdds
                    ? AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.1))
                : AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            currentOdds.toStringAsFixed(2),
            style: AppTheme.dataTextStyle(
              isLight: true,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ).copyWith(
              color: hasOddsChanged
                  ? (currentOdds > originalOdds
                      ? AppTheme.lightTheme.colorScheme.tertiary
                      : AppTheme.lightTheme.colorScheme.error)
                  : AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ),
        if (hasOddsChanged) ...[
          SizedBox(width: 8),
          CustomIconWidget(
            iconName:
                currentOdds > originalOdds ? 'trending_up' : 'trending_down',
            color: currentOdds > originalOdds
                ? AppTheme.lightTheme.colorScheme.tertiary
                : AppTheme.lightTheme.colorScheme.error,
            size: 16,
          ),
        ],
      ],
    );
  }

  Widget _buildStakeSection(double potentialReturn) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stake',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 4),
              SizedBox(
                height: 40,
                child: TextFormField(
                  controller: _stakeController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  onChanged: _onStakeChanged,
                  style: AppTheme.dataTextStyle(
                    isLight: true,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    prefixText: '₹',
                    prefixStyle: AppTheme.lightTheme.textTheme.bodyMedium,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Potential Return',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '₹${potentialReturn.toStringAsFixed(2)}',
                style: AppTheme.successTextStyle(
                  isLight: true,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
