class TransactionFields {
  static const String tableName = 'transactions';

  static const String id = '_id';
  static const String type = 'type';
  static const String category = 'category';
  static const String amount = 'amount';
  static const String description = 'description';
  static const String paymentMethod = 'payment_method';
  static const String isFavorite = 'is_favorite';
  static const String createdAt = 'created_at';

  static const List<String> values = [
    id,
    type,
    category,
    amount,
    description,
    paymentMethod,
    isFavorite,
    createdAt,
  ];
}

class TransactionModel {
  int? id;
  final String type; // ingreso / gasto
  final String category;
  final double amount;
  final String? description;
  final String? paymentMethod;
  final bool isFavorite;
  final DateTime createdAt;

  TransactionModel({
    this.id,
    required this.type,
    required this.category,
    required this.amount,
    this.description,
    this.paymentMethod,
    this.isFavorite = false,
    required this.createdAt,
  });

  Map<String, Object?> toJson() => {
        TransactionFields.id: id,
        TransactionFields.type: type,
        TransactionFields.category: category,
        TransactionFields.amount: amount,
        TransactionFields.description: description,
        TransactionFields.paymentMethod: paymentMethod,
        TransactionFields.isFavorite: isFavorite ? 1 : 0,
        TransactionFields.createdAt: createdAt.toIso8601String(),
      };

  factory TransactionModel.fromJson(Map<String, Object?> json) {
    return TransactionModel(
      id: json[TransactionFields.id] as int?,
      type: json[TransactionFields.type] as String,
      category: json[TransactionFields.category] as String,
      amount: (json[TransactionFields.amount] as num).toDouble(),
      description: json[TransactionFields.description] as String?,
      paymentMethod: json[TransactionFields.paymentMethod] as String?,
      isFavorite: json[TransactionFields.isFavorite] == 1,
      createdAt: DateTime.parse(json[TransactionFields.createdAt] as String),
    );
  }

  TransactionModel copy({
    int? id,
    String? type,
    String? category,
    double? amount,
    String? description,
    String? paymentMethod,
    bool? isFavorite,
    DateTime? createdAt,
  }) =>
      TransactionModel(
        id: id ?? this.id,
        type: type ?? this.type,
        category: category ?? this.category,
        amount: amount ?? this.amount,
        description: description ?? this.description,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        isFavorite: isFavorite ?? this.isFavorite,
        createdAt: createdAt ?? this.createdAt,
      );
}
