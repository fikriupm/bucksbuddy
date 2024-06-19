// debt_ticket_controller.dart
import 'dart:math';

import 'package:bucks_buddy/features/home/CreateDebt/model/debt_ticket_model.dart';
import 'package:bucks_buddy/features/home/homepage.dart';
import 'package:bucks_buddy/features/personalization/controllers/user_controller.dart';
import 'package:bucks_buddy/features/personalization/controllers/bank_account_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DebtTicketController extends GetxController {
  static DebtTicketController instance = Get.find();
  final UserController userController = UserController.instance;
  final BankAccountController bankAccountController =
      BankAccountController.instance;

  Future<void> saveDebtTicket(DebtTicket ticket, String username) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(username)
          .collection('DebtTickets')
          .add(ticket.toJson());
    } catch (e) {
      throw Exception('Failed to submit debt ticket: $e');
    }
  }

  Future<bool> doesDebtorExist(String debtor) async {
    return await userController.doesDebtorExist(debtor);
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    final data = await bankAccountController.getAllUserBankAccount();
    final user = userController.user.value;

    return {
      'username': user.username,
      'fullName': user.fullName,
      'bankName': data.first.bankName,
      'accountNumber': data.first.accountNumber,
      'userId': user.id,
      'phoneNumber': user.phoneNumber,
    };
  }

  Future<String> fetchDebtorInfo(String username) async {
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
      throw Exception('Error fetching debtor info: $e');
    }
  }

  Future<DebtTicket?> fetchDebtTicket(String username, String ticketId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(username)
          .collection('DebtTickets')
          .doc(ticketId)
          .get();

      if (docSnapshot.exists) {
        return DebtTicket.fromJson(docSnapshot.data()!);
      } else {
        return null; // Ticket not found
      }
    } catch (e) {
      throw Exception('Error fetching debt ticket: $e');
    }
  }

  void navigateToHomePage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => Homepage()), // Adjust the HomePage path
      (route) => false,
    );
  }

  String generatedTicketId() {
    Random random = Random();
    var ticketId = 'TICKET ID: ${random.nextInt(1000)}';
    return ticketId;
  }
}
