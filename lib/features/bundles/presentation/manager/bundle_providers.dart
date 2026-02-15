import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/bundle.dart';

final bundlesProvider = Provider<List<Bundle>>((ref) {
  return const [
    // Internet Bundles
    Bundle(
      id: 'int_1',
      name: 'Giga Data 2h',
      description: 'Naviguez sans limite pendant 2 heures.',
      price: 99,
      validity: '2 Heures',
      duration: '1j',
      dataAmount: '1 GB',
      type: BundleType.internet,
    ),
    Bundle(
      id: 'int_2',
      name: 'Semaine Internet',
      description: 'Parfait pour rester connecté toute la semaine.',
      price: 1500,
      validity: '7 Jours',
      duration: '7j',
      dataAmount: '2.5 GB',
      type: BundleType.internet,
    ),
    Bundle(
      id: 'int_3',
      name: 'Mois Illimité',
      description: 'Le pass pour les gros consommateurs.',
      price: 10000,
      validity: '30 Jours',
      duration: '30j',
      dataAmount: '30 GB',
      type: BundleType.internet,
    ),

    // Call Bundles
    Bundle(
      id: 'call_1',
      name: 'MTN Talk 100',
      description: 'Appels vers tous les réseaux MTN.',
      price: 100,
      validity: '24 Heures',
      duration: '1j',
      minutesAmount: '30 Mins',
      type: BundleType.call,
    ),
    Bundle(
      id: 'call_2',
      name: 'Combo Hebdo',
      description: 'Appels et SMS illimités le soir.',
      price: 2000,
      validity: '7 Jours',
      duration: '7j',
      minutesAmount: '300 Mins',
      type: BundleType.call,
    ),

    // Mixte Bundles
    Bundle(
      id: 'mix_1',
      name: 'Maxi Mixte 1j',
      description: 'Appels, Internet et SMS pour la journée.',
      price: 500,
      validity: '24 Heures',
      duration: '1j',
      dataAmount: '500 MB',
      minutesAmount: '60 Mins',
      type: BundleType.mixte,
    ),
    Bundle(
      id: 'mix_2',
      name: 'Maxi Mixte 7j',
      description: 'Profitez de tout pendant une semaine.',
      price: 2500,
      validity: '7 Jours',
      duration: '7j',
      dataAmount: '2 GB',
      minutesAmount: '250 Mins',
      type: BundleType.mixte,
    ),

    // Oversize Bundles
    Bundle(
      id: 'over_1',
      name: 'Oversize Data',
      description: 'Le plus gros forfait data disponible.',
      price: 25000,
      validity: '30 Jours',
      duration: '30j',
      dataAmount: '100 GB',
      type: BundleType.oversize,
    ),

    // VSD Bundles (Vendredi Samedi Dimanche)
    Bundle(
      id: 'vsd_1',
      name: 'VSD Illimité',
      description: 'Internet illimité tout le week-end.',
      price: 1000,
      validity: '3 Jours',
      duration: 'illimite',
      dataAmount: 'Illimité',
      type: BundleType.vsd,
    ),

    // Special Bundles
    Bundle(
      id: 'spec_1',
      name: 'WhatsApp Illimité',
      description: 'Utilisez WhatsApp sans toucher à votre forfait.',
      price: 200,
      validity: '30 Jours',
      duration: '30j',
      type: BundleType.special,
    ),
  ];
});

final selectedBundleCategoryProvider = StateProvider<BundleType?>((ref) => null);
final selectedBundleDurationProvider = StateProvider<String?>((ref) => null);

final filteredBundlesProvider = Provider<List<Bundle>>((ref) {
  final bundles = ref.watch(bundlesProvider);
  final selectedType = ref.watch(selectedBundleCategoryProvider);
  final selectedDuration = ref.watch(selectedBundleDurationProvider);

  return bundles.where((bundle) {
    bool typeMatch = selectedType == null || bundle.type == selectedType;
    bool durationMatch = selectedDuration == null || bundle.duration == selectedDuration;
    return typeMatch && durationMatch;
  }).toList();
});
