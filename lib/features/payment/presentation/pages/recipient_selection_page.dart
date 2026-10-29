import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

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
    {'name': 'Marie C.', 'number': '677 88 99 00'},
  ];

  final List<Map<String, String>> _allContacts = [
    {'name': 'Alice Web', 'number': '677 00 11 22'},
    {'name': 'Bob Multi', 'number': '670 12 34 56'},
    {'name': 'Charlie Design', 'number': '690 98 76 54'},
    {'name': 'David Dev', 'number': '650 11 22 33'},
    {'name': 'Emma Art', 'number': '655 44 33 22'},
    {'name': 'Samuel Eto\'o', 'number': '671 22 33 44'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.spotifyBlack,
      appBar: AppBar(
        title: const Text(
          'Envoyer de l\'argent',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: AppColors.spotifyBlack,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search box Spotify Dark
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.spotifyCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF282828), width: 0.8),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Saisir un numéro (+237...) ou un nom',
                  hintStyle: const TextStyle(color: AppColors.spotifyGrey, fontSize: 14),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.monarchPurpleNeon, size: 22),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.person_add_alt_1_rounded, color: AppColors.monarchPurpleNeon),
                    onPressed: () {},
                  ),
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _navigateToPayment(value, 'Nouveau Destinataire');
                  }
                },
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 12),
              children: [
                // Recent / Frequent Contacts
                const Text(
                  'Fréquents',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 105,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _frequentContacts.length,
                    itemBuilder: (context, index) {
                      final contact = _frequentContacts[index];
                      return GestureDetector(
                        onTap: () => _navigateToPayment(contact['number']!, contact['name']!),
                        child: Container(
                          width: 82,
                          margin: const EdgeInsets.only(right: 14),
                          child: Column(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF26193E),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFF382A54), width: 1),
                                ),
                                child: Center(
                                  child: Text(
                                    contact['name']![0],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.monarchPurpleNeon,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                contact['name']!,
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
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
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 12),
                ..._allContacts.map((contact) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: AppColors.spotifyCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF242424), width: 0.8),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.spotifyElevated,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF2E2E2E)),
                        ),
                        child: Center(
                          child: Text(
                            contact['name']![0],
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                      title: Text(
                        contact['name']!,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                      ),
                      subtitle: Text(
                        contact['number']!,
                        style: const TextStyle(color: AppColors.spotifyGrey, fontSize: 12),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.spotifyGrey, size: 14),
                      onTap: () => _navigateToPayment(contact['number']!, contact['name']!),
                    ),
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
