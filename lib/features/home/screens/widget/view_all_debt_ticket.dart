import 'package:flutter/material.dart';
import 'package:bucks_buddy/features/home/CreateDebt/controller/debt_ticket_controller.dart';
import 'package:bucks_buddy/features/home/CreateDebt/model/debt_ticket_model.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ViewAllDebtTicketsScreen extends StatelessWidget {
  final DebtTicketController _debtTicketController =
      Get.put(DebtTicketController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Debt Tickets'),
      ),
      body: FutureBuilder<List<DebtTicket>>(
        future: _fetchDebtTickets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error fetching debt tickets: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No debt tickets found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                DebtTicket ticket = snapshot.data![index];
                return Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(219, 229, 199, 2), // Gold color
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 4,
                        blurRadius: 8,
                        offset: Offset(0, 4),
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
                            style: TextStyle(
                              color: const Color.fromARGB(255, 99, 99, 99),
                              fontSize: 12,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Handle tapping on a debt ticket if needed
                            },
                            child: Text('Details >'),
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  const Color.fromARGB(255, 253, 253, 253),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'To : ${ticket.debtor}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'RM${ticket.amount}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(Icons.calendar_month, size: 20),
                                SizedBox(width: 5),
                                Text(
                                  DateFormat.yMd().format(DateTime.parse(
                                      ticket.dateTime)), // Format the date
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Row(
                              children: [
                                Icon(Icons.access_time, size: 20),
                                SizedBox(width: 5),
                                Text(
                                  DateFormat.Hms().format(DateTime.parse(
                                      ticket.dateTime)), // Format the time
                                  style: TextStyle(fontSize: 16),
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

  Future<List<DebtTicket>> _fetchDebtTickets() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('DebtTickets')
            .get();

        return querySnapshot.docs
            .map((doc) =>
                DebtTicket.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('User is not authenticated.');
      }
    } catch (e) {
      throw Exception('Error fetching all debt tickets: $e');
    }
  }
}
