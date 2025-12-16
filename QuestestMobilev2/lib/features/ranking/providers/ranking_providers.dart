import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ranking_entry.dart';

/// Provider that returns leaderboard entries.
/// For now it returns mocked data but keeps async contract for future API plug.
final rankingProvider = FutureProvider<List<RankingEntry>>((ref) async {
  // Simulate network delay to keep UX consistent with real API.
  await Future<void>.delayed(const Duration(milliseconds: 250));
  return _mockRanking;
});

const List<RankingEntry> _mockRanking = [
  RankingEntry(
    position: 1,
    displayName: 'Alex Nowak',
    points: 3280,
    quizzesPlayed: 52,
    avatarUrl: 'https://i.pravatar.cc/150?img=5',
    userEmail: 'alex.nowak@example.com',
  ),
  RankingEntry(
    position: 2,
    displayName: 'Julia Wójcik',
    points: 3010,
    quizzesPlayed: 47,
    avatarUrl: 'https://i.pravatar.cc/150?img=15',
    userEmail: 'julia.wojcik@example.com',
  ),
  RankingEntry(
    position: 3,
    displayName: 'Michał Kowalski',
    points: 2875,
    quizzesPlayed: 39,
    avatarUrl: 'https://i.pravatar.cc/150?img=18',
    userEmail: 'michal.kowalski@example.com',
  ),
  RankingEntry(
    position: 4,
    displayName: 'Kinga Zielińska',
    points: 2590,
    quizzesPlayed: 35,
    avatarUrl: 'https://i.pravatar.cc/150?img=33',
    userEmail: 'kinga.zielinska@example.com',
  ),
  RankingEntry(
    position: 5,
    displayName: 'Patryk Wiśniewski',
    points: 2450,
    quizzesPlayed: 31,
    avatarUrl: 'https://i.pravatar.cc/150?img=23',
    userEmail: 'patryk.wisniewski@example.com',
  ),
  RankingEntry(
    position: 6,
    displayName: 'Ola Baran',
    points: 2280,
    quizzesPlayed: 28,
    avatarUrl: 'https://i.pravatar.cc/150?img=45',
    userEmail: 'ola.baran@example.com',
  ),
  RankingEntry(
    position: 7,
    displayName: 'Piotr Lis',
    points: 2170,
    quizzesPlayed: 26,
    avatarUrl: 'https://i.pravatar.cc/150?img=12',
    userEmail: 'piotr.lis@example.com',
  ),
  RankingEntry(
    position: 8,
    displayName: 'Ewa Krawczyk',
    points: 2055,
    quizzesPlayed: 25,
    avatarUrl: 'https://i.pravatar.cc/150?img=48',
    userEmail: 'ewa.krawczyk@example.com',
  ),
  RankingEntry(
    position: 9,
    displayName: 'Tomek Pawlak',
    points: 1940,
    quizzesPlayed: 22,
    avatarUrl: 'https://i.pravatar.cc/150?img=21',
    userEmail: 'tomek.pawlak@example.com',
  ),
  RankingEntry(
    position: 10,
    displayName: 'Basia Duda',
    points: 1830,
    quizzesPlayed: 20,
    avatarUrl: 'https://i.pravatar.cc/150?img=30',
    userEmail: 'basia.duda@example.com',
  ),
];


