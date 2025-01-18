class Payment {
  final int id;
  final int orderId;
  final String transactionId;
  final double amount;
  final String paymentMethod;
  final String? paymentCode;
  final String paymentStatus;
  final DateTime transactionDate;

  Payment({
    required this.id,
    required this.orderId,
    required this.transactionId,
    required this.amount,
    required this.paymentMethod,
    this.paymentCode,
    required this.paymentStatus,
    required this.transactionDate,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      orderId: json['order_id'],
      transactionId: json['transaction_id'],
      amount: json['amount'] is String
          ? double.tryParse(json['amount']) ?? 0.0
          : json['amount'].toDouble(),
      paymentMethod: json['payment_method'],
      paymentCode: json['payment_code'] ?? 'Kosong',
      paymentStatus: json['payment_status'],
      transactionDate: DateTime.parse(json['transaction_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'transaction_id': transactionId,
      'amount': amount,
      'payment_method': paymentMethod,
      'payment_code': paymentCode,
      'payment_status': paymentStatus,
      'transaction_date': transactionDate.toIso8601String(),
    };
  }
}

class FinanceData {
  final String paymentMethod;
  final double? total;

  FinanceData({
    required this.paymentMethod,
    this.total,
  });

  factory FinanceData.fromJson(Map<String, dynamic> json) {
    return FinanceData(
      paymentMethod: json['payment_method'],
      total: double.tryParse(json['total']) ?? 0.0,
    );
  }
}
