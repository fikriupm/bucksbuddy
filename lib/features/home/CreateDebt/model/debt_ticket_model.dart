// debt_ticket_model.dart
class DebtTicket {
  final String creditor;
  final String debtor;
  final String phoneNumber;
  final String amount;
  final String bankAccount;
  final String bankAccountNumber;
  final String reference;
  final String dateTime;
  final String status;
  // final String debtTicketId;

  DebtTicket({
    required this.creditor,
    required this.debtor,
    required this.phoneNumber,
    required this.amount,
    required this.bankAccount,
    required this.bankAccountNumber,
    required this.reference,
    required this.dateTime,
    required this.status,
    // required this.debtTicketId
  });

  Map<String, dynamic> toJson() {
    return {
      'creditor': creditor,
      'debtor': debtor,
      'phoneNumber': phoneNumber,
      'amount': amount,
      'bankAccount': bankAccount,
      'bankAccountNumber': bankAccountNumber,
      'reference': reference,
      'dateTime': dateTime,
      'status': status,
      //'debtTicketId': debtTicketId
    };
  }

  factory DebtTicket.fromJson(Map<String, dynamic> json) {
    return DebtTicket(
      creditor: json['creditor'] as String? ?? '',
      debtor: json['debtor'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      amount: (json['amount']) as String? ?? '',
      bankAccount: json['bankAccount'] as String? ?? '',
      bankAccountNumber: json['bankAccountNumber'] as String? ?? '',
      reference: json["reference"] as String? ?? '',
      dateTime: json['dateTime'] as String? ?? '',
      status: json['status'] as String? ?? '',
      // debtTicketId: json['debtTicketId']
    );
  }
}
