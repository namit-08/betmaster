import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BetSlipDrawerWidget extends StatefulWidget {
  final List<Map<String, dynamic>> betSlipItems;
  final Function(int) onRemoveItem;
  final VoidCallback onClose;

  const BetSlipDrawerWidget({
    super.key,
    required this.betSlipItems,
    required this.onRemoveItem,
    required this.onClose,
  });

  @override
  _BetSlipDrawerWidgetState createState() => _BetSlipDrawerWidgetState();
}

class _BetSlipDrawerWidgetState extends State<BetSlipDrawerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  final List<TextEditingController> _stakeControllers = [];
  double _totalStake = 0.0;
  double _totalPotentialWin = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _initializeControllers();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _stakeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeControllers() {
    _stakeControllers.clear();
    for (int i = 0; i < widget.betSlipItems.length; i++) {
      final controller = TextEditingController();
      controller.addListener(() => _updateTotals());
      _stakeControllers.add(controller);
    }
  }

  void _updateTotals() {
    double totalStake = 0.0;
    double totalPotentialWin = 0.0;

    for (int i = 0; i < _stakeControllers.length; i++) {
      final stakeText = _stakeControllers[i].text;
      final stake = double.tryParse(stakeText) ?? 0.0;
      final odds = widget.betSlipItems[i]['odds'] as double;

      totalStake += stake;
      totalPotentialWin += stake * odds;

      widget.betSlipItems[i]['stake'] = stake;
      widget.betSlipItems[i]['potentialWin'] = stake * odds;
    }

    setState(() {
      _totalStake = totalStake;
      _totalPotentialWin = totalPotentialWin;
    });
  }

  void _placeBets() {
    if (_totalStake == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter stake amounts'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
      return;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Bets'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Stake: \$${_totalStake.toStringAsFixed(2)}'),
            Text('Potential Win: \$${_totalPotentialWin.toStringAsFixed(2)}'),
            SizedBox(height: 16),
            Text(
              'Are you sure you want to place these bets?',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmBets();
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _confirmBets() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bets placed successfully!'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );

    // Clear bet slip and close drawer
    widget.betSlipItems.clear();
    widget.onClose();
  }

  void _closeDrawer() {
    _animationController.reverse().then((_) {
      widget.onClose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value * 100.h),
          child: Container(
            height: 70.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: EdgeInsets.only(top: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Header
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bet Slip (${widget.betSlipItems.length})',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: _closeDrawer,
                        icon: CustomIconWidget(
                          iconName: 'close',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bet items
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: widget.betSlipItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.betSlipItems[index];
                      if (index >= _stakeControllers.length) {
                        _initializeControllers();
                      }

                      return Card(
                        margin: EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['market'] ?? '',
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: AppTheme.lightTheme
                                                .colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        Text(
                                          item['selection'] ?? '',
                                          style: AppTheme
                                              .lightTheme.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        (item['odds'] as double).toStringAsFixed(2),
                                        style: AppTheme
                                            .lightTheme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme
                                              .lightTheme.colorScheme.primary,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      InkWell(
                                        onTap: () => widget.onRemoveItem(index),
                                        child: CustomIconWidget(
                                          iconName: 'delete',
                                          color: AppTheme
                                              .lightTheme.colorScheme.error,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller:
                                          index < _stakeControllers.length
                                              ? _stakeControllers[index]
                                              : TextEditingController(),
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      decoration: InputDecoration(
                                        labelText: 'Stake (\$)',
                                        prefixText: '\$ ',
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: AppTheme
                                            .lightTheme.colorScheme.tertiary
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppTheme
                                              .lightTheme.colorScheme.tertiary,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'To Win',
                                            style: AppTheme
                                                .lightTheme.textTheme.bodySmall,
                                          ),
                                          Text(
                                            '\$ ${(item['potentialWin'] as double).toStringAsFixed(2)}',
                                            style: AppTheme.lightTheme.textTheme
                                                .titleMedium
                                                ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.lightTheme
                                                  .colorScheme.tertiary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Totals and Place Bet button
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    border: Border(
                      top: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Stake:',
                            style: AppTheme.lightTheme.textTheme.titleMedium,
                          ),
                          Text(
                            '\$ ${_totalStake.toStringAsFixed(2)}',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Potential Win:',
                            style: AppTheme.lightTheme.textTheme.titleMedium,
                          ),
                          Text(
                            '\$ ${_totalPotentialWin.toStringAsFixed(2)}',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _placeBets,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppTheme.lightTheme.colorScheme.primary,
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            'Place Bets',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
