import 'package:bucks_buddy/features/home/CreateDebt/controller/debt_ticket_controller.dart';
import 'package:bucks_buddy/features/home/CreateDebt/model/debt_ticket_model.dart';
import 'package:bucks_buddy/features/home/screens/widget/debt_ticket_created.dart';
import 'package:bucks_buddy/features/home/screens/widget/view_all_debt_own.dart';
import 'package:bucks_buddy/features/home/screens/widget/view_all_debt_ticket.dart';
import 'package:bucks_buddy/features/payment/controllers/payment_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

class RecentDebtSection extends StatelessWidget {
  RecentDebtSection({
    super.key,
  });
  final DebtTicketController debtTicketController =
      Get.put(DebtTicketController());
  final PaymentController _debtTicketController = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DebtTicket?>(
      future: _debtTicketController.fetchLatestDebtTicket(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: const CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Error fetching latest debt ticket: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No debt ticket found.'));
        } else {
          DebtTicket ticket = snapshot.data!;
          return Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(10),
                left: Radius.circular(10),
              ),
              color: const Color(0xFFF0CA00).withOpacity(0.82),
              shape: BoxShape.rectangle,
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Debt Tickets",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: TSizes.fontSizeSm,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              debtTicketController.debtorUsername.value =
                                  await debtTicketController
                                      .fetchCurrentUsername();
                              var debtorUsername =
                                  debtTicketController.debtorUsername.value;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ViewAllDebtTicketsScreen(
                                            debtorUsername: debtorUsername)),
                              );
                            } catch (e) {
                              // Handle error if username fetching fails
                              print('Error fetching username: $e');
                            }
                          },
                          child: const Text(
                            "View all",
                            style: TextStyle(
                              fontSize:
                                  16.0, // Replace with TSizes.fontSizeSm or a specific size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 200),
                  ],
                ),
                const SizedBox(height: 20),
                Positioned.fill(
                  top: 30,
                  left: 0,
                  right: 0,
                  bottom: 10,
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ID: ${ticket.debtTicketId}',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 99, 99, 99),
                                  fontSize: 12,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DebtTicketTCreated(
                                          debtTicketId: ticket.debtTicketId),
                                    ),
                                  );
                                },
                                child: const Text('Details >'),
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      const Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'To : ${ticket.debtor}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'RM${ticket.amount}',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_month, size: 20),
                                    const SizedBox(width: 5),
                                    Text(
                                      DateFormat.yMd().format(DateTime.parse(
                                          ticket.dateTime)), // Format the date
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 20),
                                    const SizedBox(width: 5),
                                    Text(
                                      DateFormat.Hms().format(DateTime.parse(
                                          ticket.dateTime)), // Format the time
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Positioned(
                //   bottom: 70,
                //   right: 9,
                //   child: Image.asset(
                //     TImages.groupImage,
                //   ),
                // ),
              ],
            ),
          );
        }
      },
    );
  }
}
