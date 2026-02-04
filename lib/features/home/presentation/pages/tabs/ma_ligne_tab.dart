import 'package:flutter/material.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../widgets/conso_status.dart';

class MaLigneTab extends StatefulWidget {
  const MaLigneTab({super.key});

  @override
  State<MaLigneTab> createState() => _MaLigneTabState();
}

class _MaLigneTabState extends State<MaLigneTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      key: const PageStorageKey('MaLigneTab'),
      slivers: [
        const SliverAppBar(
          title: Text('Ma Ligne'),
          pinned: true,
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.md),
        ),
        const SliverToBoxAdapter(
          child: ConsoStatus(),
        ),
      ],
    );
  }
}
