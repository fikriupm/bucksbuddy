import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/services/text_input.dart';

class PaymentModel {
  double? amount;
  String? creditorUserId;
  String? date;
  String? debtTicketId;
  String? debtorUserId;
  String? paymentId;
  String? references;
  String? optionalReferences;

  String? category;

  PaymentModel({
    this.amount,
    this.creditorUserId,
    this.date,
    this.debtTicketId,
    this.debtorUserId,
    this.paymentId,
    this.references,
    this.optionalReferences,
    this.category,
  });

  // from database using JSON
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
        amount: json['amount']?.toDouble(),
        creditorUserId: json['creditor_user_id'],
        date: json['dateTime'],
        debtTicketId: json['debt_ticket_id'],
        debtorUserId: json['debtor_user_id'],
        paymentId: json['payment_id'],
        references: json['references'],
        optionalReferences: json['optionalrReferences'],
        category: json['category']);
  }

  // store to Firebase
  Map<String, dynamic> toJson() {
    return {
      if (amount != null) 'amount': amount,
      if (creditorUserId != null) 'creditor_user_id': creditorUserId,
      if (date != null) 'date': date,
      if (debtTicketId != null) 'debt_ticket_id': debtTicketId,
      if (debtorUserId != null) 'debtor_user_id': debtorUserId,
      if (paymentId != null) 'payment_id': paymentId,
      if (references != null) 'references': references,
      if (optionalReferences != null) 'optionalrReferences': optionalReferences,
      if (category != null) 'category': category,
    };
  }
}
