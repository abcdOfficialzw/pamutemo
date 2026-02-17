class ChecklistItem {
  const ChecklistItem({
    required this.id,
    required this.label,
    required this.fine,
    required this.checked,
  });

  final String id;
  final String label;
  final int fine;
  final bool checked;

  ChecklistItem copyWith({bool? checked}) {
    return ChecklistItem(
      id: id,
      label: label,
      fine: fine,
      checked: checked ?? this.checked,
    );
  }

  Map<String, dynamic> toStorageJson() {
    return {'id': id, 'checked': checked};
  }
}
