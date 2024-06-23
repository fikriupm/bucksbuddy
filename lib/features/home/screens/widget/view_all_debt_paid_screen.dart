import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:bucks_buddy/features/home/CreateDebt/controller/debt_ticket_controller.dart';
import 'package:bucks_buddy/features/home/CreateDebt/model/debt_ticket_model.dart';
import 'package:bucks_buddy/features/home/screens/widget/debt_ticket_created.dart';
import 'package:bucks_buddy/features/home/screens/widget/debt_ticket_to_pay.dart';

class ViewAllDebtTicketsPaidScreen extends StatefulWidget {
  final String debtorUsername;

  ViewAllDebtTicketsPaidScreen({required this.debtorUsername});

  @override
  _ViewAllDebtTicketsPaidScreenState createState() => _ViewAllDebtTicketsPaidScreenState();
}

class _ViewAllDebtTicketsPaidScreenState extends State<ViewAllDebtTicketsPaidScreen> {
  final DebtTicketController _debtTicketController = Get.put(DebtTicketController());
  bool _showOwnYou = true;
  late Future<List<DebtTicket>> _debtTicketsFuture;
  late Future<List<DebtTicket>> _debtTicketsOwnFuture;
  late String _debtorUsername;

  @override
  void initState() {
    super.initState();
    _debtorUsername = _debtTicketController.debtorUsername.value;
    _debtTicketsFuture = _debtTicketController.viewDebtTicketPaid();
    _debtTicketsOwnFuture = _debtTicketController.viewDebtTicketUOwePaid(_debtorUsername);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debt Tickets Settled'),
      ),
      body: Column(
        children: [
          _buildToggleButtons(),
          Expanded(
            child: _showOwnYou
                ? _buildDebtTicketsFutureBuilder(_debtTicketsFuture, true)
                : _buildDebtTicketsFutureBuilder(_debtTicketsOwnFuture, false),
          ),
        ],
      ),
    );
  }
    Widget _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildToggleButton('Owe You', _showOwnYou, Color.fromARGB(255, 220, 196, 8)),
        _buildToggleButton('You Owe', !_showOwnYou, Color.fromARGB(255, 220, 196, 8)),
      ],
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, Color color) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _showOwnYou = text == 'Owe You';
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? color : Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        elevation: 5,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildDebtTicketsFutureBuilder(Future<List<DebtTicket>> future, bool isOwnYou) {
    return FutureBuilder<List<DebtTicket>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No debt tickets found.'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              DebtTicket ticket = snapshot.data![index];
              return _buildDebtTicketItem(ticket, isOwnYou);
            },
          );
        }
      },
    );
  }

  Widget _buildDebtTicketItem(DebtTicket ticket, bool isOwnYou) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
      decoration: BoxDecoration(
        color: const Color.fromARGB(219, 229, 199, 2),
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
          _buildDebtTicketHeader(ticket, isOwnYou),
          Text(
            isOwnYou ? 'To: ${ticket.debtor}' : 'From: ${ticket.creditor}',
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
          _buildDebtTicketDateTime(ticket),
        ],
      ),
    );
  }

  Widget _buildDebtTicketHeader(DebtTicket ticket, bool isOwnYou) {
    return Row(
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
                builder: (context) => isOwnYou
                    ? DebtTicketTCreated(debtTicketId: ticket.debtTicketId)
                    : DebtTicketToPay(debtTicketId: ticket.debtTicketId),
              ),
            );
          },
          child: const Text('Details >'),
          style: TextButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 253, 253, 253),
          ),
        ),
      ],
    );
  }

  Widget _buildDebtTicketDateTime(DebtTicket ticket) {
    return Row(
      children: [
        _buildDateTimeRow(Icons.calendar_month, DateFormat.yMd().format(DateTime.parse(ticket.dateTime))),
        const SizedBox(width: 20),
        _buildDateTimeRow(Icons.access_time, DateFormat.Hms().format(DateTime.parse(ticket.dateTime))),
      ],
    );
  }

  Widget _buildDateTimeRow(IconData icon, String text) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
