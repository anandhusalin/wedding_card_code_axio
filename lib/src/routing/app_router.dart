import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/widgets/app_scaffold.dart';
import '../features/auth/presentation/auth_controller.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/wedding/presentation/create/create_wedding_screen.dart';
import '../features/wedding/presentation/my_weddings_screen.dart';
import '../features/rsvp/presentation/rsvp_list_screen.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _createNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'create');
final _myWeddingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'myWeddings');
final _profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    redirect: (context, state) {
      final isLoading = authState.isLoading;
      if (isLoading) return null;

      final isAuth = authState.valueOrNull != null;
      final isLoggingIn = state.uri.path == '/login';

      if (!isAuth && !isLoggingIn) return '/login';
      if (isAuth && isLoggingIn) return '/home';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _createNavigatorKey,
            routes: [
              GoRoute(
                path: '/create',
                builder: (context, state) => const CreateWeddingScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _myWeddingsNavigatorKey,
            routes: [
              GoRoute(
                path: '/my-weddings',
                builder: (context, state) => const MyWeddingsScreen(),
                routes: [
                  GoRoute(
                    path: ':id/rsvps',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return RsvpListScreen(weddingId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _profileNavigatorKey,
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
