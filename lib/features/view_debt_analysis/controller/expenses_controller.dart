import 'dart:ffi';

import 'package:bucks_buddy/features/personalization/controllers/user_controller.dart';
import 'package:bucks_buddy/features/view_debt_analysis/model/expenses_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ExpensesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<ExpensesModel> expenses = <ExpensesModel>[].obs;
  UserController userController = Get.find();

  var selectedValue = 'Month'.obs;
  var totalAmountYouOwn = 0.0.obs; // Make totalAmount an observable
  var totalAmountOwnYou = 0.0.obs;
  var totalAmountOwnYouFood = 0.0.obs; // Make totalAmount an observable
  var totalAmountOwnYouPersonal = 0.0.obs; // Make totalAmount an observable
  var totalAmountOwnYouOther = 0.0.obs; // Make totalAmount an observable
//pai percentage
  var highestPercent = 0.0.obs;
  var secondHighestPercent = 0.0.obs;
  var lastPercent = 0.0.obs;

  var highestCategory = ''.obs;
  var secondCategory = ''.obs;
  var lastPercentCategory = ''.obs;

  var uid = ''.obs;
  var totalFood = 0.0.obs;
  var totalPersonal = 0.0.obs;
  var totalOther = 0.0.obs;

  //
  var radioSelectedValue = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCurrentUserData();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Insert into database
  Future<void> addExpenses(ExpensesModel expense) async {
    try {
      await _firestore.collection('expenses').add(expense.toJson());
      expenses.add(expense);
      Get.snackbar("Success", 'Expense added successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> loadExpensesYouOwn(String debtorName) async {
    String debtorYouOwn = debtorName;
    try {
      // Retrieve all user documents from the 'Users' collection
      QuerySnapshot<Map<String, dynamic>> usersSnapshot =
          await FirebaseFirestore.instance.collection('Users').get();

      // Reset totalAmount for each call
      totalAmountYouOwn.value = 0;

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
          print('Successfully completed for user: $userId');
          for (var docSnapshot in debtTicketsSnapshot.docs) {
            Map<String, dynamic> data = docSnapshot.data();

            // Access specific fields
            var amount = data['amount'] ?? 0; // Make this variable type dynamic
            var creditor = data['creditor'] ?? '';
            // Convert amount to double if it's a String
            if (amount is String) {
              amount = double.tryParse(amount) ?? 0.0;
            }

            // Sum the amounts
            if (amount is num) {
              totalAmountYouOwn.value += amount.toDouble();
            }

            print('Document ID: ${docSnapshot.id}');
            print('Creditor: $creditor');
            print('Amount $debtorYouOwn berhutang dgn $creditor: $amount');
          }
        } else {
          print('No documents found matching the query for user: $userId');
        }
      }

      // Print the total amount
      print('Total Amount ko berhutang: ${totalAmountYouOwn.value}');
    } catch (e) {
      print('Error completing: $e');
    }
  }

  void loadCurrentUserData() async {
    try {
      // Step 1: Get the current user's UID
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        uid.value = user.uid;

        // Step 2: Query Firestore using the UID and specific document ID
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await _firestore.collection('Users').doc(uid.value).get();

        // Step 3: Assign the fetched document to the Rx variable
        if (snapshot.exists) {
          String debtorName = snapshot['Username'];
          //print('debtorName: $debtorName');
          loadExpensesYouOwn(debtorName);

          //for own you = org yg berhutang dgn kita
          String username = snapshot['Username'];
          String name = snapshot['Name'];
          String creditor = '$username / $name';
          loadExpensesOwnYou(creditor);
          print('Creditor: $creditor');
        } else {
          print('Document does not exist');
        }
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }
  }

  //for Own You

  Future<void> loadExpensesOwnYou(String creditor) async {
    String creditorName = creditor;
    try {
      // Query the 'DebtTickets' subcollection for the current user
      QuerySnapshot<Map<String, dynamic>> debtTicketsSnapshot =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(uid.value)
              .collection('DebtTickets')
              .where('creditor', isEqualTo: creditorName)
              .get();

      // Check if there are any matching documents
      if (debtTicketsSnapshot.docs.isNotEmpty) {
        for (var docSnapshot in debtTicketsSnapshot.docs) {
          String debtorOwnYou;
          Map<String, dynamic> data = docSnapshot.data();

          // Access specific fields
          debtorOwnYou = data['debtor'] ?? 'No creditor';
          var amount = data['amount'] ?? 0; // Make this variable type dynamic

          // Convert amount to double if it's a String
          if (amount is String) {
            amount = double.tryParse(amount) ?? 0.0;
          }

          // Sum the amounts
          if (amount is num) {
            totalAmountOwnYou.value += amount.toDouble();
          }

          print('Document ID: ${docSnapshot.id}');
          print('Debtor: $debtorOwnYou');
          print('Amount $debtorOwnYou berhutang dgn $creditorName: $amount');
        }
      } else {
        print('No documents found matching the query for $creditorName');
      }

      // Print the total amount
      print('Total Amount org hutang ko: ${totalAmountOwnYou.value}');
    } catch (e) {
      print('Error completing: $e');
    }
  }

  Future<void> radioSelected(String value) async {
    radioSelectedValue.value = value;
    if (radioSelectedValue.value == 'You Owe') {
      //sambung esok
      print('You Owe');
    } else if (radioSelectedValue.value == 'Owe You') {
      totalFood.value = await loadPaymentMadeForFood();
      totalPersonal.value = await loadPaymentMadeForPersonal();
      totalOther.value = await loadPaymentMadeForOther();
      print('Total Food ${totalFood.value}');
      print('Total Personal ${totalPersonal.value}');
      print('Total other ${totalOther.value}');
      determineHighestSecondAndLast();
    }
  }

  void determineHighestSecondAndLast() {
    // Create a list of tuples containing the category and the corresponding value
    List<Map<String, dynamic>> values = [
      {'category': 'Food', 'value': totalFood.value},
      {'category': 'Personal', 'value': totalPersonal.value},
      {'category': 'Other', 'value': totalOther.value},
    ];
// The comparison function determines the order of elements in the list. It takes two elements (a and b) and returns:
// A negative number if a should come before b.
// Zero if a and b are equal in terms of ordering.
// A positive number if a should come after b.
// By using b[1].compareTo(a[1]) instead of a[1].compareTo(b[1]), the list is sorted in descending order. This is because:
// If b[1] is greater than a[1], compareTo will return a positive number, meaning b should come before a in the sorted list.
// If b[1] is less than a[1], compareTo will return a negative number, meaning a should come before b.

    // Sort the list based on the value in descending order
    values.sort((a, b) => b['value'].compareTo(a['value']));

    // Extract the highest, second highest, and last
    var highest = values[0];
    var secondHighest = values[1];
    var last = values[2];

    //convert to percentage
    double totalValue =
        totalFood.value + totalPersonal.value + totalOther.value;

    highestPercent.value = (highest['value'] / totalValue) * 100;
    secondHighestPercent.value = (secondHighest['value'] / totalValue) * 100;
    lastPercent.value = (last['value'] / totalValue) * 100;

    //for text category
    highestCategory.value = highest['category'];
    secondCategory.value = secondHighest['category'];
    lastPercentCategory.value = last['category'];

    print('highestPercent $highestPercent');
    print('Highest: ${highest['category']} with value ${highest['value']}');
    print(
        'Second Highest: ${secondHighest['category']} with value ${secondHighest['value']}');
    print('Last: ${last['category']} with value ${last['value']}');

    // You can use these values to update your UI or perform other logic
  }

  // view food payment made
  Future<double> loadPaymentMadeForFood() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        uid.value = user
            .uid; // Query the 'DebtTickets' subcollection for the current user
        QuerySnapshot<Map<String, dynamic>> debtTicketsSnapshot =
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(uid.value)
                .collection('Payment')
                .doc(uid.value)
                .collection('Food')
                .get();

        double totalAmount = 0.0;

        // Check if there are any matching documents
        if (debtTicketsSnapshot.docs.isNotEmpty) {
          for (var docSnapshot in debtTicketsSnapshot.docs) {
            Map<String, dynamic> data = docSnapshot.data();

            // Access specific fields
            String category = data['category'] ?? 'No creditor';
            var amount = data['amount'] ?? 0; // Make this variable type dynamic

            // Convert amount to double if it's a String
            if (amount is String) {
              amount = double.tryParse(amount) ?? 0.0;
            }

            // Sum the amounts
            if (amount is num) {
              totalAmount += amount.toDouble();
            }

            print('Document ID: ${docSnapshot.id}');
            print('category: $category');
            print('amount: $amount');
          }
        } else {
          print('No documents found matching the query for you');
        }

        totalAmountOwnYouFood.value = totalAmount;

        // Print the total amount
        print(
            'Total Amount org hutang ko for food: ${totalAmountOwnYouFood.value}');
        return totalAmountOwnYouFood.value;
      } else {
        print('User is not authenticated');
        return 0.0;
      }
    } catch (e) {
      print('Error completing: $e');
      return 0.0;
    }
  }

  //payment y make for personal category
  Future<double> loadPaymentMadeForPersonal() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        uid.value = user
            .uid; // Query the 'DebtTickets' subcollection for the current user
        QuerySnapshot<Map<String, dynamic>> debtTicketsSnapshot =
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(uid.value)
                .collection('Payment')
                .doc(uid.value)
                .collection('Personal')
                .get();

        double totalAmount = 0.0;

        // Check if there are any matching documents
        if (debtTicketsSnapshot.docs.isNotEmpty) {
          for (var docSnapshot in debtTicketsSnapshot.docs) {
            Map<String, dynamic> data = docSnapshot.data();

            // Access specific fields
            String category = data['category'] ?? 'No creditor';
            var amount = data['amount'] ?? 0; // Make this variable type dynamic

            // Convert amount to double if it's a String
            if (amount is String) {
              amount = double.tryParse(amount) ?? 0.0;
            }

            // Sum the amounts
            if (amount is num) {
              totalAmount += amount.toDouble();
            }

            print('Document ID: ${docSnapshot.id}');
            print('category: $category');
            print('amount: $amount');
          }
        } else {
          print('No documents found matching the query for you');
        }

        totalAmountOwnYouPersonal.value = totalAmount;

        // Print the total amount
        print(
            'Total Amount org hutang ko for personal: ${totalAmountOwnYouPersonal.value}');
        return totalAmountOwnYouPersonal.value;
      } else {
        print('User is not authenticated');
        return 0.0;
      }
    } catch (e) {
      print('Error completing: $e');
      return 0.0;
    }
  }

  //payment y make for other category
  Future<double> loadPaymentMadeForOther() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        uid.value = user
            .uid; // Query the 'DebtTickets' subcollection for the current user
        QuerySnapshot<Map<String, dynamic>> debtTicketsSnapshot =
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(uid.value)
                .collection('Payment')
                .doc(uid.value)
                .collection('Other')
                .get();

        double totalAmount = 0.0;

        // Check if there are any matching documents
        if (debtTicketsSnapshot.docs.isNotEmpty) {
          for (var docSnapshot in debtTicketsSnapshot.docs) {
            Map<String, dynamic> data = docSnapshot.data();

            // Access specific fields
            String category = data['category'] ?? 'No creditor';
            var amount = data['amount'] ?? 0; // Make this variable type dynamic

            // Convert amount to double if it's a String
            if (amount is String) {
              amount = double.tryParse(amount) ?? 0.0;
            }

            // Sum the amounts
            if (amount is num) {
              totalAmount += amount.toDouble();
            }

            print('Document ID: ${docSnapshot.id}');
            print('category: $category');
            print('amount: $amount');
          }
        } else {
          print('No documents found matching the query for you');
        }

        totalAmountOwnYouOther.value = totalAmount;

        // Print the total amount
        print(
            'Total Amount org hutang ko for other: ${totalAmountOwnYouOther.value}');
        return totalAmountOwnYouOther.value;
      } else {
        print('User is not authenticated');
        return 0.0;
      }
    } catch (e) {
      print('Error completing: $e');
      return 0.0;
    }
  }
}
