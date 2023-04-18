// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;
import 'package:portfolio/nft_detail.dart' as _i4;
import 'package:portfolio/portfolio.dart' as _i6;

import '../presentation/auth/restore_existing_account_screen.dart' as _i3;
import '../presentation/auth/seed_recovery_screen.dart' as _i2;
import '../presentation/main/main_router.dart' as _i5;
import '../presentation/presentation.dart' as _i1;

class AppRouter extends _i7.RootStackRouter {
  AppRouter([_i8.GlobalKey<_i8.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.SplashScreen(),
      );
    },
    SignupRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.SignupScreen(),
      );
    },
    OnboardingRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.OnboardingScreen(),
      );
    },
    SeedRecoveryRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.SeedRecoveryScreen(),
      );
    },
    RestoreExistingAccountRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.RestoreExistingAccountScreen(),
      );
    },
    NFTCollectionImages.name: (routeData) {
      final args = routeData.argsAs<NFTCollectionImagesArgs>();
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i4.NFTCollectionImages(
          key: args.key,
          data: args.data,
          chain: args.chain,
        ),
      );
    },
    MainRouter.name: (routeData) {
      final args = routeData.argsAs<MainRouterArgs>(
          orElse: () => const MainRouterArgs());
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i5.MainPageHostScreen(key: args.key),
      );
    },
    HomeRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.HomeScreen(),
      );
    },
    SearchRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.SearchScreen(),
      );
    },
    PortfolioRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i6.PortfolioScreen(),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.SettingsScreen(),
      );
    },
    MessageRoute.name: (routeData) {
      final args = routeData.argsAs<MessageRouteArgs>(
          orElse: () => const MessageRouteArgs());
      return _i7.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i1.MessageScreen(key: args.key),
      );
    },
  };

  @override
  List<_i7.RouteConfig> get routes => [
        _i7.RouteConfig(
          SplashRoute.name,
          path: '/',
        ),
        _i7.RouteConfig(
          SignupRoute.name,
          path: '/signup',
        ),
        _i7.RouteConfig(
          OnboardingRoute.name,
          path: '/confirmEmail',
        ),
        _i7.RouteConfig(
          SeedRecoveryRoute.name,
          path: '/seedRecovery',
        ),
        _i7.RouteConfig(
          RestoreExistingAccountRoute.name,
          path: '/restoreExistingAccount',
        ),
        _i7.RouteConfig(
          NFTCollectionImages.name,
          path: '/portfolioDetails',
        ),
        _i7.RouteConfig(
          MainRouter.name,
          path: '/main',
          children: [
            _i7.RouteConfig(
              HomeRoute.name,
              path: '',
              parent: MainRouter.name,
            ),
            _i7.RouteConfig(
              SearchRoute.name,
              path: 'search',
              parent: MainRouter.name,
            ),
            _i7.RouteConfig(
              PortfolioRoute.name,
              path: 'notification',
              parent: MainRouter.name,
            ),
            _i7.RouteConfig(
              SettingsRoute.name,
              path: 'settings',
              parent: MainRouter.name,
            ),
            _i7.RouteConfig(
              MessageRoute.name,
              path: 'message',
              parent: MainRouter.name,
            ),
          ],
        ),
      ];
}

/// generated route for
/// [_i1.SplashScreen]
class SplashRoute extends _i7.PageRouteInfo<void> {
  const SplashRoute()
      : super(
          SplashRoute.name,
          path: '/',
        );

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i1.SignupScreen]
class SignupRoute extends _i7.PageRouteInfo<void> {
  const SignupRoute()
      : super(
          SignupRoute.name,
          path: '/signup',
        );

  static const String name = 'SignupRoute';
}

/// generated route for
/// [_i1.OnboardingScreen]
class OnboardingRoute extends _i7.PageRouteInfo<void> {
  const OnboardingRoute()
      : super(
          OnboardingRoute.name,
          path: '/confirmEmail',
        );

  static const String name = 'OnboardingRoute';
}

/// generated route for
/// [_i2.SeedRecoveryScreen]
class SeedRecoveryRoute extends _i7.PageRouteInfo<void> {
  const SeedRecoveryRoute()
      : super(
          SeedRecoveryRoute.name,
          path: '/seedRecovery',
        );

  static const String name = 'SeedRecoveryRoute';
}

/// generated route for
/// [_i3.RestoreExistingAccountScreen]
class RestoreExistingAccountRoute extends _i7.PageRouteInfo<void> {
  const RestoreExistingAccountRoute()
      : super(
          RestoreExistingAccountRoute.name,
          path: '/restoreExistingAccount',
        );

  static const String name = 'RestoreExistingAccountRoute';
}

/// generated route for
/// [_i4.NFTCollectionImages]
class NFTCollectionImages extends _i7.PageRouteInfo<NFTCollectionImagesArgs> {
  NFTCollectionImages({
    _i8.Key? key,
    required dynamic data,
    required String chain,
  }) : super(
          NFTCollectionImages.name,
          path: '/portfolioDetails',
          args: NFTCollectionImagesArgs(
            key: key,
            data: data,
            chain: chain,
          ),
        );

  static const String name = 'NFTCollectionImages';
}

class NFTCollectionImagesArgs {
  const NFTCollectionImagesArgs({
    this.key,
    required this.data,
    required this.chain,
  });

  final _i8.Key? key;

  final dynamic data;

  final String chain;

  @override
  String toString() {
    return 'NFTCollectionImagesArgs{key: $key, data: $data, chain: $chain}';
  }
}

/// generated route for
/// [_i5.MainPageHostScreen]
class MainRouter extends _i7.PageRouteInfo<MainRouterArgs> {
  MainRouter({
    _i8.Key? key,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          MainRouter.name,
          path: '/main',
          args: MainRouterArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'MainRouter';
}

class MainRouterArgs {
  const MainRouterArgs({this.key});

  final _i8.Key? key;

  @override
  String toString() {
    return 'MainRouterArgs{key: $key}';
  }
}

/// generated route for
/// [_i1.HomeScreen]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i1.SearchScreen]
class SearchRoute extends _i7.PageRouteInfo<void> {
  const SearchRoute()
      : super(
          SearchRoute.name,
          path: 'search',
        );

  static const String name = 'SearchRoute';
}

/// generated route for
/// [_i6.PortfolioScreen]
class PortfolioRoute extends _i7.PageRouteInfo<void> {
  const PortfolioRoute()
      : super(
          PortfolioRoute.name,
          path: 'notification',
        );

  static const String name = 'PortfolioRoute';
}

/// generated route for
/// [_i1.SettingsScreen]
class SettingsRoute extends _i7.PageRouteInfo<void> {
  const SettingsRoute()
      : super(
          SettingsRoute.name,
          path: 'settings',
        );

  static const String name = 'SettingsRoute';
}

/// generated route for
/// [_i1.MessageScreen]
class MessageRoute extends _i7.PageRouteInfo<MessageRouteArgs> {
  MessageRoute({_i8.Key? key})
      : super(
          MessageRoute.name,
          path: 'message',
          args: MessageRouteArgs(key: key),
        );

  static const String name = 'MessageRoute';
}

class MessageRouteArgs {
  const MessageRouteArgs({this.key});

  final _i8.Key? key;

  @override
  String toString() {
    return 'MessageRouteArgs{key: $key}';
  }
}
