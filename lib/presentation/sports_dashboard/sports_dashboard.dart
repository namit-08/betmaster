import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/live_match_card_widget.dart';
import './widgets/match_card_widget.dart';
import './widgets/sports_filter_widget.dart';

class SportsDashboard extends StatefulWidget {
  const SportsDashboard({super.key});

  @override
  _SportsDashboardState createState() => _SportsDashboardState();
}

class _SportsDashboardState extends State<SportsDashboard>
    with TickerProviderStateMixin {
  final int _selectedTabIndex = 0;
  String _selectedSport = 'All';
  bool _isRefreshing = false;
  int _betSlipCount = 3;
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _mockMatches = [
    {
      "id": 1,
      "homeTeam": "Manchester United",
      "awayTeam": "Liverpool",
      "homeOdds": "2.10",
      "drawOdds": "3.40",
      "awayOdds": "3.20",
      "isLive": true,
      "score": "1-0",
      "time": "45'",
      "sport": "Football",
      "league": "Premier League",
      "isFavorite": false,
      "image":
          "https://images.pexels.com/photos/274506/pexels-photo-274506.jpeg"
    },
    {
      "id": 2,
      "homeTeam": "Lakers",
      "awayTeam": "Warriors",
      "homeOdds": "1.85",
      "drawOdds": null,
      "awayOdds": "1.95",
      "isLive": false,
      "score": null,
      "time": "20:30",
      "sport": "Basketball",
      "league": "NBA",
      "isFavorite": true,
      "image":
          "https://images.pexels.com/photos/1752757/pexels-photo-1752757.jpeg"
    },
    {
      "id": 3,
      "homeTeam": "Real Madrid",
      "awayTeam": "Barcelona",
      "homeOdds": "2.45",
      "drawOdds": "3.10",
      "awayOdds": "2.90",
      "isLive": true,
      "score": "2-1",
      "time": "78'",
      "sport": "Football",
      "league": "La Liga",
      "isFavorite": false,
      "image":
          "https://images.pexels.com/photos/114296/pexels-photo-114296.jpeg"
    },
    {
      "id": 4,
      "homeTeam": "Djokovic",
      "awayTeam": "Nadal",
      "homeOdds": "1.65",
      "drawOdds": null,
      "awayOdds": "2.25",
      "isLive": false,
      "score": null,
      "time": "15:00",
      "sport": "Tennis",
      "league": "ATP Masters",
      "isFavorite": true,
      "image":
          "https://images.pexels.com/photos/209977/pexels-photo-209977.jpeg"
    },
    {
      "id": 5,
      "homeTeam": "Chiefs",
      "awayTeam": "Patriots",
      "homeOdds": "1.75",
      "drawOdds": null,
      "awayOdds": "2.05",
      "isLive": false,
      "score": null,
      "time": "Tomorrow 19:00",
      "sport": "American Football",
      "league": "NFL",
      "isFavorite": false,
      "image":
          "https://images.pexels.com/photos/1618200/pexels-photo-1618200.jpeg"
    }
  ];

  final List<String> _sports = [
    'All',
    'Football',
    'Basketball',
    'Tennis',
    'American Football',
    'Baseball',
    'Hockey'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredMatches {
    if (_selectedSport == 'All') {
      return _mockMatches;
    }
    return _mockMatches
        .where((match) => (match['sport'] as String) == _selectedSport)
        .toList();
  }

  List<Map<String, dynamic>> get _liveMatches {
    return _filteredMatches.where((match) => match['isLive'] == true).toList();
  }

  List<Map<String, dynamic>> get _upcomingMatches {
    return _filteredMatches.where((match) => match['isLive'] == false).toList();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Odds updated successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onSportSelected(String sport) {
    setState(() {
      _selectedSport = sport;
    });
  }

  void _onMatchTap(Map<String, dynamic> match) {
    Navigator.pushNamed(context, '/live-betting-screen');
  }

  void _onMatchLongPress(Map<String, dynamic> match) {
    setState(() {
      _betSlipCount++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Added ${match['homeTeam']} vs ${match['awayTeam']} to bet slip'),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            Navigator.pushNamed(context, '/bet-slip-management');
          },
        ),
      ),
    );
  }

  void _toggleFavorite(Map<String, dynamic> match) {
    setState(() {
      match['isFavorite'] = !match['isFavorite'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSportsFilter(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: AppTheme.lightTheme.colorScheme.secondary,
                child: CustomScrollView(
                  slivers: [
                    if (_liveMatches.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: _buildSectionHeader(
                            'Live Now', Icons.circle, Colors.red),
                      ),
                      SliverToBoxAdapter(
                        child: _buildLiveMatchesSection(),
                      ),
                    ],
                    if (_upcomingMatches.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: _buildSectionHeader(
                            'Starting Soon',
                            Icons.schedule,
                            AppTheme.lightTheme.colorScheme.secondary),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final match = _upcomingMatches[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 1.h),
                              child: MatchCardWidget(
                                match: match,
                                onTap: () => _onMatchTap(match),
                                onLongPress: () => _onMatchLongPress(match),
                                onFavoriteToggle: () => _toggleFavorite(match),
                              ),
                            );
                          },
                          childCount: _upcomingMatches.length,
                        ),
                      ),
                    ],
                    if (_filteredMatches.isEmpty)
                      SliverFillRemaining(
                        child: _buildEmptyState(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _betSlipCount > 0 ? _buildBetSlipFAB() : null,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
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
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search matches, teams...',
                      prefixIcon: CustomIconWidget(
                        iconName: 'search',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Container(
                height: 6.h,
                width: 6.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {
                    // Show filter options
                  },
                  icon: CustomIconWidget(
                    iconName: 'tune',
                    color: AppTheme.lightTheme.colorScheme.onSecondary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSportsFilter() {
    return Container(
      height: 8.h,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: _sports.length,
        itemBuilder: (context, index) {
          final sport = _sports[index];
          return Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: SportsFilterWidget(
              sport: sport,
              isSelected: _selectedSport == sport,
              onTap: () => _onSportSelected(sport),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color iconColor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: icon.toString().split('.').last,
            color: iconColor,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacer(),
          TextButton(
            onPressed: () {},
            child: Text(
              'View All',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveMatchesSection() {
    return SizedBox(
      height: 25.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: _liveMatches.length,
        itemBuilder: (context, index) {
          final match = _liveMatches[index];
          return Padding(
            padding: EdgeInsets.only(right: 3.w),
            child: SizedBox(
              width: 80.w,
              child: LiveMatchCardWidget(
                match: match,
                onTap: () => _onMatchTap(match),
                onLongPress: () => _onMatchLongPress(match),
                onFavoriteToggle: () => _toggleFavorite(match),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'sports_soccer',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'No matches available',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Try selecting a different sport or check back later',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () => _onSportSelected('All'),
            child: Text('Explore All Sports'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      selectedItemColor: AppTheme.lightTheme.colorScheme.secondary,
      unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      elevation: 8,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'sports_soccer',
            color: AppTheme.lightTheme.colorScheme.secondary,
            size: 24,
          ),
          label: 'Sports',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'casino',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Casino',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'live_tv',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Live',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'receipt',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Bets',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            // Already on Sports
            break;
          case 1:
            Navigator.pushNamed(context, '/casino-games-hub');
            break;
          case 2:
            Navigator.pushNamed(context, '/live-betting-screen');
            break;
          case 3:
            Navigator.pushNamed(context, '/bet-slip-management');
            break;
          case 4:
            // Navigate to profile
            break;
        }
      },
    );
  }

  Widget _buildBetSlipFAB() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.pushNamed(context, '/bet-slip-management');
      },
      backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
      icon: CustomIconWidget(
        iconName: 'shopping_cart',
        color: AppTheme.lightTheme.colorScheme.onSecondary,
        size: 20,
      ),
      label: Text(
        'Bet Slip (\$_betSlipCount)',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
