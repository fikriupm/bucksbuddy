import 'package:bucks_buddy/features/home/CreateDebt/model/debt_ticket_model.dart';
import 'package:bucks_buddy/features/home/screens/widget/debt_ticket_created.dart';
import 'package:bucks_buddy/features/home/screens/widget/view_all_debt_ticket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:intl/intl.dart';

class RecentDebtSection extends StatelessWidget {
  const RecentDebtSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DebtTicket?>(
      future: _fetchLatestDebtTicket(),
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
                          "Recent Tickets Created",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: TSizes.fontSizeSm,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ViewAllDebtTicketsScreen(),
                              ),
                            );
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

  Future<DebtTicket?> _fetchLatestDebtTicket() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('DebtTickets')
            .where('status', isEqualTo: 'not_paid')
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          List<DebtTicket> debtTickets = querySnapshot.docs.map((doc) {
            return DebtTicket.fromJson(doc.data() as Map<String, dynamic>);
          }).toList();

          // Sort the debt tickets by dateTime in descending order to get the latest ticket first
          debtTickets.sort((a, b) =>
              DateTime.parse(b.dateTime).compareTo(DateTime.parse(a.dateTime)));

          // Return the latest debt ticket
          return debtTickets.first;
        } else {
          return null; // Return null if no ticket found
        }
      } else {
        throw Exception('User is not authenticated.');
      }
    } catch (e) {
      throw Exception('Error fetching latest debt ticket: $e');
    }
  }
}
