import 'package:flutter/material.dart';

class BoutiqueTab extends StatelessWidget {
  const BoutiqueTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      key: PageStorageKey('BoutiqueTab'),
      slivers: [
        SliverAppBar(
          title: Text('Boutique'),
          pinned: true,
        ),
        SliverFillRemaining(
          child: Center(
            child: Text('Boutique Coming Soon'),
          ),
        ),
      ],
    );
  }
}
