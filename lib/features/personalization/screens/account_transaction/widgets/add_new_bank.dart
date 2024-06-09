import 'package:bucks_buddy/common/widgets/appbar/appbar.dart';
import 'package:bucks_buddy/features/personalization/controllers/bank_account_controller.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:bucks_buddy/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AddNewBankAccountScreen extends StatelessWidget {
  const AddNewBankAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = BankAccountController.instance;
    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text('Add new Bank Account'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            key: controller.bankFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: controller.bankName.text.isNotEmpty
                      ? controller.bankName.text
                      : null, // initial value
                  onChanged: (String? newValue) {
                    // Update the selected bank name when an option is chosen
                    if (newValue != null) {
                      controller.bankName.text = newValue;
                    }
                  },
                  validator: (value) =>
                      TValidator.validateEmptyText('Bank', value),
                  items: <String>['', 'Paynet', 'Maybank', 'CIMB', 'Bank Islam', 'RHB', 'Bank Rakyat']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.isNotEmpty ? value : 'Select a bank'),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.bank),
                    labelText: 'Bank',
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                  controller: controller.accountNumber,
                  validator: (value) =>
                      TValidator.validateEmptyText('Account Number', value),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.mobile),
                    labelText: 'Account Number',
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                ElevatedButton(
                  onPressed: controller.addNewBank,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
