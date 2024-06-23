// debt_ticket_controller.dart

import 'package:bucks_buddy/features/home/CreateDebt/model/debt_ticket_model.dart';
import 'package:bucks_buddy/features/home/homepage.dart';
import 'package:bucks_buddy/features/personalization/controllers/user_controller.dart';
import 'package:bucks_buddy/features/personalization/controllers/bank_account_controller.dart';
import 'package:bucks_buddy/navigation_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DebtTicketController extends GetxController {
  static DebtTicketController instance = Get.find();
  final UserController userController = UserController.instance;
  final BankAccountController bankAccountController =
      BankAccountController.instance;
  var isPaid = true.obs;

  @override
  void initState() {
    super.onStart;
  }

  @override
  void onClosed() {
    super.onClose();
  }

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

  void navigateToHomePage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const NavigationMenu()), // Adjust the HomePage path
      (route) => false,
    );
  }

  String generateTicketId() {
    return 'BBDT${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<List<DebtTicket>> fetchDebtTickets() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('DebtTickets')
            .orderBy('dateTime', descending: true) // Order by dateTime field
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

  Future<String> fetchCurrentUsername() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          return userDoc['Username'] as String;
        } else {
          throw Exception('User document does not exist.');
        }
      } else {
        throw Exception('User is not authenticated.');
      }
    } catch (e) {
      throw Exception('Error fetching username: $e');
    }
  }

  Future<List<DebtTicket>> fetchDebtTicketsOwn(String debtorUsername) async {
    String debtorYouOwn = debtorUsername;
    List<DebtTicket> debtTickets = [];

    try {
      // Retrieve all user documents from the 'Users' collection
      QuerySnapshot<Map<String, dynamic>> usersSnapshot =
          await FirebaseFirestore.instance.collection('Users').get();

      // Iterate through each user document
      for (var userDoc in usersSnapshot.docs) {
        String userId = userDoc.id;

        // Query the 'DebtTickets' subcollection for the current user
        QuerySnapshot<Map<String, dynamic>> debtTicketsSnapshot =
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(userId)
                .collection('DebtTickets')
                .where('debtor', isEqualTo: debtorYouOwn)
                .get();

        // Check if there are any matching documents
        if (debtTicketsSnapshot.docs.isNotEmpty) {
          for (var docSnapshot in debtTicketsSnapshot.docs) {
            Map<String, dynamic> data = docSnapshot.data();

            // Map data to DebtTicket model
            DebtTicket ticket = DebtTicket.fromJson(data);
            debtTickets.add(ticket);
            ;
          }
        } else {}
      }

      return debtTickets;
    } catch (e) {
      throw Exception('Error fetching all debt tickets: $e');
    }
  }

  Future<DebtTicket?> fetchDebtTickeCreatedtById(String ticketId) async {
    try {
      // Ensure ticketId is not empty
      if (ticketId.isEmpty) {
        throw Exception('The ticketId provided is empty.');
      }

      // Retrieve all user documents from the 'Users' collection
      QuerySnapshot<Map<String, dynamic>> usersSnapshot =
          await FirebaseFirestore.instance.collection('Users').get();

      // Iterate through each user document
      for (var userDoc in usersSnapshot.docs) {
        String userId = userDoc.id;

        // Query the 'DebtTickets' subcollection for the current user by ticketId field
        QuerySnapshot<Map<String, dynamic>> ticketQuerySnapshot =
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(userId)
                .collection('DebtTickets')
                .where('debtTicketId', isEqualTo: ticketId)
                .get();

        // Check if any documents are found
        if (ticketQuerySnapshot.docs.isNotEmpty) {
          // Assuming only one document will match
          var ticketDocSnapshot = ticketQuerySnapshot.docs.first;
          Map<String, dynamic> data = ticketDocSnapshot.data();

          // Map data to DebtTicket model
          DebtTicket ticket = DebtTicket.fromJson(data);
          return ticket;
        }
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching debt ticket by ID: $e');
    }
  }

  Future<DebtTicket?> fetchDebtTickeToPaytById(String ticketId) async {
    try {
      // Ensure ticketId is not empty
      if (ticketId.isEmpty) {
        throw Exception('The ticketId provided is empty.');
      }
      // Retrieve all user documents from the 'Users' collection
      QuerySnapshot<Map<String, dynamic>> usersSnapshot =
          await FirebaseFirestore.instance.collection('Users').get();

      // Iterate through each user document
      for (var userDoc in usersSnapshot.docs) {
        String userId = userDoc.id;
        // Query the 'DebtTickets' subcollection for the current user by ticketId field
        QuerySnapshot<Map<String, dynamic>> ticketQuerySnapshot =
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(userId)
                .collection('DebtTickets')
                .where('debtTicketId', isEqualTo: ticketId)
                .get();

        // Check if any documents are found
        if (ticketQuerySnapshot.docs.isNotEmpty) {
          // Assuming only one document will match
          var ticketDocSnapshot = ticketQuerySnapshot.docs.first;
          Map<String, dynamic> data = ticketDocSnapshot.data();

          // Map data to DebtTicket model
          DebtTicket ticket = DebtTicket.fromJson(data);
          return ticket;
        }
      }

      return null;
    } catch (e) {
      throw Exception('Error fetching debt ticket by ID: $e');
    }
  }

  Future<void> fetchAllDebtTickets(String userId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> allDebtTicketsSnapshot =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(userId)
              .collection('DebtTickets')
              .get();

      for (var doc in allDebtTicketsSnapshot.docs) {
        print(doc.data());
      }
    } catch (e) {
      print('Error fetching all debt tickets: $e');
    }
  }
}
