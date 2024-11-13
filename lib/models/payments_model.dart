// models/payment_model.dart

class Payment {
  final int id;
  final int amount;
  final DateTime  paymentDate;

  Payment({
    required this.id,
    required this.amount,
    required this.paymentDate,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      amount: json['amount'],
      paymentDate: DateTime.parse(json['payment_date']),
    );
  }
}

class Invoice {
  final String invoiceId;
  final int patientId;
  final String patientName;
  final String doctorName;
  final String treatment;
  final int totalAmount;
  final int paidAmount;
  final int remainingAmount;
  final String status;
  final List<Payment> payments;

  Invoice({
    required this.invoiceId,
    required this.patientId,
    required this.patientName,
    required this.doctorName,
    required this.treatment,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.status,
    required this.payments,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    var paymentsList = json['payments'] as List;
    List<Payment> payments = paymentsList.map((i) => Payment.fromJson(i)).toList();

    return Invoice(
      invoiceId: json['invoice_id'],
      patientId: json['patient_id'],
      patientName: json['patient_name'],
      doctorName: json['doctor_name'],
      treatment: json['treatment'],
      totalAmount: json['total_amount'],
      paidAmount: json['paid_amount'],
      remainingAmount: json['remaining_amount'],
      status: json['status'],
      payments: payments,
    );
  }
}
