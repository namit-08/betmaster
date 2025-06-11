import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class FeaturedGamesCarouselWidget extends StatefulWidget {
  final List<Map<String, dynamic>> featuredGames;
  final Function(Map<String, dynamic>) onGameTap;

  const FeaturedGamesCarouselWidget({
    super.key,
    required this.featuredGames,
    required this.onGameTap,
  });

  @override
  _FeaturedGamesCarouselWidgetState createState() =>
      _FeaturedGamesCarouselWidgetState();
}

class _FeaturedGamesCarouselWidgetState
    extends State<FeaturedGamesCarouselWidget> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Auto-advance carousel
    Future.delayed(Duration(seconds: 3), _autoAdvance);
  }

  void _autoAdvance() {
    if (mounted && widget.featuredGames.isNotEmpty) {
      final nextIndex = (_currentIndex + 1) % widget.featuredGames.length;
      _pageController.animateToPage(
        nextIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      Future.delayed(Duration(seconds: 3), _autoAdvance);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.featuredGames.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Featured Games',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                CustomIconWidget(
                  iconName: 'star',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 24,
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: widget.featuredGames.length,
              itemBuilder: (context, index) {
                final game = widget.featuredGames[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: () => widget.onGameTap(game),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.lightTheme.colorScheme.shadow,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            // Background Image
                            CustomImageWidget(
                              imageUrl: game['image'] as String,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),

                            // Gradient Overlay
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.7),
                                  ],
                                ),
                              ),
                            ),

                            // Content
                            Positioned(
                              bottom: 16,
                              left: 16,
                              right: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          game['name'] as String,
                                          style: AppTheme
                                              .lightTheme.textTheme.titleLarge
                                              ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (game['isNew'] == true) ...[
                                        SizedBox(width: 8),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppTheme.lightTheme
                                                .colorScheme.tertiary,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            'NEW',
                                            style: AppTheme
                                                .lightTheme.textTheme.labelSmall
                                                ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        game['provider'] as String,
                                        style: AppTheme
                                            .lightTheme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: Colors.white
                                              .withValues(alpha: 0.8),
                                        ),
                                      ),
                                      if (game['jackpot'] != null)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppTheme
                                                .lightTheme.colorScheme.tertiary
                                                .withValues(alpha: 0.9),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            game['jackpot'] as String,
                                            style: AppTheme.lightTheme.textTheme
                                                .labelMedium
                                                ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Play Button
                            Positioned(
                              top: 16,
                              right: 16,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: IconButton(
                                  onPressed: () => widget.onGameTap(game),
                                  icon: CustomIconWidget(
                                    iconName: 'play_arrow',
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 12),

          // Page Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.featuredGames.length,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: _currentIndex == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
