import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import '../security/auth_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../../features/accounts/account_detail_screen.dart';
import '../../features/accounts/edit_account_screen.dart';
import '../../features/accounts/service_accounts_screen.dart';
import '../../features/generator/generator_screen.dart';
import '../../features/lock/lock_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/services/edit_service_screen.dart';
import '../../features/services/services_screen.dart';
import '../../features/settings/settings_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/services',
    redirect: (context, state) {
      final isLocked = authState.isLocked;
      final isGoingToLock = state.matchedLocation == '/lock';

      if (isLocked && !isGoingToLock) {
        return '/lock';
      }
      if (!isLocked && isGoingToLock) {
        return '/services';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/lock',
        builder: (context, state) => LockScreen(
          onSuccess: () => context.go('/services'),
        ),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/services/new',
        builder: (context, state) => const EditServiceScreen(),
      ),
      GoRoute(
        path: '/services/:id/edit',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return EditServiceScreen(serviceId: id);
        },
      ),
      GoRoute(
        path: '/services/:id/accounts',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ServiceAccountsScreen(serviceId: id);
        },
      ),
      GoRoute(
        path: '/accounts/new',
        builder: (context, state) {
          final serviceId = state.uri.queryParameters['serviceId'];
          return EditAccountScreen(initialServiceId: serviceId);
        },
      ),
      GoRoute(
        path: '/accounts/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return AccountDetailScreen(accountId: id);
        },
      ),
      GoRoute(
        path: '/accounts/:id/edit',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return EditAccountScreen(accountId: id);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: BrankasBottomNavBar(
              currentIndex: navigationShell.currentIndex,
              onTap: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/services',
                builder: (context, state) => const ServicesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/generator',
                builder: (context, state) => const GeneratorScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
