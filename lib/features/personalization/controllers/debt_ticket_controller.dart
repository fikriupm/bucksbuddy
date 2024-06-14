import 'package:cloud_firestore/cloud_firestore.dart';

class DebtTicketController {
  final bool profileLoading = false;

  Future<void> saveDebtTicket(
      Map<String, dynamic> ticketData, String username) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users') // Replace 'users' with your collection name
          .doc(username)
          .collection('DebtTickets') // Subcollection for debt tickets
          .add(ticketData);
    } catch (e) {
      throw Exception('Failed to submit debt ticket: $e');
    } finally {}
  }
}
