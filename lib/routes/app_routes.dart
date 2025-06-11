import 'package:flutter/material.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/sports_dashboard/sports_dashboard.dart';
import '../presentation/bet_slip_management/bet_slip_management.dart';
import '../presentation/casino_games_hub/casino_games_hub.dart';
import '../presentation/live_betting_screen/live_betting_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String registrationScreen = '/registration-screen';
  static const String loginScreen = '/login-screen';
  static const String sportsDashboard = '/sports-dashboard';
  static const String liveBettingScreen = '/live-betting-screen';
  static const String casinoGamesHub = '/casino-games-hub';
  static const String betSlipManagement = '/bet-slip-management';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => RegistrationScreen(),
    registrationScreen: (context) => RegistrationScreen(),
    loginScreen: (context) => LoginScreen(),
    sportsDashboard: (context) => SportsDashboard(),
    liveBettingScreen: (context) => LiveBettingScreen(),
    casinoGamesHub: (context) => CasinoGamesHub(),
    betSlipManagement: (context) => BetSlipManagement(),
  };
}
