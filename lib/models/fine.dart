class Fine {
  const Fine({
    required this.id,
    required this.section,
    required this.offence,
    required this.level,
    required this.amount,
    required this.group,
    required this.category,
    required this.subsection,
    required this.act,
    required this.explanation,
  });

  final String id;
  final String section;
  final String offence;
  final String level;
  final String amount;
  final String group;
  final String category;
  final String subsection;
  final String act;
  final String explanation;

  String get displayAmount {
    final cleaned = amount.trim();
    if (cleaned.isEmpty) return '-';
    final numeric = RegExp(r'^\d+(/\d+)?$').hasMatch(cleaned);
    return numeric ? '\$$cleaned' : cleaned;
  }

  factory Fine.fromJson(Map<String, dynamic> json) {
    return Fine(
      id: (json['id'] ?? '').toString(),
      section: (json['section'] ?? '').toString(),
      offence: (json['offence'] ?? '').toString(),
      level: (json['level'] ?? '').toString(),
      amount: (json['amount'] ?? '').toString(),
      group: (json['group'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      subsection: (json['subsection'] ?? '').toString(),
      act: (json['act'] ?? '').toString(),
      explanation: (json['explanation'] ?? '').toString(),
    );
  }
}
