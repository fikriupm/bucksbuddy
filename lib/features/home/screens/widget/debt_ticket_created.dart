import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bucks_buddy/features/home/CreateDebt/controller/debt_ticket_controller.dart';
import 'package:bucks_buddy/features/home/CreateDebt/model/debt_ticket_model.dart';
import 'package:get/get.dart';

class DebtTicketTCreated extends StatelessWidget {
  final String debtTicketId;

  DebtTicketTCreated({required this.debtTicketId});

  @override
  Widget build(BuildContext context) {
    final DebtTicketController _debtTicketController =
        Get.put(DebtTicketController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Ticket for You Details',
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: FutureBuilder<DebtTicket?>(
        future: _debtTicketController.fetchDebtTickeCreatedtById(debtTicketId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error fetching debt ticket ID: $debtTicketId'),
                  const SizedBox(height: 8.0),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          } else if (snapshot.data == null) {
            return const Center(child: Text('Debt ticket not found.'));
          } else {
            DebtTicket ticket = snapshot.data!;
            bool isPaid = ticket.status.toLowerCase() == 'paid';
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('TICKETID : ${ticket.debtTicketId}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text(isPaid ? 'Paid' : 'Not Paid',
                                  style: TextStyle(
                                      color:
                                          isPaid ? Colors.green : Colors.red)),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          const Text('From',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(ticket.creditor),
                          const SizedBox(height: 8.0),
                          const Text('To',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(ticket.debtor),
                          const SizedBox(height: 8.0),
                          const Text('Phone Number',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(ticket.phoneNumber),
                          const SizedBox(height: 8.0),
                          const Text('Amount',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('RM ${ticket.amount}'),
                          const SizedBox(height: 8.0),
                          const Text('Bank',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(ticket.bankAccount),
                          const SizedBox(height: 8.0),
                          const Text('Account Number',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(ticket.bankAccountNumber),
                          const SizedBox(height: 8.0),
                          const Text('Reference',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(ticket.reference),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.calendar_month, size: 16),
                                  const SizedBox(width: 4.0),
                                  Text(DateFormat.yMMMd()
                                      .format(DateTime.parse(ticket.dateTime))),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 16),
                                  const SizedBox(width: 4.0),
                                  Text(DateFormat.jm()
                                      .format(DateTime.parse(ticket.dateTime))),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
