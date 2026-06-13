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

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // The router is built once and reused. Rebuilding it would reparent
  // StatefulShellRoute branches that already own GlobalKeys, producing
  // "Duplicate GlobalKey detected" errors when navigating.
  final refresh = _AuthRefresh(ref);

  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    refreshListenable: refresh,
    // Read the auth state at the time of the redirect call. Because the
    // redirect runs on every navigation, this gives us the freshest value
    // without rebuilding the entire router (and its shell branches) on
    // every AsyncValue emission.
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      if (auth.isLoading) return null;

      final isAuth = auth.valueOrNull != null;
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

  ref.onDispose(router.dispose);
  return router;
}

/// Bridges Riverpod auth state changes to GoRouter's refreshListenable,
/// so the router only refreshes (and re-runs its redirect) when auth
/// actually changes — not on every AsyncValue re-emission. This is what
/// prevents the StatefulShellRoute from being reparented mid-frame.
class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh(Ref ref) {
    _sub = ref.listen<AsyncValue<dynamic>>(
      authControllerProvider,
      (prev, next) {
        final wasAuthed = prev?.valueOrNull != null;
        final isAuthed = next.valueOrNull != null;
        if (wasAuthed != isAuthed) {
          notifyListeners();
        }
      },
    );
  }

  late final ProviderSubscription<AsyncValue<dynamic>> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}
