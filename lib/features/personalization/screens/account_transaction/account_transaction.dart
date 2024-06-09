import 'package:bucks_buddy/common/widgets/appbar/appbar.dart';
import 'package:bucks_buddy/features/personalization/controllers/bank_account_controller.dart';
import 'package:bucks_buddy/features/personalization/controllers/user_controller.dart';
import 'package:bucks_buddy/features/personalization/screens/account_transaction/widgets/add_new_bank.dart';
import 'package:bucks_buddy/features/personalization/screens/account_transaction/widgets/selected_bank.dart';
import 'package:bucks_buddy/utils/constants/image_strings.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:bucks_buddy/utils/helpers/cloud_helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionAccountScreen extends StatelessWidget {
  const TransactionAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bankController = Get.put(BankAccountController());
    final userController = Get.put(UserController());
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          'Transaction Account',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // DuitNow Phone Number Input Field Section
              Text(
                'DuitNow Phone Number',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () {
                        return Text(
                          userController.user.value.formattedPhoneNo,
                          style: const TextStyle(fontSize: 16),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                      width: 8.0), // Add space between phone number and image
                  Image.asset(
                    TImages.duitnow, // Path to your DuitNow logo image
                    width: 40, // Adjust width as needed
                    height: 40, // Adjust height as needed
                  ),
                ],
              ),
              const SizedBox(height: 30), // Adjust spacing as needed

              // Bank Accounts Section
              Text(
                'Your Bank Accounts',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Obx(
                () => FutureBuilder(
                  key: Key(bankController.refreshData.value.toString()),
                  future: bankController.getAllUserBankAccount(),
                  builder: (context, snapshot) {
                    final response =
                        TCloudHelperFunctions.checkMultiRecordState(
                      snapshot: snapshot,
                    );
                    if (response != null) return response;
                    final banks = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: banks.length,
                      itemBuilder: (_, index) => TSelectedBank(
                        bank: banks[index],
                        onTap: () => bankController.selectBank(banks[index]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddNewBankAccountScreen());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
