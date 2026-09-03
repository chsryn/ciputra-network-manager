import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/member.dart';
import '../../providers/member_provider.dart';
import '../../utils/constants.dart';
import '../form_member_page.dart';

// ==========================================
// POHON FAKTOR / VISUAL HIERARCHY TREE
// ==========================================
class TreeViewTab extends StatelessWidget {
  final List<Member> members;

  const TreeViewTab({super.key, required this.members});

  List<Member> _getRootMembers() {
    final allMemberIds = members.map((m) => m.memberId).toSet();
    return members.where((m) {
      final uplineId = m.uplineId;
      return uplineId.isEmpty ||
          uplineId.toLowerCase() == 'admin' ||
          !allMemberIds.contains(uplineId);
    }).toList();
  }

  int _countAllDownlines(String currentId) {
    final directDownlines =
        members.where((m) => m.uplineId == currentId).toList();
    var count = directDownlines.length;
    for (final child in directDownlines) {
      count += _countAllDownlines(child.memberId);
    }
    return count;
  }

  Widget _buildTreeNode(Member member, BuildContext context,
      {bool isRoot = false}) {
    final currentId = member.memberId;
    final directDownlines =
        members.where((m) => m.uplineId == currentId).toList();
    final totalJaringan = _countAllDownlines(currentId);
    final rankColor = getRankColor(member.rankLevel);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(20),
        border: isRoot
            ? Border.all(color: kOutline)
            : Border.all(color: Colors.transparent),
        boxShadow: isRoot ? kAppleShadow : const [],
      ),
      child: GestureDetector(
        onLongPress: () async {
          final bool? refreshData = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormMemberPage(memberData: member),
            ),
          );
          if (refreshData == true && context.mounted) {
            context.read<MemberProvider>().fetchMembers();
          }
        },
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: isRoot,
            iconColor: kTextVariant,
            collapsedIconColor: kTextVariant,
            tilePadding:
                EdgeInsets.symmetric(horizontal: isRoot ? 16 : 0, vertical: 8),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: directDownlines.isEmpty
                    ? kBackground
                    : kPrimary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                directDownlines.isEmpty
                    ? Icons.person_rounded
                    : Icons.account_tree_rounded,
                color: directDownlines.isEmpty ? kTextVariant : kPrimary,
                size: 20,
              ),
            ),
            title: Text(
              member.fullName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: kTextMain,
                letterSpacing: -0.3,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: kBackground,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'ID: $currentId',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 12,
                            color: kTextVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: rankColor.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          member.rankLevel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            color: rankColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (totalJaringan > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'Jaringan: $totalJaringan Member',
                      style: GoogleFonts.plusJakartaSans(
                        color: kPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            trailing:
                directDownlines.isEmpty ? const SizedBox.shrink() : null,
            children: directDownlines.isEmpty
                ? const []
                : [
                    Container(
                      margin: const EdgeInsets.only(left: 20, bottom: 8),
                      padding: const EdgeInsets.only(left: 20, top: 8),
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(color: kOutline, width: 2),
                        ),
                      ),
                      child: Column(
                        children: directDownlines
                            .map((child) => _buildTreeNode(child, context,
                                isRoot: false))
                            .toList(),
                      ),
                    ),
                  ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    final provider = context.watch<MemberProvider>();
    final filterOptions = [
      'All',
      'Royal Crown',
      'Crown',
      'Diamond',
      'Platinum',
      'Gold',
      'Silver',
      'Bronze',
      'Start Up'
    ];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: filterOptions.length,
        itemBuilder: (context, index) {
          final chip = filterOptions[index];
          final isSelected = provider.selectedRankFilter == chip ||
              (provider.selectedRankFilter == null && chip == 'All');

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                provider.setRankFilter(chip == 'All' ? null : chip);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? kPrimary : Colors.transparent,
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(
                    color: isSelected ? kPrimary : kOutline,
                  ),
                ),
                child: Center(
                  child: Text(
                    chip,
                    style: GoogleFonts.plusJakartaSans(
                      color: isSelected ? Colors.white : kTextMain,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rootMembers = _getRootMembers();
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildFilterChips(context),
        const SizedBox(height: 12),
        Expanded(
          child: rootMembers.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                    Center(
                      child: Text(
                        'Tidak ada jaringan ditemukan.',
                        style: GoogleFonts.plusJakartaSans(
                            color: kTextVariant, fontSize: 15),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.only(left: 24, right: 24, top: 4, bottom: 40),
                  itemCount: rootMembers.length,
                  itemBuilder: (context, index) =>
                      _buildTreeNode(rootMembers[index], context, isRoot: true),
                ),
        ),
      ],
    );
  }
}
