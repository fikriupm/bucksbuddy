import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ExpensesModel {
  final String description;
  final double amount;
  final String category;
  final DateTime date;

  //constructor
  ExpensesModel({
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'amount': amount,
      'category': category,
      'date': date,
    };
  }

  factory ExpensesModel.fromJson(Map<String, dynamic> json) {
    return ExpensesModel(
        description: json['description'],
        amount: json["amount"],
        category: json['category'],
        date: (json['date'] as Timestamp).toDate());
  }
}
