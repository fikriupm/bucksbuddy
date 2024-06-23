import 'package:bucks_buddy/common/styles/spacing_styles.dart';
import 'package:bucks_buddy/features/view_debt_analysis/controller/expenses_controller.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Expenses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ExpensesController expensesController = Get.find();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text(
                    "Analytics",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: TSizes.xl,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 97,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(32),
                      color: const Color(0xFFF0CA00).withOpacity(0.82),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Amount Receive",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: TSizes.sm,
                          ),
                          Obx(() {
                            try {
                              var youOwnDebt = expensesController
                                  .totalAmountYouReceive.value;
                              return Text(
                                'RM ${youOwnDebt.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',
                                ),
                              );
                            } catch (e) {
                              print('Error fetching data: ${e.toString()}');
                              return Text(
                                'Error: ${e.toString()}',
                                style: const TextStyle(color: Colors.red),
                              );
                            }
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: TSizes.spaceBtwItems,
                  ),
                  Container(
                    height: 97,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(32),
                      color: const Color(0xFFF0CA00).withOpacity(0.82),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Amount Paid",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: TSizes.sm,
                          ),
                          Obx(() {
                            try {
                              var ownYouDebt =
                                  expensesController.totalAmountYouPaid.value;
                              return Text(
                                'RM ${ownYouDebt.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Roboto'),
                              );
                            } catch (e) {
                              print('error you own: ${e.toString()}');
                              return const CircularProgressIndicator.adaptive();
                            }
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: TSizes.spaceBtwInputFields,
              ),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        shape: BoxShape.rectangle,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Obx(() {
                            return Wrap(
                              spacing: 2,
                              children: [
                                Row(
                                  children: [
                                    Radio(
                                      value: 'Amount Receive',
                                      groupValue: expensesController
                                          .radioSelectedValue.value,
                                      onChanged: (value) {
                                        expensesController
                                            .radioSelected(value!);
                                      },
                                    ),
                                    const Text('Amount Receive'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio(
                                      value: 'Amount Paid',
                                      groupValue: expensesController
                                          .radioSelectedValue.value,
                                      onChanged: (value) {
                                        expensesController
                                            .radioSelected(value!);
                                      },
                                    ),
                                    const Text('Amount Paid'),
                                  ],
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 35),
                ],
              ),
              const SizedBox(height: 70),
              Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    children: [
                      paiChart(expensesController),
                      Positioned.fill(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 160,
                              width: 160,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 213, 210, 210),
                                    blurRadius: 10,
                                    spreadRadius: 10,
                                    offset: Offset(3.0, 3.0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(() {
                        bool amountPaid = expensesController.amountPaid
                            .value; // Replace with your actual condition
                        return Center(
                            child: amountPaid
                                ? Text(
                                    '${expensesController.highestPercentYouPaid.toStringAsFixed(2)}%', //highest percentage
                                    style: const TextStyle(
                                        fontSize: TSizes.fontSizeLg),
                                  )
                                : Text(
                                    '${expensesController.highestPercentYouReceive.toStringAsFixed(2)}%',
                                    style: const TextStyle(
                                        fontSize: TSizes.fontSizeLg),
                                  ) // Show CircularProgressIndicator when condition is false
                            );
                      })
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 10,
                            width: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(30),
                                color: const Color.fromARGB(255, 242, 24, 42)),
                          ),
                          const SizedBox(
                            width: TSizes.spaceBtwInputFields,
                          ),
                          Obx(() {
                            bool amountPaid = expensesController.amountPaid
                                .value; // Replace with your actual condition
                            return Center(
                                child: amountPaid
                                    ? Text(
                                        '${expensesController.lastCategoryYouPaid.value}',
                                        style: const TextStyle(
                                            fontSize: TSizes.fontSizeSm),
                                      )
                                    : Text(
                                        '${expensesController.lastCategoryYouReceive.value}',
                                        style: const TextStyle(
                                            fontSize: TSizes.fontSizeSm),
                                      ) // Show CircularProgressIndicator when condition is false
                                );
                          })
                        ],
                      ),
                      Obx(() {
                        bool amountPaid = expensesController.amountPaid
                            .value; // Replace with your actual condition
                        return Center(
                            child: amountPaid
                                ? Text(
                                    'RM ${expensesController.lastRmYouPaid.value.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontSize: TSizes.fontSizeMd),
                                  )
                                : Text(
                                    'RM ${expensesController.lastRmYouReceive.value.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontSize: TSizes.fontSizeMd),
                                  ) // Show CircularProgressIndicator when condition is false
                            );
                      })
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 10,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(30),
                              color: const Color.fromRGBO(68, 119, 249, 1),
                            ),
                          ),
                          const SizedBox(
                            width: TSizes.spaceBtwInputFields,
                          ),
                          Obx(() {
                            bool amountPaid = expensesController.amountPaid
                                .value; // Replace with your actual condition
                            return Center(
                                child: amountPaid
                                    ? Text(
                                        '${expensesController.secondCategoryYouPaid.value}',
                                        style: const TextStyle(
                                            fontSize: TSizes.fontSizeSm),
                                      )
                                    : Text(
                                        '${expensesController.secondCategoryYouReceive.value}',
                                        style: const TextStyle(
                                            fontSize: TSizes.fontSizeSm),
                                      ) // Show CircularProgressIndicator when condition is false
                                );
                          })
                        ],
                      ),
                      Obx(() {
                        bool amountPaid = expensesController.amountPaid.value;
                        ; // Replace with your actual condition
                        return Center(
                            child: amountPaid
                                ? Text(
                                    'RM ${expensesController.secondHighestRmYouPaid.value.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontSize: TSizes.fontSizeMd),
                                  )
                                : Text(
                                    'RM ${expensesController.secondHighestRmYouReceive.value.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontSize: TSizes.fontSizeMd),
                                  ) // Show CircularProgressIndicator when condition is false
                            );
                      })
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 10,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.amberAccent,
                            ),
                          ),
                          const SizedBox(
                            width: TSizes.spaceBtwItems,
                          ),
                          Obx(() {
                            bool amountPaid =
                                expensesController.amountPaid.value;
                            return Center(
                                child: amountPaid
                                    ? Text(
                                        '${expensesController.highestCategoryYouPaid.value}',
                                        style: const TextStyle(
                                            fontSize: TSizes.fontSizeSm),
                                      )
                                    : Text(
                                        '${expensesController.highestCategoryYouReceive.value}',
                                        style: const TextStyle(
                                            fontSize: TSizes.fontSizeSm),
                                      ) // Show CircularProgressIndicator when condition is false
                                );
                          })
                        ],
                      ),
                      Row(
                        children: [
                          Obx(() {
                            bool amountPaid = expensesController.amountPaid
                                .value; // Replace with your actual condition
                            return Center(
                                child: amountPaid
                                    ? Text(
                                        'RM ${expensesController.highestRmYouPaid.value.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontSize: TSizes.fontSizeMd),
                                      )
                                    : Text(
                                        'RM ${expensesController.highestRmYouReceive.value.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontSize: TSizes.fontSizeMd),
                                      ) // Show CircularProgressIndicator when condition is false
                                );
                          })
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget paiChart(ExpensesController expensesController) {
    try {
      var errorNoAmountPaid = expensesController.errorNoAmountPaid.value;
      var errorNoAmountReceive = expensesController.errorNoAmountReceive.value;

      if (errorNoAmountPaid == '' && errorNoAmountReceive == '') {
        return Obx(() {
          bool amountPaid = expensesController.amountPaid.value;

          return PieChart(
            PieChartData(
              startDegreeOffset: 0,
              sectionsSpace: 0,
              centerSpaceRadius: 100,
              sections: [
                PieChartSectionData(
                  value: amountPaid
                      ? expensesController.highestPercentYouPaid.value
                      : expensesController.highestPercentYouReceive.value,
                  color: Colors.amberAccent,
                  radius: 45,
                  showTitle: false,
                ),
                PieChartSectionData(
                  value: amountPaid
                      ? expensesController.secondHighestPercentYouPaid.value
                      : expensesController.secondHighestPercentYouReceive.value,
                  color: const Color.fromRGBO(68, 119, 249, 1),
                  radius: 25,
                  showTitle: false,
                ),
                PieChartSectionData(
                  value: amountPaid
                      ? expensesController.lastPercentYouPaid.value
                      : expensesController.lastPercentYouReceive.value,
                  color: const Color.fromARGB(255, 242, 24, 42),
                  radius: 20,
                  showTitle: false,
                ),
              ],
            ),
          );
        });
      } else {
        return Obx(() {
          bool amountPaid = expensesController.amountPaid.value;
          return Center(
            child: Text(
              amountPaid
                  ? expensesController.errorNoAmountPaid.value
                  : expensesController.errorNoAmountReceive.value,
              style: const TextStyle(
                  fontSize:
                      14), // Replace TSizes.fontSizeSm with an actual value
            ),
          );
        });
      }
    } catch (e) {
      Obx(() {
        return Text('Error');
      });
    }

    return Text('Error');
  }
}
