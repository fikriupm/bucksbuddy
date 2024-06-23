import 'dart:ffi';
import 'dart:math';

import 'package:bucks_buddy/features/home/CreateDebt/model/debt_ticket_model.dart';
import 'package:bucks_buddy/features/payment/models/payment_model.dart';
import 'package:bucks_buddy/features/payment/screen/approval_screen.dart';
import 'package:bucks_buddy/features/payment/screen/payment_amount_screen.dart';
import 'package:bucks_buddy/features/payment/screen/payment_success_screen.dart';
import 'package:bucks_buddy/features/payment/screen/recipient_reference_screen.dart';
import 'package:bucks_buddy/utils/api_model/credit_transfer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PaymentController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//debtBuddy app screen
  Rx<DocumentSnapshot<Map<String, dynamic>>?> debtTicket =
      Rx<DocumentSnapshot<Map<String, dynamic>>?>(null);
  Rx<DocumentSnapshot<Map<String, dynamic>>?> user =
      Rx<DocumentSnapshot<Map<String, dynamic>>?>(null);
  Rx<DocumentSnapshot<Map<String, dynamic>>?> debtorBankDetails =
      Rx<DocumentSnapshot<Map<String, dynamic>>?>(null);
  // var updatedDebtTicket = Rxn<DocumentSnapshot<Map<String, dynamic>>>();

  RxList<PaymentModel> paymentModel = <PaymentModel>[].obs;

  String? debtoruid;
  var amount = 0.0.obs;
  var creditorName = ''.obs;
  var creditorAccount = ''.obs;
  var debtorAccount = ''.obs;
  var debtorName = ''.obs;
  var bankAccount = ''.obs;
  var debtTicketId = ''.obs;
  var category = ''.obs;
  var paymentId = ''.obs;
  var date = ''.obs;
  var phoneNumber = ''.obs;

  //payment amount screen
  Rx<String> responseMessage = ''.obs;
  var paymentAmountError = ''.obs;
  TextEditingController paymentAmount = TextEditingController();
  var selectedMethod = 'Bank Account'.obs;
  final List<String> paymentMethods = ['Bank Account', 'Phone Number'];
  //recipient_reference_screen
  TextEditingController recipientReferenceInput = TextEditingController();
  TextEditingController recipientOptionalInput = TextEditingController();
  var choiceSelected = ''.obs;

  //paymentSuccessScreen
  Rx<String> successfulFetchPayment = ''.obs;

  //aproval screen

  @override
  void onInit() {
    super.onInit();
  }

  //fetch specific debt ticket = debt_buddy_pay
  Future<void> fetchDebtTickeToPay(String ticketId) async {
    debtTicketId.value = ticketId;
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
          var ticketDocSnapshot = ticketQuerySnapshot.docs.first;
          debtTicket.value = ticketDocSnapshot;
          break;
        }
      }

      return;
    } catch (e) {
      throw Exception('Error fetching debt ticket by ID: $e');
    }
  }

//update status of ticket
  void updateDebtStatus() async {
    var paidTicket = debtTicketId.value;
    Map<String, dynamic> updatedData = {'status': 'Paid'};
    try {
      await updatedDebtTicket(updatedData, paidTicket);
    } catch (e) {}
  }

  Future<void> updatedDebtTicket(
      Map<String, dynamic> updatedData, String ticketId) async {
    debtTicketId.value = ticketId;
    try {
      // Ensure ticketId is not empty
      if (ticketId.isEmpty) {
        throw Exception('The ticketId provided is empty.');
      }

      // Retrieve all user documents from the 'Users' collection
      QuerySnapshot<Map<String, dynamic>> usersSnapshot =
          await _firestore.collection('Users').get();

      // Iterate through each user document
      for (var userDoc in usersSnapshot.docs) {
        String userId = userDoc.id;

        // Query the 'DebtTickets' subcollection for the current user by ticketId field
        QuerySnapshot<Map<String, dynamic>> ticketQuerySnapshot =
            await _firestore
                .collection('Users')
                .doc(userId)
                .collection('DebtTickets')
                .where('debtTicketId', isEqualTo: ticketId)
                .get();

        // Check if any documents are found
        if (ticketQuerySnapshot.docs.isNotEmpty) {
          var ticketDocSnapshot = ticketQuerySnapshot.docs.first;
          await ticketDocSnapshot.reference.update(updatedData);
          Get.snackbar('Success', 'Debt Ticket Status updated');
          break;
        }
      }
    } catch (e) {
      throw Exception('Error updating debt ticket: $e');
    }
  }

//org yg nak pay = payment_amount_screeen
  void fetchDebtorDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        var uid = user.uid;

        DocumentSnapshot userSnapshot =
            await _firestore.collection('Users').doc(uid).get();

        // Step 5: Iterate through each document in the user snapshot
        if (userSnapshot.exists) {
          // debtoruid = userSnapshot.id;
          phoneNumber.value = userSnapshot['PhoneNumber'];
          print("phoneNumber: ${phoneNumber.value}");
          print(uid);
          fetchDebtorBanksDetails(uid);
        } else {
          print('Debtor user does not exist');
        }
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }
  }

//
  Future<void> fetchDebtorBanksDetails(debtoruid) async {
    try {
      QuerySnapshot<Map<String, dynamic>> debtorBankSnapshot = await _firestore
          .collection('Users')
          .doc(debtoruid)
          .collection('Banks')
          .get();

      // Step 5: Check if there are any documents
      if (debtorBankSnapshot.docs.isNotEmpty) {
        debtorBankDetails.value = debtorBankSnapshot.docs.first
            as DocumentSnapshot<Map<String, dynamic>>?;
        print(debtorBankDetails.value);
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }
  }

  void errorText(String value) {
    // paymentAmountInput.text = paymentAmountError.value;
    if (value.isEmpty || paymentAmount.text.isEmpty) {
      paymentAmountError.value = 'amount cannot be empty';
      return;
    }

    double? errorValue = double.tryParse(value);
    double? paymentInput = paymentAmountInput(value);
    double? actual = actualAmount();

    if (errorValue == null || paymentInput == null || actual == null) {
      paymentAmountError.value = 'Invalid amount or payment value';
      return;
    } else if (errorValue != actual || errorValue != paymentInput) {
      paymentAmountError.value = 'amount must be $actual';
      return;
    } else {
      paymentAmountError.value = 'Success';
    }

    // Compare double values

    // Clear the error if everything is correct
  }

  actualAmount() {
    try {
      var bayaran = debtTicket.value;
      if (bayaran != null) {
        // Parse the amount value from String to double
        String amountString = bayaran['amount'];
        amount.value = double.parse(amountString);
        print('Amount ${amount.value}');
      } else {
        print('No debt ticket found.');
      }
    } catch (e) {
      print('Error parsing amount: ${e.toString()}');
    }

    return amount.value;
  }

  paymentAmountInput(String value) {
    paymentAmount.text = value;
    // Get.snackbar('Success', paymentAmount.text.toString());
    return double.tryParse(paymentAmount.text);
  }

  ///recipeint reference screen
  void recipientReference(String value) {
    recipientReferenceInput.text = value;
    var recipientDetails = recipientReferenceInput.text;
    print(recipientDetails);
    //Get.snackbar('Sucess', recipientDetails.toString());
  }

  void recipientOptional(String value) {
    recipientOptionalInput.text = value;
    var recipientOptional = recipientOptionalInput.text;
    print(recipientOptional);
    // Get.snackbar('Sucess', recipientOptional.toString());
  }

// get current date
  String currentDate() {
    DateTime now = DateTime.now();
    date.value = DateFormat('yyyy-MM-dd - kk:mm').format(now);
    print(date.value);
    return date.value;
  }

  void choiceChipSelected(String value) {
    choiceSelected.value = value;
    category.value = value;
  }

//approval screen

// start credit transfer api
  void creditTransferApi() {
    try {
      var ticket = debtTicket.value;
      var pembayarBankAccount = debtorBankDetails.value;
      if (ticket != null) {
        debtorName.value = ticket['debtor'];
        debtorAccount.value = pembayarBankAccount?['AccountNumber'];
        creditorAccount.value = ticket['bankAccountNumber'];
        creditorName.value = ticket['creditor'];
        bankAccount.value = pembayarBankAccount?['BankName'];
        print('Debtor: ${debtorName.value}');
        print('Debtor Bank Account: ${debtorAccount.value}');
      }

      CreditTransfer creditTransfer = CreditTransfer(
          debtorAccount: debtorAccount.string,
          creditorName: debtorName.string,
          creditorAccount: creditorAccount.string,
          amount: amount.string,
          debtorName: creditorName.string,
          bankAccount: bankAccount.string);
      creditTransfer.sendPostRequest();
    } catch (e) {
      Get.snackbar('error api', e.toString());
    }
  }

//create payment doc
  Future<void> addPaymentDetails() async {
    generatePaymentId();
    var createdDateTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(DateTime.now());
    double parsedAmount = amount.value;
    var paymentInstances = PaymentModel(
      amount: parsedAmount,
      creditorUserId: creditorName.value,
      date: createdDateTime,
      debtTicketId: debtTicketId.value,
      debtorUserId: debtorName.value,
      paymentId: paymentId.value,
      references: recipientReferenceInput.text,
      optionalReferences: recipientOptionalInput.text,
      category: category.value,
    );

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;

        if (choiceSelected.value == 'Food') {
          await _firestore
              .collection('Users')
              .doc(uid)
              .collection('Payment')
              .doc(uid)
              .collection('Food')
              .add(paymentInstances.toJson());
          Get.snackbar('Success', 'Payment added to Food to Firebase');
        } else if (choiceSelected.value == 'Personal') {
          await _firestore
              .collection('Users')
              .doc(uid)
              .collection('Payment')
              .doc(uid)
              .collection('Personal')
              .add(paymentInstances.toJson());
          Get.snackbar('Success', 'Payment added to Personal in Firebase');
        } else if (choiceSelected.value == 'Other') {
          await _firestore
              .collection('Users')
              .doc(uid)
              .collection('Payment')
              .doc(uid)
              .collection('Other')
              .add(paymentInstances.toJson());
          Get.snackbar('Success', 'Payment added to Other in Firebase');
        } else {
          Get.snackbar('Error', 'Invalid payment category selected');
          return;
        }

        // Add the payment instance to the local model and show success message
        paymentModel.add(paymentInstances);
        successfulFetchPayment.value = 'Success';
      } else {
        Get.snackbar('Error', 'User is not authenticated');
        successfulFetchPayment.value = 'Failed';
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  //generatedPaymentId
  String generatePaymentId() {
    Random random = Random();
    var randomId = (random.nextInt(90000) + 10000).toString();
    paymentId.value = randomId.toString();
    print(paymentId.value);
    return paymentId.value;
  }

  void nextPagePaymentAmountScreen() {
    Get.to(PaymentAmountScreen());
  }

  void nextPageRecipientReferenceScreen() {
    Get.to(RecipientReferenceScreen());
  }

  void nextPagePaymentSuccessScreen() {
    Get.to(PaymentSuccessScreen());
  }

  void nextPageApprovalScreen() {
    Get.to(ApprovalScreen());
  }

  Future<DebtTicket?> fetchLatestDebtTicket() async {
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
 Future<DebtTicket?> fetchLatestDebtTicketOwe(String debtorUsername) async {
    String debtorYouOwn = debtorUsername;

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('DebtTickets')
            .where('debtor', isEqualTo: debtorYouOwn)
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
