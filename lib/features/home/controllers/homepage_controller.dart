import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();
  var totalAmountYouOwn = 0.0.obs; // Make totalAmount an observable
  var totalAmountOwnYou = 0.0.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool isOweYouSelected = false.obs; // Track if "Owe You" button is selected
  RxBool isYouOweSelected = true.obs;

  // for friend image and name
  var friendNames = <String>[].obs;
  var friendImages = <String>[].obs;

  var currentselected = 'You Owe'.obs;
  @override
  void onInit() {
    super.onInit();
    fetchAllFriends();
    //loadCurrentUserData();
  }

  Future<void> loadBalanceDebtYouOwn(String debtorName) async {
    String debtorYouOwn = debtorName;
    totalAmountYouOwn.value = 0.0;
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
        QuerySnapshot<Map<String, dynamic>> balanceDebtSnapshot =
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(userId)
                .collection('DebtTickets')
                .where('debtor', isEqualTo: debtorYouOwn)
                .where('status', isEqualTo: 'not_paid')
                .get();

        // Check if there are any matching documents
        if (balanceDebtSnapshot.docs.isNotEmpty) {
          print('Successfully completed for user: $userId');
          for (var docSnapshot in balanceDebtSnapshot.docs) {
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
            print('expenses You own');

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

  Future<void> loadCurrentUserData() async {
    try {
      // Step 1: Get the current user's UID
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        var uid = user.uid;

        // Step 2: Query Firestore using the UID and specific document ID
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await _firestore.collection('Users').doc(uid).get();

        // Step 3: Assign the fetched document to the Rx variable
        if (snapshot.exists) {
          String debtorName = snapshot['Username'];
          //print('debtorName: $debtorName');

          //for own you = org yg berhutang dgn kita
          String username = snapshot['Username'];
          String name = snapshot['Name'];
          String creditor = '$username / $name';
          if (currentselected.value == 'You Owe') {
            loadBalanceDebtYouOwn(debtorName);
          } else if (currentselected.value == 'Owe You') {
            loadExpensesOwnYou(creditor);
          } else {
            print('null');
          }
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
    totalAmountOwnYou.value = 0.0;
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        var uid = user.uid;
        // Query the 'DebtTickets' subcollection for the current user
        QuerySnapshot<Map<String, dynamic>> expensesSnapshot =
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(uid)
                .collection('DebtTickets')
                .where('creditor', isEqualTo: creditorName)
                .where('status', isEqualTo: 'not_paid')
                .get();

        // Check if there are any matching documents
        if (expensesSnapshot.docs.isNotEmpty) {
          for (var docSnapshot in expensesSnapshot.docs) {
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
            print('expenses Own You');
            print('Document ID: ${docSnapshot.id}');
            print('Debtor: $debtorOwnYou');
            print('Amount $debtorOwnYou berhutang dgn $creditorName : $amount');
          }
        } else {
          // print('No documents found matching the query for $creditorName');
        }

        // Print the total amount
        print('Total Amount org hutang ko: ${totalAmountOwnYou.value}');
      } catch (e) {
        print('Error completing: $e');
      }
    }
  }

  Future<void> fetchAllFriends() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      // Retrieve all user documents from the 'Users' collection
      List<String> fetchedFriendNames = [];
      List<String> fetchedFriendImages = [];
      if (user != null) {
        var uid = user.uid;
        // Query the 'Users' document for the current user
        DocumentSnapshot<Map<String, dynamic>> friendsSnapshot =
            await FirebaseFirestore.instance.collection('Users').doc(uid).get();

        // Check if the document exists
        if (friendsSnapshot.exists) {
          var friendsData = friendsSnapshot.data();

          // Check if the data is not null and contains the 'friends' key
          if (friendsData != null && friendsData['friends'] != null) {
            var friendsList = friendsData['friends'] as List;

            // Iterate through each friend map
            for (var friend in friendsList) {
              if (friend is Map<String, dynamic>) {
                // Extract and store the friend's username
                if (friend['friendUsername'] != null) {
                  fetchedFriendNames.add(friend['friendUsername'] as String);
                }
                // Extract and store the friend's profile picture if available
                if (friend['friendProfilePicture'] != null) {
                  fetchedFriendImages
                      .add(friend['friendProfilePicture'] as String);
                } else {
                  // Add a default or placeholder image if profile picture is not available
                  fetchedFriendImages.add(
                      'default_image_url'); // replace with your default image URL
                }
              }
            }
          } else {
            print("The 'friends' field is missing in document");
          }
        } else {
          print("No document found for userId: $uid");
        }
      }

      // Update the observable lists
      friendNames.assignAll(fetchedFriendNames);
      friendImages.assignAll(fetchedFriendImages);
    } catch (e) {
      print('Error completing: $e');
    }
  }
}
