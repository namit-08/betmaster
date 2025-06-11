import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/featured_games_carousel_widget.dart';
import './widgets/game_category_chips_widget.dart';
import './widgets/game_grid_widget.dart';
import './widgets/live_casino_section_widget.dart';
import './widgets/progressive_jackpot_widget.dart';

class CasinoGamesHub extends StatefulWidget {
  const CasinoGamesHub({super.key});

  @override
  _CasinoGamesHubState createState() => _CasinoGamesHubState();
}

class _CasinoGamesHubState extends State<CasinoGamesHub>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  String _selectedCategory = 'All';
  bool _isSearchActive = false;
  final List<String> _recentSearches = ['Blackjack', 'Roulette', 'Slots'];

  // Mock data for casino games
  final List<Map<String, dynamic>> _featuredGames = [
    {
      "id": 1,
      "name": "Mega Fortune Dreams",
      "provider": "NetEnt",
      "image":
          "https://images.unsplash.com/photo-1596838132731-3301c3fd4317?w=400&h=300&fit=crop",
      "jackpot": "\$2,847,392",
      "category": "Jackpots",
      "isNew": false,
      "isFavorite": false,
      "rtp": "96.4%",
      "volatility": "High"
    },
    {
      "id": 2,
      "name": "Lightning Roulette",
      "provider": "Evolution Gaming",
      "image":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop",
      "jackpot": null,
      "category": "Live Casino",
      "isNew": true,
      "isFavorite": true,
      "rtp": "97.3%",
      "volatility": "Medium"
    },
    {
      "id": 3,
      "name": "Book of Dead",
      "provider": "Play'n GO",
      "image":
          "https://images.unsplash.com/photo-1606092195730-5d7b9af1efc5?w=400&h=300&fit=crop",
      "jackpot": null,
      "category": "Slots",
      "isNew": false,
      "isFavorite": false,
      "rtp": "96.2%",
      "volatility": "High"
    }
  ];

  final List<Map<String, dynamic>> _allGames = [
    {
      "id": 4,
      "name": "Starburst",
      "provider": "NetEnt",
      "image":
          "https://images.unsplash.com/photo-1518611012118-696072aa579a?w=400&h=300&fit=crop",
      "jackpot": null,
      "category": "Slots",
      "isNew": false,
      "isFavorite": true,
      "rtp": "96.1%",
      "volatility": "Low",
      "hasDemo": true
    },
    {
      "id": 5,
      "name": "Blackjack Classic",
      "provider": "Evolution Gaming",
      "image":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop",
      "jackpot": null,
      "category": "Table Games",
      "isNew": false,
      "isFavorite": false,
      "rtp": "99.4%",
      "volatility": "Low",
      "hasDemo": true
    },
    {
      "id": 6,
      "name": "Gonzo's Quest",
      "provider": "NetEnt",
      "image":
          "https://images.unsplash.com/photo-1596838132731-3301c3fd4317?w=400&h=300&fit=crop",
      "jackpot": null,
      "category": "Slots",
      "isNew": false,
      "isFavorite": false,
      "rtp": "95.9%",
      "volatility": "Medium",
      "hasDemo": true
    },
    {
      "id": 7,
      "name": "Dream Catcher",
      "provider": "Evolution Gaming",
      "image":
          "https://images.unsplash.com/photo-1606092195730-5d7b9af1efc5?w=400&h=300&fit=crop",
      "jackpot": null,
      "category": "Live Casino",
      "isNew": true,
      "isFavorite": false,
      "rtp": "96.6%",
      "volatility": "Medium",
      "hasDemo": false
    },
    {
      "id": 8,
      "name": "Mega Moolah",
      "provider": "Microgaming",
      "image":
          "https://images.unsplash.com/photo-1518611012118-696072aa579a?w=400&h=300&fit=crop",
      "jackpot": "\$18,915,872",
      "category": "Jackpots",
      "isNew": false,
      "isFavorite": true,
      "rtp": "88.1%",
      "volatility": "High",
      "hasDemo": false
    },
    {
      "id": 9,
      "name": "European Roulette",
      "provider": "NetEnt",
      "image":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop",
      "jackpot": null,
      "category": "Table Games",
      "isNew": false,
      "isFavorite": false,
      "rtp": "97.3%",
      "volatility": "Medium",
      "hasDemo": true
    }
  ];

  final List<String> _categories = [
    'All',
    'Slots',
    'Table Games',
    'Live Casino',
    'Jackpots',
    'New Games'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this, initialIndex: 2);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredGames {
    List<Map<String, dynamic>> filtered = List.from(_allGames);

    if (_selectedCategory != 'All') {
      if (_selectedCategory == 'New Games') {
        filtered = filtered.where((game) => game['isNew'] == true).toList();
      } else {
        filtered = filtered
            .where((game) => game['category'] == _selectedCategory)
            .toList();
      }
    }

    if (_searchController.text.isNotEmpty) {
      filtered = filtered
          .where((game) =>
              (game['name'] as String)
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              (game['provider'] as String)
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  void _toggleFavorite(int gameId) {
    setState(() {
      final gameIndex = _allGames.indexWhere((game) => game['id'] == gameId);
      if (gameIndex != -1) {
        _allGames[gameIndex]['isFavorite'] =
            !(_allGames[gameIndex]['isFavorite'] as bool);
      }
    });
  }

  void _launchGame(Map<String, dynamic> game) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              SizedBox(height: 16),
              Text(
                'Loading ${game['name']}...',
                style: AppTheme.lightTheme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );

    // Simulate game loading
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${game['name']} launched successfully!'),
            backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          ),
        );
      }
    });
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      // Simulate updated jackpot amounts
      for (var game in _allGames) {
        if (game['jackpot'] != null) {
          final currentAmount = int.parse(
              (game['jackpot'] as String).replaceAll(RegExp(r'[^\d]'), ''));
          final newAmount =
              currentAmount + (100 + (currentAmount * 0.001).round());
          game['jackpot'] =
              '\$${newAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Sticky Header with Search and Filter
            Container(
              color: AppTheme.lightTheme.colorScheme.surface,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _isSearchActive = value.isNotEmpty;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search games...',
                        prefixIcon: CustomIconWidget(
                          iconName: 'search',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        suffixIcon: _isSearchActive
                            ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _isSearchActive = false;
                                  });
                                },
                                icon: CustomIconWidget(
                                  iconName: 'clear',
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                              )
                            : CustomIconWidget(
                                iconName: 'tune',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),

                  // Recent Searches (when search is active)
                  if (_isSearchActive && _searchController.text.isEmpty) ...[
                    SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        spacing: 8,
                        children: _recentSearches
                            .map((search) => ActionChip(
                                  label: Text(search),
                                  onPressed: () {
                                    _searchController.text = search;
                                    setState(() {});
                                  },
                                  backgroundColor: AppTheme
                                      .lightTheme.colorScheme.tertiary
                                      .withValues(alpha: 0.1),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppTheme.lightTheme.colorScheme.primary,
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    // Featured Games Carousel
                    if (!_isSearchActive) ...[
                      SliverToBoxAdapter(
                        child: FeaturedGamesCarouselWidget(
                          featuredGames: _featuredGames,
                          onGameTap: _launchGame,
                        ),
                      ),

                      // Progressive Jackpots
                      SliverToBoxAdapter(
                        child: ProgressiveJackpotWidget(
                          jackpotGames: _allGames
                              .where((game) => game['jackpot'] != null)
                              .toList(),
                        ),
                      ),

                      // Live Casino Section
                      SliverToBoxAdapter(
                        child: LiveCasinoSectionWidget(
                          liveCasinoGames: _allGames
                              .where(
                                  (game) => game['category'] == 'Live Casino')
                              .toList(),
                          onGameTap: _launchGame,
                        ),
                      ),
                    ],

                    // Category Chips
                    SliverToBoxAdapter(
                      child: GameCategoryChipsWidget(
                        categories: _categories,
                        selectedCategory: _selectedCategory,
                        onCategorySelected: (category) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      ),
                    ),

                    // Games Grid
                    SliverToBoxAdapter(
                      child: GameGridWidget(
                        games: _filteredGames,
                        onGameTap: _launchGame,
                        onFavoriteTap: _toggleFavorite,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: 2, // Casino tab active
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
          unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          items: [
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'sports_soccer',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'sports_soccer',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              label: 'Sports',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'live_tv',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'live_tv',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              label: 'Live',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'casino',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'casino',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              label: 'Casino',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'receipt',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'receipt',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              label: 'Bet Slip',
            ),
            BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              activeIcon: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              label: 'Profile',
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.pushNamed(context, '/sports-dashboard');
                break;
              case 1:
                Navigator.pushNamed(context, '/live-betting-screen');
                break;
              case 2:
                // Already on casino hub
                break;
              case 3:
                Navigator.pushNamed(context, '/bet-slip-management');
                break;
              case 4:
                Navigator.pushNamed(context, '/registration-screen');
                break;
            }
          },
        ),
      ),
    );
  }
}
