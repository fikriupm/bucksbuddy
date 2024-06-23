import 'package:bucks_buddy/features/home/screens/widget/debt_ticket_created.dart';
import 'package:flutter/material.dart';
import 'package:bucks_buddy/features/home/CreateDebt/controller/debt_ticket_controller.dart';
import 'package:bucks_buddy/features/home/CreateDebt/model/debt_ticket_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ViewAllDebtTicketsScreen extends StatelessWidget {
  final DebtTicketController _debtTicketController =
      Get.put(DebtTicketController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Debt Tickets'),
      ),
      body: FutureBuilder<List<DebtTicket>>(
        future: _debtTicketController.fetchDebtTickets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error fetching debt tickets: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No debt tickets found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                DebtTicket ticket = snapshot.data![index];
                return Container(
                  padding: const EdgeInsets.all(20),
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(219, 229, 199, 2), // Gold color
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 4,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
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
                                  const Color.fromARGB(255, 253, 253, 253),
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
                );
              },
            );
          }
        },
      ),
    );
  }
}
