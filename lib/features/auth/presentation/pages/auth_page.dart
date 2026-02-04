import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication'),
        backgroundColor: AppTheme.mtnYellow,
      ),
      body: const Center(
        child: Text('Auth Feature Coming Soon'),
      ),
    );
  }
}
