import 'package:bucks_buddy/data/repositories/bank_account/bank_account_repository.dart';
import 'package:bucks_buddy/features/personalization/models/bank_account_model.dart';
import 'package:bucks_buddy/utils/constants/image_strings.dart';
import 'package:bucks_buddy/utils/helpers/network_manager.dart';
import 'package:bucks_buddy/utils/popups/full_screen_loader.dart';
import 'package:bucks_buddy/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BankAccountController extends GetxController {
  static BankAccountController get instance => Get.find();

  final bankName = TextEditingController();
  final accountNumber = TextEditingController();
  GlobalKey<FormState> bankFormKey = GlobalKey<FormState>();

  RxBool refreshData = true.obs;
  final Rx<BankAccountModel> selectedBank = BankAccountModel.empty().obs;
  final bankAccountRepositories = Get.put(BankAccountRepositories());

  /// Fetch all user specific addresses
  Future<List<BankAccountModel>> getAllUserBankAccount() async {
    try {
      final bankAccount = await bankAccountRepositories.fetchUserBankAccount();
      selectedBank.value = bankAccount.firstWhere(
          (element) => element.selectedBank,
          orElse: () => BankAccountModel.empty());
      return bankAccount;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Account not found', message: e.toString());
      return [];
    }
  }

  Future selectBank(BankAccountModel newSelectBank) async{
    try{
      Get.defaultDialog(
        title: '',
        onWillPop: () async {return false;},
        barrierDismissible: false,
        backgroundColor: Colors.transparent,
        // content: const TCircularLoader(),
      );
      //clear the selected field
      if (selectedBank.value.id.isNotEmpty) {
        await bankAccountRepositories.updateSelectedField(selectedBank.value.id, false);
      }

      //assign selectedbank
      newSelectBank.selectedBank = true;
      selectedBank.value = newSelectBank;

      //set the selected field to true fo the newly selected address
      await bankAccountRepositories.updateSelectedField(selectedBank.value.id, false);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error in selection', message: e.toString());
    }
  }

  ///add new bank
  Future addNewBank() async{
    try{

      //start loading
      TFullScreenLoader.openLoadingDialog('Storing Bank Account', TImages.verifyScreen);

      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }

      if(!bankFormKey.currentState!.validate()){
        TFullScreenLoader.stopLoading();
        return;
      }

      final bank = BankAccountModel(
        id: '', 
        bankName: bankName.text.trim(), 
        accountNumber: accountNumber.text.trim(),
        selectedBank: true,
      );
      final id = await bankAccountRepositories.addBank(bank);

      bank.id = id;
      await selectedBank(bank);

      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(title: 'Congratulations', message: 'Your Bank has been saved successfully.');

      refreshData.toggle();

      reserFormField();

      Navigator.of(Get.context!).pop();

    }catch (e){
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Bank not found', message: e.toString());
    }
  }
  
  void reserFormField() {
    bankName.clear();
    accountNumber.clear();
    bankFormKey.currentState?.reset();
  }
}
