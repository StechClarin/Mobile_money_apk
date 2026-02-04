import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../home/presentation/widgets/cards_section.dart';

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cards'),
        backgroundColor: AppTheme.mtnYellow,
      ),
      body: const SingleChildScrollView(
         child: Padding(
           padding: EdgeInsets.all(16.0),
           child: Column(
             children: [
               Text('Manage your cards here', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
               SizedBox(height: 20),
               CardsSection(),
             ],
           ),
         ),
      ),
    );
  }
}
