import 'package:cloud_firestore/cloud_firestore.dart';

class BankAccountModel {

  String id;
  final String bankName;
  final String accountNumber;
  bool selectedBank;

  BankAccountModel({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    this.selectedBank = true
  });

  static BankAccountModel empty() => BankAccountModel(id: '', bankName: '', accountNumber: '');

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'BankName': bankName,
      'AccountNumber': accountNumber,
      'SelectedBank': selectedBank,
    };
  }

  factory BankAccountModel.fromMap(Map<String, dynamic> data){
    return BankAccountModel(
      id: data['Id'] as String,
      bankName: data['BankName'] as String,
      accountNumber: data['AccountNumber'] as String,
      selectedBank: data['SelectedBank'] as bool,
    );
  }

  //factory constructor to create an BankAccountModel from a DocumentSnapshot
  factory BankAccountModel.fromSnapshot(DocumentSnapshot snapshot){
    final data = snapshot.data() as Map<String, dynamic>;

    return BankAccountModel(
      id: snapshot.id,
      bankName: data['BankName'] ?? '',
      accountNumber: data['AccountNumber'] ?? '',
      selectedBank: data['SelectedBank'] ?? false,      
    );
  }

  @override
  String toString(){
    return '$accountNumber';
  } 
}