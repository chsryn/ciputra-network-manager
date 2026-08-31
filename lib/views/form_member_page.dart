import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/member.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

// ==========================================
// FORM ADD / EDIT MEMBER
// ==========================================
class FormMemberPage extends StatefulWidget {
  final Member? memberData;

  const FormMemberPage({super.key, this.memberData});

  @override
  State<FormMemberPage> createState() => _FormMemberPageState();
}

class _FormMemberPageState extends State<FormMemberPage> {
  final _apiService = ApiService();

  // ── Existing Controllers ───────────────────────────────────
  final _memberIdController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _uplineController = TextEditingController();
  final _addressController = TextEditingController();

  // ── New Controllers ────────────────────────────────────────
  final _referralCodeController = TextEditingController();
  final _emailController = TextEditingController();
  final _bankAccountController = TextEditingController();
  final _customBankController = TextEditingController();
  final _insuredNameController = TextEditingController();
  final _heirNameController = TextEditingController();
  final _regDateController = TextEditingController();

  // ── Dropdown / Toggle State ────────────────────────────────
  String _selectedRank = 'Start Up';
  String _selectedBank = 'BCA';
  String _selectedHeirRelation = 'Istri';
  String _selectedSavingsPlan = 'Cilisa Rp 600.000';
  bool _isMemberInsured = true; // "Apakah Member adalah Tertanggung Utama?"

  bool _isLoading = false;
  bool get isEditMode => widget.memberData != null;

  static const List<String> _rankList = [
    'Start Up',
    'Bronze',
    'Silver',
    'Gold',
    'Platinum',
    'Diamond',
    'Crown',
    'Royal Crown',
  ];

  static const List<String> _bankList = [
    'BCA',
    'Mandiri',
    'BNI',
    'BRI',
    'Lainnya',
  ];

  static const List<String> _heirRelationList = [
    'Istri',
    'Suami',
    'Anak',
    'Orang Tua',
    'Lainnya',
  ];

  static const List<String> _savingsPlanList = [
    'Cilisa Rp 600.000',
    'Cilisa Rp 1.200.000',
    'Cilisa Rp 2.500.000',
    'Cilisa Rp 5.000.000',
    'CIPTA',
  ];

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      final m = widget.memberData!;
      _memberIdController.text = m.memberId;
      _fullNameController.text = m.fullName;
      _phoneController.text = m.phoneNumber;
      _uplineController.text = m.uplineId;
      _addressController.text = m.address;
      _referralCodeController.text = m.referralCode;
      _emailController.text = m.email;
      _bankAccountController.text = m.bankAccount;
      _insuredNameController.text = m.insuredName;
      _heirNameController.text = m.heirName;
      _regDateController.text = m.registrationDate;

      if (_rankList.contains(m.rankLevel)) _selectedRank = m.rankLevel;

      // Restore bank — if it's not in the preset list, it's a custom bank
      if (_bankList.contains(m.bankName)) {
        _selectedBank = m.bankName;
      } else if (m.bankName.isNotEmpty) {
        _selectedBank = 'Lainnya';
        _customBankController.text = m.bankName;
      }

      if (_heirRelationList.contains(m.heirRelation)) {
        _selectedHeirRelation = m.heirRelation;
      }
      if (_savingsPlanList.contains(m.savingsPlan)) {
        _selectedSavingsPlan = m.savingsPlan;
      }

      // If insuredName is empty or equals fullName, member is the insured
      _isMemberInsured =
          m.insuredName.isEmpty || m.insuredName == m.fullName;
    } else {
      // New member — auto-set registration date to today
      _regDateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    }
  }

  @override
  void dispose() {
    _memberIdController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _uplineController.dispose();
    _addressController.dispose();
    _referralCodeController.dispose();
    _emailController.dispose();
    _bankAccountController.dispose();
    _customBankController.dispose();
    _insuredNameController.dispose();
    _heirNameController.dispose();
    _regDateController.dispose();
    super.dispose();
  }

  Future<void> prosesData(String actionType) async {
    // ── Strict Validation ─────────────────────────────────────
    final missingFields = <String>[];

    if (_memberIdController.text.isEmpty) missingFields.add('Member ID');
    if (_fullNameController.text.isEmpty) missingFields.add('Nama Lengkap');
    if (_emailController.text.isEmpty) missingFields.add('Email');
    if (_phoneController.text.isEmpty) missingFields.add('Nomor WhatsApp');
    if (_bankAccountController.text.isEmpty) missingFields.add('Nomor Rekening');
    if (_heirNameController.text.isEmpty) missingFields.add('Nama Ahli Waris');
    if (_addressController.text.isEmpty) missingFields.add('Alamat Lengkap');

    // Conditional: custom bank name required when 'Lainnya'
    if (_selectedBank == 'Lainnya' && _customBankController.text.isEmpty) {
      missingFields.add('Nama Bank (Lainnya)');
    }

    // Conditional: insured name required when member is NOT the insured
    if (!_isMemberInsured && _insuredNameController.text.isEmpty) {
      missingFields.add('Nama Tertanggung');
    }

    if (missingFields.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Field wajib belum diisi: ${missingFields.join(", ")}',
            style: GoogleFonts.plusJakartaSans(fontSize: 13),
          ),
          backgroundColor: kError,
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final member = Member(
        memberId: _memberIdController.text,
        fullName: _fullNameController.text,
        phoneNumber: _phoneController.text,
        uplineId: _uplineController.text,
        rankLevel: _selectedRank,
        address: _addressController.text,
        referralCode: _referralCodeController.text,
        email: _emailController.text,
        bankName: _selectedBank == 'Lainnya'
            ? _customBankController.text
            : _selectedBank,
        bankAccount: _bankAccountController.text,
        insuredName: _isMemberInsured
            ? _fullNameController.text
            : _insuredNameController.text,
        heirName: _heirNameController.text,
        heirRelation: _selectedHeirRelation,
        registrationDate: _regDateController.text,
        savingsPlan: _selectedSavingsPlan,
      );

      final success = await _apiService.submitMemberData(
        action: actionType,
        member: member,
      );

      if (success && mounted) {
        Navigator.pop(context, true);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal terhubung ke server!',
                style: GoogleFonts.plusJakartaSans()),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ══════════════════════════════════════════════════════════
  // REUSABLE INPUT BUILDERS (Glassmorphism Style)
  // ══════════════════════════════════════════════════════════

  Widget _buildPillInput(
    TextEditingController controller,
    String label,
    IconData icon,
    String hint, {
    bool enabled = true,
    TextInputType type = TextInputType.text,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: kTextMain,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: enabled ? kSurface : kBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kOutline),
              boxShadow: enabled ? kAppleShadow : [],
            ),
            child: TextField(
              controller: controller,
              enabled: enabled,
              keyboardType: type,
              maxLines: maxLines,
              inputFormatters: inputFormatters,
              style: GoogleFonts.plusJakartaSans(
                color: enabled ? kTextMain : kTextVariant,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(icon, color: kTextVariant, size: 22),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                hintText: hint,
                hintStyle: GoogleFonts.plusJakartaSans(
                    color: kTextVariant, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable Glassmorphism-styled dropdown matching _buildPillInput aesthetics.
  Widget _buildPillDropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: kTextMain,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: kSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kOutline),
              boxShadow: kAppleShadow,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: const Icon(Icons.expand_more_rounded,
                    color: kTextVariant),
                items: items
                    .map((v) => DropdownMenuItem<String>(
                          value: v,
                          child: Row(
                            children: [
                              Icon(icon, color: kTextVariant, size: 22),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  v,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: kTextMain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section header for logical form groupings.
  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: kPrimary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: kPrimary, size: 18),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: kTextMain,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(child: Divider(color: kOutline, thickness: 1)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? 'Edit Profil' : 'Member Baru',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: kTextMain,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: kBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: kTextMain),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: kPrimary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ─────────────────────────────────
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            color: kPrimary.withValues(alpha: 0.10),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person_add_rounded,
                              size: 40, color: kPrimary),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Lengkapi data di bawah ini untuk mendaftarkan member baru ke dalam jaringan.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                              color: kTextVariant, fontSize: 14, height: 1.5),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),

                  // ══════════════════════════════════════════
                  // SECTION 1: Data Utama
                  // ══════════════════════════════════════════
                  _buildSectionHeader('Data Utama', Icons.person_rounded),

                  _buildPillInput(_memberIdController, 'Member ID',
                      Icons.badge_outlined, 'Contoh: NIK/KTP',
                      enabled: !isEditMode),
                  _buildPillInput(_fullNameController, 'Nama Lengkap',
                      Icons.person_outline, 'Masukkan nama sesuai KTP'),
                  _buildPillInput(_emailController, 'Email',
                      Icons.email_outlined, 'contoh@email.com',
                      type: TextInputType.emailAddress),
                  _buildPillInput(_phoneController, 'Nomor WhatsApp',
                      Icons.phone_outlined, '081234567890',
                      type: TextInputType.phone),
                  _buildPillInput(_referralCodeController, 'Kode Referal',
                      Icons.qr_code_rounded, 'Masukkan kode referal'),
                  _buildPillInput(_uplineController, 'Upline ID',
                      Icons.account_tree_outlined, 'Kosongkan jika Upline'),
                  _buildPillInput(
                      _addressController,
                      'Alamat Lengkap',
                      Icons.home_work_outlined,
                      'Masukkan alamat lengkap',
                      type: TextInputType.multiline,
                      maxLines: 3),

                  // ══════════════════════════════════════════
                  // SECTION 2: Peringkat & Paket
                  // ══════════════════════════════════════════
                  _buildSectionHeader(
                      'Peringkat & Paket', Icons.workspace_premium_rounded),

                  _buildPillDropdown(
                    label: 'Peringkat',
                    icon: Icons.military_tech_rounded,
                    value: _selectedRank,
                    items: _rankList,
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedRank = v);
                    },
                  ),
                  _buildPillDropdown(
                    label: 'Paket Tabungan',
                    icon: Icons.savings_rounded,
                    value: _selectedSavingsPlan,
                    items: _savingsPlanList,
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedSavingsPlan = v);
                    },
                  ),
                  _buildPillInput(_regDateController, 'Tanggal Daftar',
                      Icons.calendar_today_rounded, 'dd-MM-yyyy',
                      enabled: false),

                  // ══════════════════════════════════════════
                  // SECTION 3: Data Bank
                  // ══════════════════════════════════════════
                  _buildSectionHeader(
                      'Data Bank', Icons.account_balance_rounded),

                  _buildPillDropdown(
                    label: 'Bank',
                    icon: Icons.account_balance_outlined,
                    value: _selectedBank,
                    items: _bankList,
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedBank = v);
                    },
                  ),

                  // ── AnimatedSize: Custom Bank Name ("Lainnya") ────
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: _selectedBank == 'Lainnya'
                        ? _buildPillInput(
                            _customBankController,
                            'Nama Bank',
                            Icons.account_balance,
                            'Masukkan nama bank',
                          )
                        : const SizedBox.shrink(),
                  ),

                  _buildPillInput(
                    _bankAccountController,
                    'Nomor Rekening',
                    Icons.credit_card_rounded,
                    'Masukkan nomor rekening',
                    type: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),

                  // ══════════════════════════════════════════
                  // SECTION 4: Asuransi
                  // ══════════════════════════════════════════
                  _buildSectionHeader(
                      'Data Asuransi', Icons.health_and_safety_rounded),

                  // ── Checkbox: Is Member the Insured? ───────
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: kSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: kOutline),
                        boxShadow: kAppleShadow,
                      ),
                      child: CheckboxListTile(
                        value: _isMemberInsured,
                        onChanged: (v) =>
                            setState(() => _isMemberInsured = v ?? true),
                        activeColor: kPrimary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        title: Text(
                          'Apakah Member adalah Tertanggung Utama?',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: kTextMain,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ),

                  // ── AnimatedSize: Insured Name (conditional) ────
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: !_isMemberInsured
                        ? _buildPillInput(
                            _insuredNameController,
                            'Nama Tertanggung',
                            Icons.shield_outlined,
                            'Masukkan nama tertanggung utama',
                          )
                        : const SizedBox.shrink(),
                  ),

                  _buildPillInput(_heirNameController, 'Nama Ahli Waris',
                      Icons.family_restroom_rounded, 'Masukkan nama ahli waris'),
                  _buildPillDropdown(
                    label: 'Hubungan Ahli Waris',
                    icon: Icons.people_outline_rounded,
                    value: _selectedHeirRelation,
                    items: _heirRelationList,
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedHeirRelation = v);
                    },
                  ),

                  // ══════════════════════════════════════════
                  // ACTION BUTTONS
                  // ══════════════════════════════════════════
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save_rounded, size: 20),
                      label: Text(
                        isEditMode ? 'Update Data' : 'Simpan Member',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        backgroundColor: kPrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      onPressed: () =>
                          prosesData(isEditMode ? 'update' : 'insert'),
                    ),
                  ),
                  if (isEditMode) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.delete_rounded, size: 20),
                        label: Text(
                          'Hapus Member',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          foregroundColor: kError,
                          side: const BorderSide(color: kError),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () => prosesData('delete'),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}
