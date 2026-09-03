import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/member_provider.dart';
import '../utils/constants.dart';
import 'form_member_page.dart';
import 'widgets/dashboard_tab.dart';
import 'widgets/tree_view_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Kick off initial data fetch via Provider (post-frame to avoid sync context access)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<MemberProvider>().fetchMembers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MemberProvider>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: kBackground.withValues(alpha: 0.7),
            ),
          ),
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/logo_ui.png',
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Ciputra Network Manager',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  color: kTextMain,
                  letterSpacing: -0.8,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      // ── Subtle gradient background for Glassmorphism depth ──
      body: Container(
        decoration: const BoxDecoration(
          gradient: kBackgroundGradient,
        ),
        child: _currentIndex == 0
            ? SafeArea(
                bottom: false,
                child: DashboardTab(
                  onNavigateToTab: (index) {
                    setState(() => _currentIndex = index);
                  },
                ),
              )
            : SafeArea(
                bottom: false,
                child: RefreshIndicator(
                  onRefresh: provider.fetchMembers,
                  color: kPrimary,
                  backgroundColor: kSurface,
                  child: TreeViewTab(members: provider.filteredMembers),
                ),
              ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: kAppleShadow,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            selectedItemColor: kPrimary,
            unselectedItemColor: kTextVariant,
            backgroundColor: kSurface,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
            unselectedLabelStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
            onTap: (index) async {
              if (index == 2) {
                final memberProvider = context.read<MemberProvider>();
                final bool? refreshData = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FormMemberPage(),
                  ),
                );
                if (refreshData == true && mounted) {
                  memberProvider.fetchMembers();
                }
              } else {
                setState(() => _currentIndex = index);
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.dashboard_rounded)),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.account_tree_rounded)),
                label: 'Network',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.person_add_rounded)),
                label: 'Add Member',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
