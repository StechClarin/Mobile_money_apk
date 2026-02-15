import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants.dart';

class RecipientSelectionPage extends StatefulWidget {
  const RecipientSelectionPage({super.key});

  @override
  State<RecipientSelectionPage> createState() => _RecipientSelectionPageState();
}

class _RecipientSelectionPageState extends State<RecipientSelectionPage> {
  final TextEditingController _searchController = TextEditingController();
  
  final List<Map<String, String>> _frequentContacts = [
    {'name': 'Maman', 'number': '677 11 22 33'},
    {'name': 'Papa', 'number': '678 44 55 66'},
    {'name': 'Jean Luc', 'number': '699 77 88 99'},
  ];

  final List<Map<String, String>> _allContacts = [
    {'name': 'Alice Web', 'number': '677 00 11 22'},
    {'name': 'Bob Multi', 'number': '670 12 34 56'},
    {'name': 'Charlie Design', 'number': '690 98 76 54'},
    {'name': 'David Dev', 'number': '650 11 22 33'},
    {'name': 'Emma Art', 'number': '655 44 33 22'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Envoyer de l\'argent'),
        backgroundColor: AppTheme.mtnYellow,
        foregroundColor: AppTheme.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search box
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            color: AppTheme.mtnYellow,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Saisir un numéro ou un nom',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.person_add_alt_1),
                  onPressed: () {},
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _navigateToPayment(value, 'Nouveau Destinataire');
                }
              },
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                // Recent / Frequent
                const Text(
                  'Fréquents',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _frequentContacts.length,
                    itemBuilder: (context, index) {
                      final contact = _frequentContacts[index];
                      return GestureDetector(
                        onTap: () => _navigateToPayment(contact['number']!, contact['name']!),
                        child: Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: 16),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: AppTheme.mtnYellow.withValues(alpha: 0.2),
                                child: Text(
                                  contact['name']![0],
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.black),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                contact['name']!,
                                style: const TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // All contacts
                const Text(
                  'Tous les contacts',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                ..._allContacts.map((contact) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      child: Text(
                        contact['name']![0],
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    title: Text(contact['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(contact['number']!),
                    onTap: () => _navigateToPayment(contact['number']!, contact['name']!),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPayment(String number, String name) {
    context.push(
      AppRoutes.payment,
      extra: {'name': name, 'number': number},
    );
  }
}
