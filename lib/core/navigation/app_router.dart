
import 'package:go_router/go_router.dart';
import '../constants.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/payment/presentation/pages/payment_screen.dart';
import '../../features/cards/presentation/pages/cards_page.dart';
import '../../features/bundles/presentation/pages/bundles_page.dart';
import '../../features/transactions/presentation/pages/transactions_page.dart';
import '../../features/account/presentation/pages/account_page.dart';

final routerConfig = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.auth,
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      path: AppRoutes.cards,
      builder: (context, state) => const CardsPage(),
    ),
    GoRoute(
      path: AppRoutes.payment,
      builder: (context, state) => const PaymentScreen(),
    ),
    GoRoute(
      path: AppRoutes.bundles,
      builder: (context, state) => const BundlesPage(),
    ),
    GoRoute(
      path: AppRoutes.transactions,
      builder: (context, state) => const TransactionsPage(),
    ),
    GoRoute(
      path: AppRoutes.account,
      builder: (context, state) => const AccountPage(),
    ),
  ],
);
