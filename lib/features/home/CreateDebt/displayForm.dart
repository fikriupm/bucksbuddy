import 'package:bucks_buddy/features/home/CreateDebt/createDebt.dart';
import 'package:bucks_buddy/features/personalization/controllers/debt_ticket_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting

import 'submitted.dart'; // Adjust the import path if necessary

class DisplayForm extends StatefulWidget {
  final Map<String, dynamic> ticketData;
  final String id; // User ID to identify the user

  DisplayForm({Key? key, required this.ticketData, required this.id})
      : super(key: key);

  @override
  _DisplayFormState createState() => _DisplayFormState();
}

class _DisplayFormState extends State<DisplayForm> {
  final DebtTicketController debtTicketController = DebtTicketController();
  Future<String>? debtorInfoFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debtorInfoFuture = _fetchDebtorInfo(widget.ticketData['debtor']);
  }

  Future<void> _submitToFirebase(BuildContext context) async {
    try {
      await debtTicketController.saveDebtTicket(widget.ticketData, widget.id);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SubmittedPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: FutureBuilder<String>(
                future: debtorInfoFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final debtorInfo = snapshot.data ?? 'Unknown Debtor';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildTicketDetail(
                            'Creditor', widget.ticketData['creditor']),
                        _buildTicketDetail('Debtor', debtorInfo),
                        _buildTicketDetail(
                            'Phone Number/Email',
                            widget.ticketData[
                                'PhoneNumber/Email']), // Placeholder for future data
                        _buildTicketDetail(
                            'Amount', 'RM ${widget.ticketData['amount']}'),
                        _buildTicketDetail(
                            'Bank', widget.ticketData['bankAccount']),
                        _buildTicketDetail('Account Number',
                            widget.ticketData['bankAccountNumber']),
                        _buildTicketDetail(
                            'Reference', widget.ticketData['reference']),
                        const SizedBox(height: 12),
                        Text(
                          '${DateFormat.EEEE().format(DateTime.parse(widget.ticketData['dateTime']))}, ${DateFormat.yMMMd().format(DateTime.parse(widget.ticketData['dateTime']))}                         ${DateFormat.jm().format(DateTime.parse(widget.ticketData['dateTime']))}',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .end, // Align buttons to the right
                          children: <Widget>[
                            SizedBox(
                              width: 120, // Adjust button width as needed
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CreateDebtPage(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  backgroundColor:
                                      const Color(0xFFF0CA00).withOpacity(0.82),
                                ),
                                child: const Text(
                                  'Edit Form',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 120, // Adjust button width as needed
                              child: ElevatedButton(
                                onPressed: () => _submitToFirebase(context),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  backgroundColor:
                                      const Color(0xFFF0CA00).withOpacity(0.82),
                                ),
                                child: const Text(
                                  'Confirm',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _fetchDebtorInfo(String username) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('Username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        final username = userData['Username'] ?? 'Unknown Username';
        final name = userData['Name'] ?? 'Unknown Name';

        return '$username / $name';
      } else {
        return 'Unknown Debtor'; // Default if user not found
      }
    } catch (e) {
      print('Error fetching debtor info: $e');
      return 'Unknown Debtor';
    }
  }

  Widget _buildTicketDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(value),
        const SizedBox(height: 8),
      ],
    );
  }
}
