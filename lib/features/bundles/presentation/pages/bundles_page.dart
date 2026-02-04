import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class BundlesPage extends StatelessWidget {
  const BundlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bundles'),
        backgroundColor: AppTheme.mtnYellow,
      ),
      body: const Center(
        child: Text('Bundles Feature Coming Soon'),
      ),
    );
  }
}
