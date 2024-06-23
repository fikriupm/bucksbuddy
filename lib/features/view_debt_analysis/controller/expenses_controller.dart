import 'package:bucks_buddy/features/view_debt_analysis/model/expenses_model.dart';
import 'package:capped_progress_indicator/capped_progress_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

class ExpensesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<ExpensesModel> expenses = <ExpensesModel>[].obs;
  var selectedValue = 'Month'.obs;
  //var totalAmountYouOwn = 0.0.obs; // Make totalAmount an observable
  var totalAmountYouPaid = 0.0.obs;
  var totalAmountYouReceive = 0.0.obs;
  var totalAmountYouOwnFood = 0.0.obs; // Make totalAmount an observable
  var totalAmountYouOwnPersonal = 0.0.obs; // Make totalAmount an observable
  var totalAmountYouOwnOther = 0.0.obs; // Make totalAmount an observable
  var totalAmountPaidFood = 0.0.obs; // Make totalAmount an observable
  var totalAmountPaidPersonal = 0.0.obs; // Make totalAmount an observable
  var totalAmountPaidOther = 0.0.obs;
  var isLoading = true.obs; // Initialize as true to show loading indicator
  var totalAmountPeoplePaidFood = 0.0.obs;
  var totalAmountPeoplePaidPersonal = 0.0.obs;
  var totalAmountPeoplePaidOther = 0.0.obs;

  RxBool amountPaid = false.obs;

  var uid = ''.obs;
  var totalFoodYouPaid = 0.0.obs;
  var totalPersonalYouPaid = 0.0.obs;
  var totalOtherYouPaid = 0.0.obs;

  var totalFoodPeoplePaid = 0.0.obs;
  var totalPersonalPeoplePaid = 0.0.obs;
  var totalOtherPeoplePaid = 0.0.obs;

// total percent for each category
  var highestPercentYouReceive = 0.0.obs;
  var secondHighestPercentYouReceive = 0.0.obs;
  var lastPercentYouReceive = 0.0.obs;

  var radioSelectedValue = 'Amount Paid'.obs;
  var highestPercentYouPaid = 0.0.obs;
  var secondHighestPercentYouPaid = 0.0.obs;
  var lastPercentYouPaid = 0.0.obs;
  get lastPercentCategory => null;

  //amount paid category
  var highestCategoryYouPaid = ''.obs;
  var secondCategoryYouPaid = ''.obs;
  var lastCategoryYouPaid = ''.obs;
  var highestRmYouPaid = 0.0.obs;
  var secondHighestRmYouPaid = 0.0.obs;
  var lastRmYouPaid = 0.0.obs;

  //amount receive category
  var highestCategoryYouReceive = ''.obs;
  var secondCategoryYouReceive = ''.obs;
  var lastCategoryYouReceive = ''.obs;
  var highestRmYouReceive = 0.0.obs;
  var secondHighestRmYouReceive = 0.0.obs;
  var lastRmYouReceive = 0.0.obs;

  //
  var errorNoAmountReceive = ''.obs;
  var errorNoAmountPaid = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCurrentUserData();
    radioSelected('Amount Receive');
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

//payment you made
  Future<double> paymentAmountYouPaid() async {
    try {
      isLoading.value = true; // Set loading to true before fetching data

      // Simulate loading delay (replace with actual async data fetching)
      await Future.delayed(const Duration(seconds: 3));

      totalAmountYouOwnFood.value = await loadPaymentYouPaidForFood();
      totalAmountYouOwnOther.value = await loadPaymentYouPaidForOther();
      totalAmountYouOwnPersonal.value = await loadPaymentYouPaidForPersonal();
      totalAmountYouPaid.value = totalAmountYouOwnFood.value +
          totalAmountYouOwnOther.value +
          totalAmountYouOwnPersonal.value;
      isLoading.value = false;
      return totalAmountYouPaid.value;
    } catch (e) {
      print('Error loading payment amounts: $e');
      isLoading.value = false;
      return 0;
    }
  }

  //payment you receive
  Future<double> paymentAmountYouReceive() async {
    try {
      isLoading.value = true; // Set loading to true before fetching data

      // Simulate loading delay (replace with actual async data fetching)
      await Future.delayed(const Duration(seconds: 3));

      totalAmountPeoplePaidFood.value = await loadPaymentPeoplePaidForFood();
      totalAmountPeoplePaidOther.value = await loadPaymentPeoplePayForOther();
      totalAmountPeoplePaidPersonal.value =
          await loadPaymentPeoplePayForPersonal();
      totalAmountYouReceive.value = totalAmountPeoplePaidFood.value +
          totalAmountPeoplePaidOther.value +
          totalAmountPeoplePaidPersonal.value;
      print('totalAmountforfoood ${totalAmountPeoplePaidFood.value}');
      print('totalAmountfor other ${totalAmountPeoplePaidOther.value}');
      print('totalAmountfor personal ${totalAmountPeoplePaidPersonal.value}');
      print(totalAmountYouReceive.value);
      isLoading.value = false;

      return totalAmountYouReceive.value;
    } catch (e) {
      print('Error loading payment amounts: $e');
      isLoading.value = false;
      return 0;
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
          // String debtorName = snapshot['Username'];
          // print('debtorName: $debtorName');

          //for own you = org yg berhutang dgn kita
          String username = snapshot['Username'];
          String name = snapshot['Name'];
          String creditor = '$username / $name';
          // loadExpensesOwnYou(creditor);
          paymentAmountYouPaid();
          paymentAmountYouReceive();
          print('Creditor: $creditor');
        } else {
          print('Document does not exist');
        }
      }
    } catch (e) {
      print('Error retrieving data: $e');
    }
  }

  Future<void> radioSelected(String value) async {
    radioSelectedValue.value = value;
    if (radioSelectedValue.value == 'Amount Paid') {
      amountPaid.value = true;

      //amount u paid

      highestPercentYouPaid.value = highestPercentYouPaid.value;
      totalFoodYouPaid.value = await loadPaymentYouPaidForFood();
      totalPersonalYouPaid.value = await loadPaymentYouPaidForPersonal();
      totalOtherYouPaid.value = await loadPaymentYouPaidForOther();
      print('Total Food ${totalFoodYouPaid.value}');
      print('Total Personal ${totalPersonalYouPaid.value}');
      print('Total other ${totalOtherYouPaid.value}');
      determineHighestSecondAndLastYouPaid();
    } else if (radioSelectedValue.value == 'Amount Receive') {
      amountPaid.value = false;

//amount u receive
      highestPercentYouReceive.value = highestPercentYouReceive.value;

      totalFoodPeoplePaid.value = await loadPaymentPeoplePaidForFood();
      totalPersonalPeoplePaid.value = await loadPaymentPeoplePayForPersonal();
      totalOtherPeoplePaid.value = await loadPaymentPeoplePayForOther();
      print('Total Food ${totalFoodPeoplePaid.value}');
      print('Total Personal ${totalPersonalPeoplePaid.value}');
      print('Total other ${totalOtherPeoplePaid.value}');
      determineHighestSecondAndLastYouReceive();
    }
  }

//determine category score for amount receive
  Future<String> determineHighestSecondAndLastYouReceive() async {
    try {
      // Create a list of tuples containing the category and the corresponding value
      List<Map<String, dynamic>> values = [
        {'category': 'Food', 'value': totalFoodPeoplePaid.value},
        {'category': 'Personal', 'value': totalPersonalPeoplePaid.value},
        {'category': 'Other', 'value': totalOtherPeoplePaid.value},
      ];
      // Sort the list based on the value in descending order
      values.sort((a, b) => b['value'].compareTo(a['value']));

      // Extract the highest, second highest, and last
      var highest = values[0];
      var secondHighest = values[1];
      var last = values[2];

      //convert to percentage
      double totalValue = totalFoodPeoplePaid.value +
          totalPersonalPeoplePaid.value +
          totalOtherPeoplePaid.value;

      highestPercentYouReceive.value = (highest['value'] / totalValue) * 100;
      secondHighestPercentYouReceive.value =
          (secondHighest['value'] / totalValue) * 100;
      lastPercentYouReceive.value = (last['value'] / totalValue) * 100;

      //for type category
      highestCategoryYouReceive.value = highest['category'];
      secondCategoryYouReceive.value = secondHighest['category'];
      lastCategoryYouReceive.value = last['category'];

      // get RM value for each of them
      highestRmYouReceive.value = highest['value'];
      secondHighestRmYouReceive.value = secondHighest['value'];
      lastRmYouReceive.value = last['value'];

      print('highest Percent: ${highestPercentYouReceive.value}');
      print('second highest Percent: ${secondHighestPercentYouReceive.value}');
      print('Last Percent: ${lastPercentYouReceive.value}');

      print('Highest: ${highest['category']} with value ${highest['value']}');
      print(
          'Second Highest: ${secondHighest['category']} with value ${secondHighest['value']}');
      print('Last: ${last['category']} with value ${last['value']}');
    } catch (e) {
      errorNoAmountReceive.value = e.toString();
      return errorNoAmountReceive.value;
    }
    return errorNoAmountReceive.value;
    // You can use these values to update your UI or perform other logic
  }

  Future<String> determineHighestSecondAndLastYouPaid() async {
    try {
      // Create a list of tuples containing the category and the corresponding value
      List<Map<String, dynamic>> values = [
        {'category': 'Food', 'value': totalFoodYouPaid.value},
        {'category': 'Personal', 'value': totalPersonalYouPaid.value},
        {'category': 'Other', 'value': totalOtherYouPaid.value},
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
      double totalValue = totalFoodYouPaid.value +
          totalPersonalYouPaid.value +
          totalOtherYouPaid.value;

      highestPercentYouPaid.value = (highest['value'] / totalValue) * 100;
      secondHighestPercentYouPaid.value =
          (secondHighest['value'] / totalValue) * 100;
      lastPercentYouPaid.value = (last['value'] / totalValue) * 100;

      //for type category
      highestCategoryYouPaid.value = highest['category'];
      secondCategoryYouPaid.value = secondHighest['category'];
      lastCategoryYouPaid.value = last['category'];

      // get RM value for each of them
      highestRmYouPaid.value = highest['value'];
      secondHighestRmYouPaid.value = secondHighest['value'];
      lastRmYouPaid.value = last['value'];

      print('highest Percent you paid ${highestPercentYouPaid.value}');
      print(
          'Second highest Percent you paid ${secondHighestPercentYouPaid.value}');
      print('Lowest Percent you paid ${lastPercentYouPaid.value}');

      print('Highest: ${highest['category']} with value ${highest['value']}');
      print(
          'Second Highest: ${secondHighest['category']} with value ${secondHighest['value']}');
      print('Last: ${last['category']} with value ${last['value']}');
    } catch (e) {
      errorNoAmountPaid.value = e.toString();
      return errorNoAmountPaid.value;
    }
    return errorNoAmountPaid.value;
    // You can use these values to update your UI or perform other logic
  }

  // view food expenses You Owe
  Future<double> loadPaymentYouPaidForFood() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        uid.value = user
            .uid; // Query the 'DebtTickets' subcollection for the current user
        QuerySnapshot<Map<String, dynamic>> expensesSnapshot =
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(uid.value)
                .collection('Payment')
                .doc(uid.value)
                .collection('Food')
                .get();

        double totalAmount = 0.0;

        // Check if there are any matching documents
        if (expensesSnapshot.docs.isNotEmpty) {
          for (var docSnapshot in expensesSnapshot.docs) {
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

        totalAmountYouOwnFood.value = totalAmount;

        // Print the total amount
        print(
            'Total Amount ko bayar hutang for food: ${totalAmountYouOwnFood.value}');
        return totalAmountYouOwnFood.value;
      } else {
        print('User is not authenticated');
        return 0.0;
      }
    } catch (e) {
      print('Error completing: $e');
      return 0.0;
    }
  }

  //expenses personal category You Owe
  Future<double> loadPaymentYouPaidForPersonal() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        uid.value = user
            .uid; // Query the 'DebtTickets' subcollection for the current user
        QuerySnapshot<Map<String, dynamic>> expensesSnapshot =
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(uid.value)
                .collection('Payment')
                .doc(uid.value)
                .collection('Personal')
                .get();

        double totalAmount = 0.0;

        // Check if there are any matching documents
        if (expensesSnapshot.docs.isNotEmpty) {
          for (var docSnapshot in expensesSnapshot.docs) {
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

        totalAmountYouOwnPersonal.value = totalAmount;

        // Print the total amount
        print(
            'Total Amount ko byr hutang org for personal: ${totalAmountYouOwnPersonal.value}');
        return totalAmountYouOwnPersonal.value;
      } else {
        print('User is not authenticated');
        return 0.0;
      }
    } catch (e) {
      print('Error completing: $e');
      return 0.0;
    }
  }

  //expenses for other category You Owe
  Future<double> loadPaymentYouPaidForOther() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        uid.value = user
            .uid; // Query the 'DebtTickets' subcollection for the current user
        QuerySnapshot<Map<String, dynamic>> expensesSnapshot =
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(uid.value)
                .collection('Payment')
                .doc(uid.value)
                .collection('Other')
                .get();

        double totalAmount = 0.0;

        // Check if there are any matching documents
        if (expensesSnapshot.docs.isNotEmpty) {
          for (var docSnapshot in expensesSnapshot.docs) {
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

        totalAmountYouOwnOther.value = totalAmount;

        // Print the total amount
        print(
            'Total Amount ko hutang org for other: ${totalAmountYouOwnOther.value}');
        return totalAmountYouOwnOther.value;
      } else {
        print('User is not authenticated');
        return 0.0;
      }
    } catch (e) {
      print('Error completing: $e');
      return 0.0;
    }
  }

// load payment people paid for you for food category

  Future<double> loadPaymentPeoplePaidForFood() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Get current user ID
        String currentUserId = user.uid;

        // Initialize totalAmount
        double totalAmount = 0.0;

        // Retrieve all user documents from the 'Users' collection except the current user
        QuerySnapshot<Map<String, dynamic>> usersSnapshot =
            await _firestore.collection('Users').get();

        for (var userDoc in usersSnapshot.docs) {
          if (userDoc.id == currentUserId) {
            // Skip the current user
            continue;
          }

          String uid = userDoc.id;
          QuerySnapshot<Map<String, dynamic>> paymentCategorySnapshot =
              await _firestore
                  .collection('Users')
                  .doc(uid)
                  .collection('Payment')
                  .doc(uid)
                  .collection('Food')
                  .get();

          if (paymentCategorySnapshot.docs.isNotEmpty) {
            for (var docSnapshot in paymentCategorySnapshot.docs) {
              Map<String, dynamic> data = docSnapshot.data();

              // Access specific fields
              String category = data['category'] ?? 'No category';
              var amount =
                  data['amount'] ?? 0; // Make this variable type dynamic

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
            print('No documents found matching the query for user: $uid');
          }
        }

        // Update the observable with the total amount
        totalAmountPeoplePaidFood.value = totalAmount;

        // Print the total amount
        print(
            'Total Amount ko bayar hutang for food: ${totalAmountPeoplePaidFood.value}');
        return totalAmountPeoplePaidFood.value;
      } else {
        print('User is not authenticated');
        return 0.0;
      }
    } catch (e) {
      print('Error completing: $e');
      return 0.0;
    }
  }

  // load payment people paid for you for personal category

  Future<double> loadPaymentPeoplePayForPersonal() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Get current user ID
        String currentUserId = user.uid;

        // Initialize totalAmount outside the loop
        double totalAmount = 0.0;

        // Retrieve all user documents from the 'Users' collection
        QuerySnapshot<Map<String, dynamic>> usersSnapshot =
            await _firestore.collection('Users').get();

        for (var userDoc in usersSnapshot.docs) {
          if (userDoc.id == currentUserId) {
            // Skip the current user
            continue;
          }

          String uid = userDoc.id;
          QuerySnapshot<Map<String, dynamic>> paymentCategorySnapshot =
              await _firestore
                  .collection('Users')
                  .doc(uid)
                  .collection('Payment')
                  .doc(uid)
                  .collection('Personal')
                  .get();

          if (paymentCategorySnapshot.docs.isNotEmpty) {
            for (var docSnapshot in paymentCategorySnapshot.docs) {
              Map<String, dynamic> data = docSnapshot.data();

              // Access specific fields
              String category = data['category'] ?? 'No category';
              var amount =
                  data['amount'] ?? 0; // Make this variable type dynamic

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
            print('No documents found matching the query for user: $uid');
          }
        }

        // Update the observable with the total amount
        totalAmountPeoplePaidPersonal.value = totalAmount;

        // Print the total amount
        print(
            'Total Amount people paid for personal: ${totalAmountPeoplePaidPersonal.value}');
        return totalAmountPeoplePaidPersonal.value;
      } else {
        print('User is not authenticated');
        return 0.0;
      }
    } catch (e) {
      print('Error completing: $e');
      return 0.0;
    }
  }

  Future<double> loadPaymentPeoplePayForOther() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Get current user ID
        String currentUserId = user.uid;

        // Initialize totalAmount outside the loop
        double totalAmount = 0.0;

        // Retrieve all user documents from the 'Users' collection
        QuerySnapshot<Map<String, dynamic>> usersSnapshot =
            await _firestore.collection('Users').get();

        for (var userDoc in usersSnapshot.docs) {
          String uid = userDoc.id;

          // Skip the current user
          if (uid == currentUserId) {
            continue;
          }

          // Query payments under 'Other' category for each user
          QuerySnapshot<Map<String, dynamic>> paymentCategorySnapshot =
              await _firestore
                  .collection('Users')
                  .doc(uid)
                  .collection('Payment')
                  .doc(uid)
                  .collection('Other')
                  .get();

          if (paymentCategorySnapshot.docs.isNotEmpty) {
            // Process each payment document
            for (var docSnapshot in paymentCategorySnapshot.docs) {
              Map<String, dynamic> data = docSnapshot.data();

              // Access specific fields
              String category = data['category'] ?? 'No category';
              var amount =
                  data['amount'] ?? 0; // Make this variable type dynamic

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
            print('No documents found matching the query for user: $uid');
          }
        }

        // Update the observable with the total amount
        totalAmountPeoplePaidOther.value = totalAmount;

        // Print the total amount
        print(
            'Total Amount people paid for other: ${totalAmountPeoplePaidOther.value}');
        return totalAmountPeoplePaidOther.value;
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
