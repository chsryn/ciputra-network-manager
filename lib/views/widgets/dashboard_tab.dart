import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/member.dart';
import '../../providers/member_provider.dart';
import '../../utils/constants.dart';
import '../form_member_page.dart';

class DashboardTab extends StatefulWidget {
  final Function(int)? onNavigateToTab;
  const DashboardTab({super.key, this.onNavigateToTab});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  bool _isOverviewExpanded = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MemberProvider>();

    return RefreshIndicator(
      onRefresh: provider.fetchMembers,
      color: kPrimary,
      backgroundColor: kSurface,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Search Bar ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: kSurface,
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(color: kOutline),
                  boxShadow: kAppleShadow,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: provider.filterSearch,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    color: kTextMain,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Cari Nama atau ID...',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      color: kTextVariant,
                      fontSize: 15,
                    ),
                    prefixIcon:
                        const Icon(Icons.search_rounded, color: kTextVariant),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),

            // ── Network Overview (AnimatedSize) ──────────────────
            if (!provider.isLoading && provider.allMembers.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                child: GestureDetector(
                  onTap: () =>
                      setState(() => _isOverviewExpanded = !_isOverviewExpanded),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Network Overview',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: kTextMain,
                          letterSpacing: -0.8,
                        ),
                      ),
                      Icon(
                        _isOverviewExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: kTextMain,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _TapScaleWidget(
                      child: _buildStatCard(
                        'Total Members',
                        provider.totalCount,
                        kPrimary,
                        isFullWidth: true,
                        onTap: () {
                          provider.setRankFilter('All');
                          widget.onNavigateToTab?.call(1);
                        },
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: _isOverviewExpanded
                          ? Column(
                              children: [
                                const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _TapScaleWidget(
                                    child: _buildStatCard(
                                      'Royal Crown',
                                      provider.royalCrownCount,
                                      kRoyalCrown,
                                      onTap: () {
                                        provider.setRankFilter('Royal Crown');
                                        widget.onNavigateToTab?.call(1);
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _TapScaleWidget(
                                    child: _buildStatCard(
                                      'Crown',
                                      provider.crownCount,
                                      kCrown,
                                      onTap: () {
                                        provider.setRankFilter('Crown');
                                        widget.onNavigateToTab?.call(1);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _TapScaleWidget(
                                    child: _buildStatCard(
                                      'Diamond',
                                      provider.diamondCount,
                                      kDiamond,
                                      onTap: () {
                                        provider.setRankFilter('Diamond');
                                        widget.onNavigateToTab?.call(1);
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _TapScaleWidget(
                                    child: _buildStatCard(
                                      'Platinum',
                                      provider.platinumCount,
                                      kPlatinum,
                                      onTap: () {
                                        provider.setRankFilter('Platinum');
                                        widget.onNavigateToTab?.call(1);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _TapScaleWidget(
                                    child: _buildStatCard(
                                      'Gold',
                                      provider.goldCount,
                                      kGold,
                                      onTap: () {
                                        provider.setRankFilter('Gold');
                                        widget.onNavigateToTab?.call(1);
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _TapScaleWidget(
                                    child: _buildStatCard(
                                      'Silver',
                                      provider.silverCount,
                                      kSilver,
                                      onTap: () {
                                        provider.setRankFilter('Silver');
                                        widget.onNavigateToTab?.call(1);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _TapScaleWidget(
                                    child: _buildStatCard(
                                      'Bronze',
                                      provider.bronzeCount,
                                      kBronze,
                                      onTap: () {
                                        provider.setRankFilter('Bronze');
                                        widget.onNavigateToTab?.call(1);
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _TapScaleWidget(
                                    child: _buildStatCard(
                                      'Start Up',
                                      provider.startUpCount,
                                      kStartUp,
                                      onTap: () {
                                        provider.setRankFilter('Start Up');
                                        widget.onNavigateToTab?.call(1);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // ── Recent Activity Header ───────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                'Recent Activity',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: kTextMain,
                  letterSpacing: -0.8,
                ),
              ),
            ),

            // ── Member List ──────────────────────────────────────
            if (provider.isLoading)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: const Center(
                    child: CircularProgressIndicator(color: kPrimary)),
              )
            else if (provider.displayedMembers.isEmpty)
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2),
                  Center(
                    child: Text(
                      'Data tidak ditemukan.',
                      style: GoogleFonts.plusJakartaSans(
                        color: kTextVariant,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 8, bottom: 24),
                itemCount: provider.displayedMembers.length,
                itemBuilder: (context, index) => _TapScaleWidget(
                  child: _buildMemberCard(
                      provider.displayedMembers[index]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Stat Card ────────────────────────────────────────────
  Widget _buildStatCard(String title, int count, Color accentColor,
      {bool isFullWidth = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kOutline),
        boxShadow: kAppleShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  color: kTextVariant,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$count',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: isFullWidth ? 32 : 24,
                  fontWeight: FontWeight.w800,
                  color: kTextMain,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
          Container(
            width: 8,
            height: isFullWidth ? 48 : 36,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(9999),
            ),
          ),
        ],
      ),
    ));
  }

  // ── Member Card ──────────────────────────────────────────
  Widget _buildMemberCard(Member member) {
    final rankColor = getRankColor(member.rankLevel);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kOutline),
        boxShadow: kAppleShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            final bool? refreshData = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FormMemberPage(memberData: member),
              ),
            );
            if (refreshData == true && mounted) {
              context.read<MemberProvider>().fetchMembers();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: kPrimary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      member.initial,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: kPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: kTextMain,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: kBackground,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'ID: ${member.memberId}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 11,
                                  color: kTextVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '↑ Up: ${member.uplineDisplay}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: kTextVariant,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: rankColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      member.rankLevel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        color: rankColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// TAP SCALE MICRO-INTERACTION WIDGET
// ══════════════════════════════════════════════════════════════
class _TapScaleWidget extends StatefulWidget {
  final Widget child;
  const _TapScaleWidget({required this.child});

  @override
  State<_TapScaleWidget> createState() => _TapScaleWidgetState();
}

class _TapScaleWidgetState extends State<_TapScaleWidget> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
