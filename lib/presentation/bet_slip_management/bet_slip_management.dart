import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/bet_card_widget.dart';
import './widgets/bet_type_selector_widget.dart';
import './widgets/odds_change_alert_widget.dart';
import './widgets/quick_stake_buttons_widget.dart';

class BetSlipManagement extends StatefulWidget {
  const BetSlipManagement({super.key});

  @override
  _BetSlipManagementState createState() => _BetSlipManagementState();
}

class _BetSlipManagementState extends State<BetSlipManagement>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  String selectedBetType = 'Single';
  double totalStake = 0.0;
  double potentialWinnings = 0.0;
  bool isLoading = false;
  bool hasOddsChanged = false;
  String? errorMessage;

  final List<Map<String, dynamic>> betSlipData = [
    {
      "id": "bet_001",
      "matchName": "Manchester United vs Liverpool",
      "selection": "Manchester United to Win",
      "market": "Match Winner",
      "odds": 2.45,
      "originalOdds": 2.50,
      "stake": 100.0,
      "hasOddsChanged": true,
      "league": "Premier League",
      "kickoffTime": "Today 15:30",
      "maxStake": 5000.0,
    },
    {
      "id": "bet_002",
      "matchName": "Barcelona vs Real Madrid",
      "selection": "Over 2.5 Goals",
      "market": "Total Goals",
      "odds": 1.85,
      "originalOdds": 1.85,
      "stake": 250.0,
      "hasOddsChanged": false,
      "league": "La Liga",
      "kickoffTime": "Tomorrow 20:00",
      "maxStake": 3000.0,
    },
    {
      "id": "bet_003",
      "matchName": "Bayern Munich vs Dortmund",
      "selection": "Both Teams to Score",
      "market": "BTTS",
      "odds": 1.65,
      "originalOdds": 1.70,
      "stake": 500.0,
      "hasOddsChanged": true,
      "league": "Bundesliga",
      "kickoffTime": "Sunday 17:45",
      "maxStake": 2500.0,
    },
  ];

  final double accountBalance = 15000.0;
  final double maxBetLimit = 10000.0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _calculateTotals();
    _checkForOddsChanges();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_fadeController);

    _slideController.forward();
    _fadeController.forward();
  }

  void _checkForOddsChanges() {
    hasOddsChanged = betSlipData.any((bet) => bet["hasOddsChanged"] == true);
  }

  void _calculateTotals() {
    totalStake =
        betSlipData.fold(0.0, (sum, bet) => sum + (bet["stake"] as double));

    if (selectedBetType == 'Single') {
      potentialWinnings = betSlipData.fold(0.0, (sum, bet) {
        return sum + ((bet["stake"] as double) * (bet["odds"] as double));
      });
    } else if (selectedBetType == 'Multiple') {
      double combinedOdds = betSlipData.fold(1.0, (product, bet) {
        return product * (bet["odds"] as double);
      });
      potentialWinnings = totalStake * combinedOdds;
    } else {
      // System bet calculation (simplified)
      potentialWinnings = totalStake * 1.5; // Placeholder calculation
    }
  }

  void _removeBet(String betId) {
    setState(() {
      betSlipData.removeWhere((bet) => bet["id"] == betId);
      _calculateTotals();
      _checkForOddsChanges();
    });

    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bet removed'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            // Implement undo functionality
          },
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _updateStake(String betId, double newStake) {
    setState(() {
      final betIndex = betSlipData.indexWhere((bet) => bet["id"] == betId);
      if (betIndex != -1) {
        betSlipData[betIndex]["stake"] = newStake;
        _calculateTotals();
      }
    });
  }

  void _onBetTypeChanged(String newType) {
    setState(() {
      selectedBetType = newType;
      _calculateTotals();
    });
  }

  void _applyQuickStake(double amount) {
    setState(() {
      for (var bet in betSlipData) {
        bet["stake"] = amount;
      }
      _calculateTotals();
    });
    HapticFeedback.selectionClick();
  }

  void _acceptOddsChanges() {
    setState(() {
      for (var bet in betSlipData) {
        bet["originalOdds"] = bet["odds"];
        bet["hasOddsChanged"] = false;
      }
      hasOddsChanged = false;
    });
  }

  void _rejectOddsChanges() {
    setState(() {
      for (var bet in betSlipData) {
        if (bet["hasOddsChanged"] == true) {
          bet["odds"] = bet["originalOdds"];
          bet["hasOddsChanged"] = false;
        }
      }
      hasOddsChanged = false;
      _calculateTotals();
    });
  }

  Future<void> _placeBets() async {
    if (!_canPlaceBet()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    HapticFeedback.mediumImpact();

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      // Simulate random success/failure
      if (DateTime.now().millisecond % 2 == 0) {
        _showSuccessDialog();
      } else {
        throw Exception('Insufficient funds');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool _canPlaceBet() {
    if (betSlipData.isEmpty) return false;
    if (totalStake > accountBalance) return false;
    if (totalStake > maxBetLimit) return false;
    if (hasOddsChanged) return false;
    if (betSlipData.any((bet) => (bet["stake"] as double) <= 0)) return false;
    return true;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 24,
            ),
            SizedBox(width: 8),
            Text('Bet Placed Successfully'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reference: BET${DateTime.now().millisecondsSinceEpoch}'),
            SizedBox(height: 8),
            Text('Total Stake: ₹${totalStake.toStringAsFixed(2)}'),
            Text(
                'Potential Winnings: ₹${potentialWinnings.toStringAsFixed(2)}'),
            SizedBox(height: 8),
            Text(
              'Settlement: Within 24 hours after event completion',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Close bet slip
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _shareBetSlip() {
    // Implement share functionality
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bet slip shared')),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: betSlipData.isEmpty
                    ? _buildEmptyState()
                    : _buildBetSlipContent(),
              ),
              if (betSlipData.isNotEmpty) _buildBottomSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Bet Slip',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
            ),
          ),
          GestureDetector(
            onTap: _shareBetSlip,
            child: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'receipt_long',
            color: AppTheme.lightTheme.colorScheme.outline,
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            'Your bet slip is empty',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 8),
          Text(
            'Add selections from any betting market',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/sports-dashboard'),
            child: Text('Browse Sports'),
          ),
        ],
      ),
    );
  }

  Widget _buildBetSlipContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasOddsChanged)
            OddsChangeAlertWidget(
              onAccept: _acceptOddsChanges,
              onReject: _rejectOddsChanges,
            ),
          SizedBox(height: hasOddsChanged ? 16 : 0),

          BetTypeSelectorWidget(
            selectedType: selectedBetType,
            onTypeChanged: _onBetTypeChanged,
          ),

          SizedBox(height: 16),

          Text(
            'Your Selections (${betSlipData.length})',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),

          SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: betSlipData.length,
            separatorBuilder: (context, index) => SizedBox(height: 12),
            itemBuilder: (context, index) {
              final bet = betSlipData[index];
              return BetCardWidget(
                bet: bet,
                onRemove: () => _removeBet(bet["id"] as String),
                onStakeChanged: (newStake) =>
                    _updateStake(bet["id"] as String, newStake),
              );
            },
          ),

          SizedBox(height: 24),

          QuickStakeButtonsWidget(
            onStakeSelected: _applyQuickStake,
            accountBalance: accountBalance,
          ),

          SizedBox(height: 24),

          _buildTotalsCard(),

          if (errorMessage != null) ...[
            SizedBox(height: 16),
            _buildErrorMessage(),
          ],

          SizedBox(height: 100), // Space for bottom section
        ],
      ),
    );
  }

  Widget _buildTotalsCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Stake',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              Text(
                '₹${totalStake.toStringAsFixed(2)}',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Potential Winnings',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              Text(
                '₹${potentialWinnings.toStringAsFixed(2)}',
                style: AppTheme.successTextStyle(
                  isLight: true,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (selectedBetType == 'Multiple') ...[
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Combined Odds',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  (potentialWinnings / totalStake).toStringAsFixed(2),
                  style: AppTheme.dataTextStyle(
                    isLight: true,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'error',
            color: AppTheme.lightTheme.colorScheme.error,
            size: 20,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              errorMessage!,
              style: AppTheme.errorTextStyle(
                isLight: true,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (totalStake > accountBalance * 0.5)
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Please gamble responsibly',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _canPlaceBet() && !isLoading ? _placeBets : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _canPlaceBet()
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline,
                ),
                child: isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Text(
                        'Place Bet - ₹${totalStake.toStringAsFixed(2)}',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
