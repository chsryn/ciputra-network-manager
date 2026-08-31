import 'package:flutter/foundation.dart';

import '../models/member.dart';
import '../services/api_service.dart';

class MemberProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Member> _allMembers = [];
  List<Member> _displayedMembers = [];
  bool _isLoading = true;

  List<Member> get allMembers => _allMembers;
  List<Member> get displayedMembers => _displayedMembers;
  bool get isLoading => _isLoading;

  // ── Rank Filtering ─────────────────────────────────────────
  String? _selectedRankFilter;
  String? get selectedRankFilter => _selectedRankFilter;

  void setRankFilter(String? rank) {
    _selectedRankFilter = rank;
    notifyListeners();
  }

  List<Member> get filteredMembers {
    if (_selectedRankFilter == null || _selectedRankFilter == 'All') {
      return allMembers;
    }
    return allMembers
        .where((m) =>
            m.rankLevel.toLowerCase() == _selectedRankFilter!.toLowerCase())
        .toList();
  }

  // ── Computed rank counts (8 tiers) ────────────────────────
  int get totalCount => _allMembers.length;
  int get royalCrownCount => _countByRank('royal crown');
  int get crownCount => _countByRank('crown');
  int get diamondCount => _countByRank('diamond');
  int get platinumCount => _countByRank('platinum');
  int get goldCount => _countByRank('gold');
  int get silverCount => _countByRank('silver');
  int get bronzeCount => _countByRank('bronze');
  int get startUpCount => _countByRank('start up');

  int _countByRank(String rank) =>
      _allMembers.where((m) => m.rankLevel.toLowerCase() == rank).length;

  // ── Fetch members ─────────────────────────────────────────
  Future<void> fetchMembers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allMembers = await _apiService.fetchMembers();
      _displayedMembers = _allMembers;
    } catch (_) {
      _allMembers = [];
      _displayedMembers = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // ── Search / Filter ───────────────────────────────────────
  void filterSearch(String query) {
    if (query.isEmpty) {
      _displayedMembers = _allMembers;
    } else {
      final searchValue = query.toLowerCase();
      _displayedMembers = _allMembers.where((member) {
        return member.fullName.toLowerCase().contains(searchValue) ||
            member.memberId.toLowerCase().contains(searchValue);
      }).toList();
    }
    notifyListeners();
  }
}
