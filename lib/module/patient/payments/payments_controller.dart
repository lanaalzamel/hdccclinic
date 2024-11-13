import 'package:get/get.dart';
import 'package:hdccapp/module/patient/payments/payments_server.dart';
import '../../../config/user_info.dart';
import '../../../models/payments_model.dart';
class PaymentController extends GetxController {
  var invoices = <Invoice>[].obs;
  var isLoading = true.obs;

  final PaymentService paymentService;

  PaymentController(this.paymentService);

  @override
  void onInit() {
    super.onInit();
    fetchInvoiceData(Userinformation.id);
  }

  void fetchInvoiceData(int patientId) async {
    try {
      isLoading(true);
      final data = await paymentService.fetchInvoice(patientId);
      invoices.value = data;
      sortInvoicesByLatestPaymentDate();  // Default to latest payment
    } finally {
      isLoading(false);
    }
  }

  void sortInvoicesByLatestPaymentDate() {
    final sortedInvoices = invoices.toList()..sort((a, b) {
      DateTime latestPaymentA = a.payments.isNotEmpty
          ? a.payments.map((payment) => payment.paymentDate).reduce((curr, next) => curr.isAfter(next) ? curr : next)
          : DateTime.fromMillisecondsSinceEpoch(0);

      DateTime latestPaymentB = b.payments.isNotEmpty
          ? b.payments.map((payment) => payment.paymentDate).reduce((curr, next) => curr.isAfter(next) ? curr : next)
          : DateTime.fromMillisecondsSinceEpoch(0);

      return latestPaymentB.compareTo(latestPaymentA);  // Sort by latest payment date
    });

    invoices.assignAll(sortedInvoices);
  }

  void sortInvoicesByOldestPaymentDate() {
    final sortedInvoices = invoices.toList()..sort((a, b) {
      DateTime oldestPaymentA = a.payments.isNotEmpty
          ? a.payments.map((payment) => payment.paymentDate).reduce((curr, next) => curr.isBefore(next) ? curr : next)
          : DateTime.fromMillisecondsSinceEpoch(0);

      DateTime oldestPaymentB = b.payments.isNotEmpty
          ? b.payments.map((payment) => payment.paymentDate).reduce((curr, next) => curr.isBefore(next) ? curr : next)
          : DateTime.fromMillisecondsSinceEpoch(0);

      return oldestPaymentA.compareTo(oldestPaymentB);  // Sort by oldest payment date
    });

    invoices.assignAll(sortedInvoices);
  }
}

