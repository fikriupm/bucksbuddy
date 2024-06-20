import 'package:bucks_buddy/expenses_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpensesController extends GetxController {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; //initiate firebase connection
  final RxList<ExpensesModel> expenses = <ExpensesModel>[].obs;

  var selectedValue = 'Month'.obs;

  @override
  void onInit() {
    super.onInit();
    loadExpenses();
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

  Future<void> loadExpenses() async {
    try {
      final snapshot = await _firestore.collection('expenses').get();
      expenses.value = snapshot.docs
          .map((doc) => ExpensesModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
