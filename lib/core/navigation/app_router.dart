import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants.dart';
import '../theme/app_animations.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/payment/presentation/pages/payment_screen.dart';
import '../../features/payment/presentation/pages/recipient_selection_page.dart';
import '../../features/payment/presentation/pages/transaction_receipt_page.dart';
import '../../features/cards/presentation/pages/cards_page.dart';
import '../../features/bundles/presentation/pages/bundles_page.dart';
import '../../features/transactions/presentation/pages/transactions_page.dart';
import '../../features/account/presentation/pages/account_page.dart';
import 'package:mobilemoney/features/shop/presentation/pages/shop_page.dart';
import 'package:mobilemoney/features/shop/presentation/pages/cart_page.dart';

// Helper for Main Tab Transitions (Fade)
CustomTransitionPage<T> buildMainPage<T>({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: AppAnimations.entranceCurve).animate(animation),
        child: child,
      );
    },
    transitionDuration: AppAnimations.normal,
  );
}

// Helper for Secondary Page Transitions (Slide-up + Fade)
CustomTransitionPage<T> buildSecondaryPage<T>({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideAnimation = Tween<Offset>(
        begin: AppAnimations.slideUpStart,
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: AppAnimations.entranceCurve,
      ));

      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: slideAnimation,
          child: child,
        ),
      );
    },
    transitionDuration: AppAnimations.normal,
  );
}

final routerConfig = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      pageBuilder: (context, state) => buildMainPage(
        state: state,
        child: const HomePage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.shop,
      pageBuilder: (context, state) => buildMainPage(
        state: state,
        child: const ShopPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.cart,
      pageBuilder: (context, state) => buildSecondaryPage(
        state: state,
        child: const CartPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.auth,
      pageBuilder: (context, state) => buildSecondaryPage(
        state: state,
        child: const AuthPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.cards,
      pageBuilder: (context, state) => buildMainPage(
        state: state,
        child: const CardsPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.recipientSelection,
      pageBuilder: (context, state) => buildSecondaryPage(
        state: state,
        child: const RecipientSelectionPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.transactionReceipt,
      pageBuilder: (context, state) {
        final details = state.extra as Map<String, dynamic>;
        return buildSecondaryPage(
          state: state,
          child: TransactionReceiptPage(transactionDetails: details),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.payment,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, String>?;
        return buildSecondaryPage(
          state: state,
          child: PaymentScreen(
            recipientName: extra?['name'],
            recipientNumber: extra?['number'],
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.bundles,
      pageBuilder: (context, state) => buildSecondaryPage(
        state: state,
        child: const BundlesPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.transactions,
      pageBuilder: (context, state) => buildSecondaryPage(
        state: state,
        child: const TransactionsPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.account,
      pageBuilder: (context, state) => buildMainPage(
        state: state,
        child: const AccountPage(),
      ),
    ),
  ],
);
