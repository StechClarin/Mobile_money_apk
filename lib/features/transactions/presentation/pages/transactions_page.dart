import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        backgroundColor: AppTheme.mtnYellow,
      ),
      body: const Center(
        child: Text('Transactions Feature Coming Soon'),
      ),
    );
  }
}
