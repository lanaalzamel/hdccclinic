import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdccapp/module/patient/payments/payments_controller.dart';
import 'package:intl/intl.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart'; // Import the custom dropdown

class PaymentView extends StatelessWidget {
  final int patientId;

  PaymentView({required this.patientId});

  @override
  Widget build(BuildContext context) {
    final PaymentController controller = Get.put(PaymentController(Get.find()));
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600; // Adapt for small screens

    // List of sorting options
    final List<String> sortingOptions = [
      'Sort by Latest Payment',
      'Sort by Oldest Payment'
    ];

    // Initialize SingleSelectController for the dropdown
    final SingleSelectController<String?> dropdownController =
        SingleSelectController<String?>(
      sortingOptions.first, // Set the default selected option directly
      // Set the default selected option
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Payment Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: CustomDropdown<String>(
              hintText: 'Select sorting option',
              items: sortingOptions,
              controller: dropdownController,
              onChanged: (value) {
                if (value == 'Sort by Latest Payment') {
                  controller
                      .sortInvoicesByLatestPaymentDate(); // Sort by latest payment
                } else if (value == 'Sort by Oldest Payment') {
                  controller
                      .sortInvoicesByOldestPaymentDate(); // Sort by oldest payment
                }
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (controller.invoices.isEmpty) {
                return Center(
                    child: Text('No invoices available.',
                        style: TextStyle(fontSize: 18, color: Colors.grey)));
              }

              return ListView.builder(
                itemCount: controller.invoices.length,
                padding: EdgeInsets.symmetric(
                    vertical: 20, horizontal: screenWidth * 0.05),
                // Responsive horizontal padding
                itemBuilder: (context, index) {
                  final invoice = controller.invoices[index];
                  return Card(
                    elevation: 8,
                    margin: EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      // Responsive padding inside the card
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Invoice Header and Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                invoice.invoiceId,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 18 : 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey[800],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: invoice.status == 'paid'
                                      ? Colors.green.withOpacity(0.5)
                                      : Colors.redAccent.withOpacity(0.2),
                                  // Lighter background color
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    invoice.status,
                                    style: TextStyle(
                                      color: invoice.status == 'paid'
                                          ? Colors.green
                                          : Colors.redAccent,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 16),

                          // Ordered by Section (Patient and Doctor Info)
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInfoRow(
                                    'Patient:',
                                    invoice.patientName,
                                    icon: Icons.person_outline,
                                    isSmallScreen: isSmallScreen,
                                  ),
                                  SizedBox(height: 8),
                                  _buildInfoRow(
                                    'Doctor:',
                                    invoice.doctorName,
                                    icon: Icons.medical_services_outlined,
                                    isSmallScreen: isSmallScreen,
                                  ),
                                  SizedBox(height: 8),
                                  _buildInfoRow(
                                    'Treatment:',
                                    invoice.treatment,
                                    icon: Icons.healing_outlined,
                                    isSmallScreen: isSmallScreen,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 16),

                          // Payment Details (Total, Paid, Remaining)
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                _buildAmountCard(
                                  'Total Amount',
                                  invoice.totalAmount,
                                  Icons.attach_money,
                                  Colors.blue,
                                  isSmallScreen,
                                  isTotal: true, // Highlight Total Amount
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildAmountCard(
                                      'Paid',
                                      invoice.paidAmount,
                                      Icons.payment_outlined,
                                      Colors.green,
                                      isSmallScreen,
                                    ),
                                    _buildAmountCard(
                                      'Remaining',
                                      invoice.remainingAmount,
                                      Icons.money_off_csred_outlined,
                                      Colors.redAccent,
                                      isSmallScreen,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20),

                          // Payment History Section
                          ExpansionTile(
                            title: Text(
                              'Payment History',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 16 : 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.blueGrey[800],
                              ),
                            ),
                            children: [
                              Divider(thickness: 1, color: Colors.grey[300]),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: invoice.payments.length,
                                itemBuilder: (context, paymentIndex) {
                                  final payment =
                                      invoice.payments[paymentIndex];

                                  // payment.paymentDate is already a DateTime, no need to parse it
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(payment.paymentDate);

                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: Icon(
                                      Icons.calendar_today_outlined,
                                      color: Colors.blueGrey[600],
                                    ),
                                    title: Text(
                                      'Amount: \$${payment.amount}',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 14 : 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Date: $formattedDate',
                                      style: TextStyle(
                                          color: Colors.blueGrey[400]),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountCard(
      String label, int amount, IconData icon, Color color, bool isSmallScreen,
      {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isTotal ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        // Center the content if it's the Total Amount card
        children: [
          if (isTotal) SizedBox(height: 8), // Add some spacing for Total Amount
          if (isTotal)
            Center(
              child: Column(
                children: [
                  // Icon(icon, size: isSmallScreen ? 30 : 36, color: color),
                  SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          if (!isTotal)
            Row(
              children: [
                Icon(icon, size: isSmallScreen ? 18 : 22, color: color),
                SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey[600],
                  ),
                ),
              ],
            ),
          SizedBox(height: isTotal ? 12 : 8),
          Center(
            child: Text(
              '\$$amount',
              style: TextStyle(
                fontSize: isTotal
                    ? (isSmallScreen ? 24 : 28)
                    : (isSmallScreen ? 16 : 20), // Make the Total Amount larger
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isTotal
                    ? Colors.red
                    : Colors.black87, // Change color to red to highlight total
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {IconData? icon, required bool isSmallScreen}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          if (icon != null)
            Icon(icon,
                size: isSmallScreen ? 18 : 20, color: Colors.blueGrey[700]),
          if (icon != null) SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              color: Colors.blueGrey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
