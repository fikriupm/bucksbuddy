import 'package:bucks_buddy/features/personalization/controllers/user_controller.dart';
import 'package:bucks_buddy/features/view_debt_analysis/model/expenses_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ExpensesController extends GetxController {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; //initiate firebase connection
  final RxList<ExpensesModel> expenses = <ExpensesModel>[].obs;
  UserController userController = Get.find();

  var selectedValue = 'Month'.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

//insert into database
  Future<void> addExpenses(ExpensesModel expense) async {
    try {
      await _firestore.collection('expenses').add(expense.toJson());
      expenses.add(expense);
      Get.snackbar("Sucess", 'Expense added sucessfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> loadExpenses(String user) async {
    try {
      final snapshot = await _firestore
          .collection('Users')
          .doc(user)
          .collection("Expenses")
          .get();
      expenses.value = snapshot.docs
          .map((doc) => ExpensesModel.fromJson(doc.data()))
          .toList();
      print(expenses.value);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
