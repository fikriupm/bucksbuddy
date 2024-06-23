// debt_ticket_controller.dart

import 'package:bucks_buddy/features/home/CreateDebt/model/debt_ticket_model.dart';
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

  Future<List<DebtTicket>> fetchDebtTickets() async {
    List<DebtTicket> debtTickets = [];

    try {
      // Retrieve the authenticated user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated.');
      }

      // Query the 'DebtTickets' subcollection for the authenticated user
      QuerySnapshot<
          Map<String,
              dynamic>> debtTicketsSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user
              .uid) // Directly access the document of the authenticated user
          .collection('DebtTickets')
          .where('status', isEqualTo: 'not_paid')
          .get();

      // Check if there are any matching documents
      if (debtTicketsSnapshot.docs.isNotEmpty) {
        for (var docSnapshot in debtTicketsSnapshot.docs) {
          Map<String, dynamic> data = docSnapshot.data();

          // Map data to DebtTicket model
          DebtTicket ticket = DebtTicket.fromJson(data);
          debtTickets.add(ticket);
        }
      }

      // Sort the debt tickets by dateTime in ascending order
      debtTickets.sort((a, b) =>
          DateTime.parse(a.dateTime).compareTo(DateTime.parse(b.dateTime)));
    } catch (e) {
      print('Error fetching debt tickets: $e');
    }

    return debtTickets;
  }

  Future<List<DebtTicket>> fetchDebtTicketsOwn(String debtorUsername) async {
    String debtorYouOwn = debtorUsername;
    List<DebtTicket> debtTickets = [];

    try {
      QuerySnapshot<Map<String, dynamic>> usersSnapshot =
          await FirebaseFirestore.instance.collection('Users').get();

      for (var userDoc in usersSnapshot.docs) {
        String userId = userDoc.id;

        QuerySnapshot<Map<String, dynamic>> debtTicketsSnapshot =
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(userId)
                .collection('DebtTickets')
                .where('debtor', isEqualTo: debtorYouOwn)
                .where('status', isEqualTo: 'not_paid')
                .get();

        if (debtTicketsSnapshot.docs.isNotEmpty) {
          for (var docSnapshot in debtTicketsSnapshot.docs) {
            Map<String, dynamic> data = docSnapshot.data();
            DebtTicket ticket = DebtTicket.fromJson(data);
            debtTickets.add(ticket);
          }
        }
      }

      debtTickets.sort((a, b) =>
          DateTime.parse(a.dateTime).compareTo(DateTime.parse(b.dateTime)));
    } catch (e) {
      print('Error fetching debt tickets: $e');
    }

    return debtTickets;
  }

  Future<List<DebtTicket>> viewDebtTicketPaid() async {
    List<DebtTicket> debtTickets = [];

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated.');
      }
      
      QuerySnapshot<
          Map<String,
              dynamic>> creditorDebtTicketsSnapshot = await FirebaseFirestore
          .instance
          .collection('Users')
          .doc(user
              .uid) // Directly access the document of the authenticated user
          .collection('DebtTickets')
          .where('status', isEqualTo: 'Paid')
          .get();

      if (creditorDebtTicketsSnapshot.docs.isNotEmpty) {
        for (var docSnapshot in creditorDebtTicketsSnapshot.docs) {
          Map<String, dynamic> data = docSnapshot.data();
          DebtTicket ticket = DebtTicket.fromJson(data);
          debtTickets.add(ticket);
        }
      }

      // Sort debt tickets by dateTime
      debtTickets.sort((a, b) =>
          DateTime.parse(b.dateTime).compareTo(DateTime.parse(a.dateTime)));
    } catch (e, stackTrace) {
      print('Error fetching debt tickets: $e');
      print(stackTrace); // Print stack trace for more detailed error logging
    }

    if (debtTickets.isEmpty) {
      print('No paid debt tickets found for');
    }

    return debtTickets;
  }

    Future<List<DebtTicket>> viewDebtTicketUOwePaid(String debtorUsername) async {

    
    List<DebtTicket> debtTickets = [];

    try {
      QuerySnapshot<Map<String, dynamic>> usersSnapshot =
          await FirebaseFirestore.instance.collection('Users').get();

      for (var userDoc in usersSnapshot.docs) {
        String userId = userDoc.id;

        QuerySnapshot<Map<String, dynamic>> debtTicketsSnapshot =
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(userId)
                .collection('DebtTickets')
                .where('debtor', isEqualTo: debtorUsername)
                .where('status', isEqualTo: 'Paid')
                .get();

        if (debtTicketsSnapshot.docs.isNotEmpty) {
          for (var docSnapshot in debtTicketsSnapshot.docs) {
            Map<String, dynamic> data = docSnapshot.data();
            DebtTicket ticket = DebtTicket.fromJson(data);
            debtTickets.add(ticket);
          }
        }
      }

      debtTickets.sort((a, b) =>
          DateTime.parse(b.dateTime).compareTo(DateTime.parse(a.dateTime)));

      // Fetch debt tickets where you are the debtor and status is 'Paid'
      // QuerySnapshot<Map<String, dynamic>> debtorDebtTicketsSnapshot =
      //     await FirebaseFirestore.instance
      //         .collection('Users')
      //         .doc(user.uid)
      //         .collection('DebtTickets')
      //         .where('debtor', isEqualTo: debtorUsername)
      //         .where('status', isEqualTo: 'Paid')
      //         .get();

      // if (debtorDebtTicketsSnapshot.docs.isNotEmpty) {
      //   for (var docSnapshot in debtorDebtTicketsSnapshot.docs) {
      //     Map<String, dynamic> data = docSnapshot.data();
      //     DebtTicket ticket = DebtTicket.fromJson(data);
      //     debtTickets.add(ticket);
      //   }
      // }


      // Sort debt tickets by dateTime
    } catch (e, stackTrace) {
      print('Error fetching debt tickets: $e');
      print(stackTrace); // Print stack trace for more detailed error logging
    }

    if (debtTickets.isEmpty) {
      print('No paid debt tickets found for');
    }

    return debtTickets;
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
