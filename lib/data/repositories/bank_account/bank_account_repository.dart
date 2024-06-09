import 'package:bucks_buddy/data/repositories/authentication/authentication_repository.dart';
import 'package:bucks_buddy/features/personalization/models/bank_account_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BankAccountRepositories extends GetxController {
  static BankAccountRepositories get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<BankAccountModel>> fetchUserBankAccount() async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      if (userId.isEmpty) {
        throw 'Unable to find user information. Try again in few minutes.';
      }

      final result = await _db
          .collection('Users')
          .doc(userId)
          .collection('Banks')
          .get();
      return result.docs
          .map((documentSnapshot) =>
              BankAccountModel.fromSnapshot(documentSnapshot))
          .toList();
    } catch (e) {
      throw 'Something went wrong while fetching Account Transaction Information. Please try again';
    }
  }

  //Clear the Selected field for all banks
  Future<void> updateSelectedField(String bankId, bool selected) async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      await _db
          .collection('Users')
          .doc(userId)
          .collection('Banks')
          .doc(bankId)
          .update({'Selectedbank': selected});
    } catch (e) {
      throw 'Unable to update your Bank Account Selection. Try again later.';
    }
  }

  Future<String> addBank(BankAccountModel bank) async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      final currentAddress = await _db
          .collection('Users')
          .doc(userId)
          .collection('Banks')
          .add(bank.toJson());
      return currentAddress.id;
    } catch (e) {
      throw 'Something went wrong while saving Address Information. Try again later';
    }
  }
}
