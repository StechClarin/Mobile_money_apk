import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: AppTheme.mtnYellow,
      ),
      body: const Center(
        child: Text('Account Feature Coming Soon'),
      ),
    );
  }
}
