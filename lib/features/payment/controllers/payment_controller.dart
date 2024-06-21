import 'dart:math';

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
  Rx<DocumentSnapshot<Map<String, dynamic>>?> creditorBankDetails =
      Rx<DocumentSnapshot<Map<String, dynamic>>?>(null);
  RxList<PaymentModel> paymentModel = <PaymentModel>[].obs;

  String? debtoruid;
  var amount = ''.obs;
  var creditorName = ''.obs;
  var creditorAccount = ''.obs;
  var debtorName = ''.obs;
  var bankAccount = ''.obs;
  var debtTicketId = ''.obs;
  var category = ''.obs;
  var paymentId = ''.obs;
  var date = ''.obs;

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
    fetchDebtTicket();
    fetchCreditorBanksDetails();
    generatePaymentId();
  }

  void fetchDebtTicket() async {
    try {
      // Step 1: Get the current user's UID
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;

        // Step 2: Query Firestore using the UID and specific document ID
        DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
            .collection('Users')
            .doc(uid)
            .collection('DebtTickets')
            .doc(
                'Pv3ZWn2h9Vt6a45m2Hr9') // Replace with your specific document ID
            .get();

        // Step 3: Assign the fetched document to the Rx variable
        if (snapshot.exists) {
          debtTicket.value = snapshot;
          fetchDebtorDetails(snapshot['debtor']);
          paymentAmountInput(snapshot['amount']);
          actualAmount(snapshot['amount']);
          creditorAccount.value = snapshot['bankAccountNumber'];
          creditorName.value = snapshot['creditor'];
          amount.value = snapshot['amount'];
          debtorName.value = snapshot['debtor'];
          bankAccount.value = snapshot['bankAccount'];
          debtTicketId.value = snapshot.id;
        } else {
          debtTicket.value = null;
          print('Document does not exist');
        }
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }
  }

  void fetchDebtorDetails(String debtorUsername) async {
    try {
      // Step 4: Query Firestore to get all users
      QuerySnapshot userSnapshot = await _firestore
          .collection('Users')
          .where('Username', isEqualTo: debtorUsername)
          .limit(1)
          .get();

      // Step 5: Iterate through each document in the user snapshot
      if (userSnapshot.docs.isNotEmpty) {
        debtoruid = userSnapshot.docs.first.id;
        // print(uid);
        fetchDebtorBanksDetails(debtoruid!);

        user.value =
            userSnapshot.docs.first as DocumentSnapshot<Map<String, dynamic>>?;
      } else {
        user.value = null;
        print('Debtor user does not exist');
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }
  }

  Future<void> fetchDebtorBanksDetails(String debtorUid) async {
    try {
      // Step 4: Query Firestore to get all banks for the debtor
      QuerySnapshot<Map<String, dynamic>> debtorBankSnapshot = await _firestore
          .collection('Users')
          .doc(debtorUid)
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

  Future<void> fetchCreditorBanksDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String uid = user.uid;
        QuerySnapshot<Map<String, dynamic>> creditorBankSnapshot =
            await _firestore
                .collection('Users')
                .doc(uid)
                .collection('Banks')
                .get();

        // Step 5: Check if there are any documents
        if (creditorBankSnapshot.docs.isNotEmpty) {
          creditorBankDetails.value = creditorBankSnapshot.docs.first
              as DocumentSnapshot<Map<String, dynamic>>?;
          print(creditorBankDetails.value);
        }
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
    double? actual = actualAmount(amount.value);

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

  actualAmount(String value) {
    amount.value = value;
    print(amount.value);
    return double.tryParse(amount.value);
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
      CreditTransfer creditTransfer = CreditTransfer(
          creditorAccount: creditorAccount.string,
          creditorName: creditorName.string,
          amount: amount.string,
          debtorName: debtorName.string,
          bankAccount: bankAccount.string);
      creditTransfer.sendPostRequest();
    } catch (e) {
      Get.snackbar('error api', e.toString());
    }
  }

//create payment doc
  Future<void> addPaymentDetails() async {
    var createdDateTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(DateTime.now());
    double parsedAmount = double.tryParse(amount.value) ?? 0.0;
    var paymentInstances = PaymentModel(
      amount: parsedAmount,
      creditorUserId: creditorName.value,
      date: createdDateTime,
      debtTicketId: debtTicketId.value,
      debtorUserId: debtorName.value,
      paymentId: paymentId.value,
      references: recipientReferenceInput.text,
      optionalrReferences: recipientOptionalInput.text,
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
  void generatePaymentId() {
    Random random = Random();
    var randomId = (random.nextInt(90000) + 10000).toString();
    paymentId.value = randomId.toString();
    print(paymentId.value);
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
}
