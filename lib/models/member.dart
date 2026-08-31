class Member {
  final String memberId;
  final String fullName;
  final String phoneNumber;
  final String uplineId;
  final String rankLevel;
  final String address;
  final String referralCode;
  final String email;
  final String bankName;
  final String bankAccount;
  final String insuredName;
  final String heirName;
  final String heirRelation;
  final String registrationDate;
  final String savingsPlan;

  const Member({
    required this.memberId,
    required this.fullName,
    required this.phoneNumber,
    required this.uplineId,
    required this.rankLevel,
    required this.address,
    this.referralCode = '',
    this.email = '',
    this.bankName = '',
    this.bankAccount = '',
    this.insuredName = '',
    this.heirName = '',
    this.heirRelation = '',
    this.registrationDate = '',
    this.savingsPlan = '',
  });

 factory Member.fromJson(Map<String, dynamic> json) {
    // Menangkap tanggal mentah dari Google
    String rawDate = json['registrationDate']?.toString() ?? '';
    String displayDate = rawDate;

    // Jika formatnya ISO (contoh: 2026-08-26T16:00:00.000Z)
    if (rawDate.contains('T')) {
      final datePart = rawDate.split('T')[0]; // Mengambil "2026-08-26"
      final parts = datePart.split('-'); // Memecah jadi ["2026", "08", "26"]
      if (parts.length == 3) {
        displayDate = '${parts[2]}-${parts[1]}-${parts[0]}'; // Menyusun ulang jadi "26-08-2026"
      }
    }

    return Member(
      memberId: json['member_id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      uplineId: json['upline_id']?.toString().trim() ?? '',
      rankLevel: json['rank_level']?.toString() ?? 'Start Up',
      address: json['address']?.toString() ?? '',
      referralCode: json['referralCode']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      bankName: json['bankName']?.toString() ?? '',
      bankAccount: json['bankAccount']?.toString() ?? '',
      insuredName: json['insuredName']?.toString() ?? '',
      heirName: json['heirName']?.toString() ?? '',
      heirRelation: json['heirRelation']?.toString() ?? '',
      registrationDate: displayDate, // Menggunakan tanggal yang sudah dirapikan
      savingsPlan: json['savingsPlan']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'member_id': memberId,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'upline_id': uplineId,
      'rank_level': rankLevel,
      'address': address,
      'referralCode': referralCode,
      'email': email,
      'bankName': bankName,
      'bankAccount': bankAccount,
      'insuredName': insuredName,
      'heirName': heirName,
      'heirRelation': heirRelation,
      'registrationDate': registrationDate,
      'savingsPlan': savingsPlan,
    };
  }

  /// First character of the full name, uppercased. Falls back to '?'.
  String get initial => fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';

  /// Upline display text — returns '-' when empty.
  String get uplineDisplay => uplineId.isEmpty ? '-' : uplineId;
}