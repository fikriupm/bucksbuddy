import 'package:bucks_buddy/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:bucks_buddy/features/personalization/controllers/bank_account_controller.dart';
import 'package:bucks_buddy/features/personalization/models/bank_account_model.dart';
import 'package:bucks_buddy/utils/constants/colors.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:bucks_buddy/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TSelectedBank extends StatelessWidget {
  const TSelectedBank({
    super.key,
    required this.bank,
    required this.onTap,
  });

  final BankAccountModel bank;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final controller = BankAccountController.instance;
    final dark = THelperFunctions.isDarkMode(context);
    return Obx(() {
      final selectedBankId = controller.selectedBank.value.id;
      final selectedBank = selectedBankId == bank.id;
      return InkWell(
        onTap: onTap,
        child: TRoundedContainer(  
          showBorder: true,
          padding: const EdgeInsets.all(TSizes.md),
          width: double.infinity,
          backgroundColor: selectedBank
              ? TColors.primary.withOpacity(0.5)
              : Colors.transparent,
          borderColor: selectedBank
              ? Colors.transparent
              : dark
                  ? TColors.darkerGrey
                  : TColors.grey,
          margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
          child: Stack(
            children: [
              Positioned(
                right: 5,
                top: 0,
                child: Icon(
                  selectedBank ? Iconsax.tick_circle5 : null,
                  color: selectedBank
                      ? dark
                          ? TColors.light
                          : TColors.dark
                      : null,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bank.bankName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: TSizes.sm / 2),
                  Text(
                    bank.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
