import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/bet_slip_drawer_widget.dart';
import './widgets/betting_markets_widget.dart';
import './widgets/match_header_widget.dart';
import './widgets/match_stats_widget.dart';
import './widgets/quick_bet_widget.dart';

class LiveBettingScreen extends StatefulWidget {
  const LiveBettingScreen({super.key});

  @override
  _LiveBettingScreenState createState() => _LiveBettingScreenState();
}

class _LiveBettingScreenState extends State<LiveBettingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final bool _isHeaderCollapsed = false;
  bool _isBetSlipVisible = false;
  bool _isLoading = false;
  String _selectedMarket = 'Match Result';

  final List<String> _bettingMarkets = [
    'Match Result',
    'Goals',
    'Cards',
    'Corners'
  ];

  // Mock live match data
  final Map<String, dynamic> _liveMatchData = {
    "matchId": "live_001",
    "homeTeam": "Manchester United",
    "awayTeam": "Liverpool",
    "homeScore": 2,
    "awayScore": 1,
    "matchTime": "78'",
    "status": "LIVE",
    "competition": "Premier League",
    "stadium": "Old Trafford",
    "homeTeamLogo":
        "https://logos-world.net/wp-content/uploads/2020/06/Manchester-United-Logo.png",
    "awayTeamLogo":
        "https://logos-world.net/wp-content/uploads/2020/06/Liverpool-Logo.png",
    "lastUpdate": "2024-01-15T15:30:00Z",
    "events": [
      {
        "time": "15'",
        "type": "GOAL",
        "team": "home",
        "player": "Marcus Rashford",
        "description": "Goal from penalty"
      },
      {
        "time": "34'",
        "type": "GOAL",
        "team": "away",
        "player": "Mohamed Salah",
        "description": "Goal from close range"
      },
      {
        "time": "67'",
        "type": "GOAL",
        "team": "home",
        "player": "Bruno Fernandes",
        "description": "Goal from free kick"
      }
    ]
  };

  // Mock betting odds with live updates
  final Map<String, dynamic> _bettingOdds = {
    "Match Result": {
      "homeWin": {"odds": 2.10, "change": "up"},
      "draw": {"odds": 3.40, "change": "down"},
      "awayWin": {"odds": 3.20, "change": "stable"}
    },
    "Goals": {
      "over2_5": {"odds": 1.85, "change": "up"},
      "under2_5": {"odds": 1.95, "change": "down"},
      "over3_5": {"odds": 2.75, "change": "stable"},
      "under3_5": {"odds": 1.44, "change": "stable"}
    },
    "Cards": {
      "over3_5": {"odds": 1.90, "change": "up"},
      "under3_5": {"odds": 1.88, "change": "down"},
      "redCard": {"odds": 4.50, "change": "stable"}
    },
    "Corners": {
      "over8_5": {"odds": 1.75, "change": "up"},
      "under8_5": {"odds": 2.05, "change": "down"},
      "over10_5": {"odds": 2.30, "change": "stable"}
    }
  };

  // Mock bet slip data
  final List<Map<String, dynamic>> _betSlipItems = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _bettingMarkets.length, vsync: this);
    _simulateLiveUpdates();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _simulateLiveUpdates() {
    // Simulate live odds updates every 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          // Randomly update odds changes
          _updateOddsChanges();
        });
        _simulateLiveUpdates();
      }
    });
  }

  void _updateOddsChanges() {
    final changes = ['up', 'down', 'stable'];
    _bettingOdds.forEach((market, odds) {
      (odds as Map<String, dynamic>).forEach((key, value) {
        if (value is Map<String, dynamic>) {
          value['change'] = (changes..shuffle()).first;
        }
      });
    });
  }

  void _addToBetSlip(String market, String selection, double odds) {
    HapticFeedback.lightImpact();
    setState(() {
      _betSlipItems.add({
        'market': market,
        'selection': selection,
        'odds': odds,
        'stake': 0.0,
        'potentialWin': 0.0,
      });
      _isBetSlipVisible = true;
    });
  }

  void _removeBetSlipItem(int index) {
    setState(() {
      _betSlipItems.removeAt(index);
      if (_betSlipItems.isEmpty) {
        _isBetSlipVisible = false;
      }
    });
  }

  Future<void> _refreshMatchData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      // Update match time
      int currentTime =
          int.parse(_liveMatchData['matchTime'].replaceAll("'", ""));
      _liveMatchData['matchTime'] = "${currentTime + 1}'";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshMatchData,
            color: AppTheme.lightTheme.colorScheme.secondary,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: _isHeaderCollapsed ? 80.0 : 200.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  leading: IconButton(
                    icon: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 24,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    IconButton(
                      icon: CustomIconWidget(
                        iconName: 'refresh',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 24,
                      ),
                      onPressed: _refreshMatchData,
                    ),
                    IconButton(
                      icon: Stack(
                        children: [
                          CustomIconWidget(
                            iconName: 'shopping_cart',
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            size: 24,
                          ),
                          if (_betSlipItems.isNotEmpty)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.lightTheme.colorScheme.tertiary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '${_betSlipItems.length}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                      onPressed: () {
                        setState(() {
                          _isBetSlipVisible = !_isBetSlipVisible;
                        });
                      },
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: MatchHeaderWidget(
                      matchData: _liveMatchData,
                      isCollapsed: _isHeaderCollapsed,
                    ),
                    collapseMode: CollapseMode.parallax,
                  ),
                  onStretchTrigger: () async {
                    await _refreshMatchData();
                  },
                ),
                SliverToBoxAdapter(
                  child: Container(
                    color: AppTheme.lightTheme.scaffoldBackgroundColor,
                    child: Column(
                      children: [
                        // Live status indicator
                        Container(
                          width: double.infinity,
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          color: AppTheme.lightTheme.colorScheme.tertiary
                              .withValues(alpha: 0.1),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.lightTheme.colorScheme.tertiary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'LIVE - Odds updating in real-time',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.tertiary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Betting Markets Tabs
                        Container(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          child: TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            onTap: (index) {
                              setState(() {
                                _selectedMarket = _bettingMarkets[index];
                              });
                            },
                            tabs: _bettingMarkets
                                .map((market) => Tab(text: market))
                                .toList(),
                          ),
                        ),

                        // Quick Bet Section
                        QuickBetWidget(
                          odds: _bettingOdds[_selectedMarket] ?? {},
                          onBetSelected: _addToBetSlip,
                          selectedMarket: _selectedMarket,
                        ),

                        SizedBox(height: 16),

                        // Main Content
                        SizedBox(
                          height: 60.h,
                          child: TabBarView(
                            controller: _tabController,
                            children: _bettingMarkets.map((market) {
                              return BettingMarketsWidget(
                                market: market,
                                odds: _bettingOdds[market] ?? {},
                                onBetSelected: _addToBetSlip,
                              );
                            }).toList(),
                          ),
                        ),

                        SizedBox(height: 16),

                        // Match Statistics
                        MatchStatsWidget(
                          matchData: _liveMatchData,
                        ),

                        SizedBox(height: 100), // Space for bet slip drawer
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
            ),

          // Bet Slip Drawer
          if (_isBetSlipVisible)
            BetSlipDrawerWidget(
              betSlipItems: _betSlipItems,
              onRemoveItem: _removeBetSlipItem,
              onClose: () {
                setState(() {
                  _isBetSlipVisible = false;
                });
              },
            ),
        ],
      ),
    );
  }
}
