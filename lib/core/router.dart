import 'package:auto_route/auto_route.dart';
import 'package:portfolio/portfolio.dart';
import 'package:portfolio/nft_detail.dart';
import 'package:test_project/presentation/auth/restore_existing_account_screen.dart';
import '../presentation/auth/seed_recovery_screen.dart';
import '../presentation/main/main_router.dart';
import '../presentation/presentation.dart';

@MaterialAutoRouter(replaceInRouteName: 'Screen,Route', routes: [
  AutoRoute(path: '/', page: SplashScreen),
  AutoRoute(path: '/signup', page: SignupScreen),
  AutoRoute(path: '/confirmEmail', page: OnboardingScreen),
  AutoRoute(path: '/seedRecovery', page: SeedRecoveryScreen),
  AutoRoute(path: '/restoreExistingAccount', page: RestoreExistingAccountScreen),
  AutoRoute(path: '/portfolioDetails', page: NFTCollectionImages),
  
  AutoRoute(
      path: '/main',
      name: 'MainRouter',
      page: MainPageHostScreen,
      children: [
        AutoRoute(path: '', page: HomeScreen),
        AutoRoute(path: 'search', page: SearchScreen),
        AutoRoute(path: 'notification', page: PortfolioScreen),
        AutoRoute(path: 'settings', page: SettingsScreen),
        AutoRoute(path: 'message', page: MessageScreen),
      ]),
])
class $AppRouter {}
