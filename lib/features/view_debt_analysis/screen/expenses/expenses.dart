import 'package:bucks_buddy/common/styles/spacing_styles.dart';
import 'package:bucks_buddy/features/view_debt_analysis/controller/expenses_controller.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Expenses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ExpensesController expensesController = Get.put(ExpensesController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.keyboard_backspace_rounded),
        ),
      ),
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
                            "You Owe",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: TSizes.sm,
                          ),
                          Obx(() {
                            try {
                              var youOwnDebt =
                                  expensesController.totalAmountYouOwn.value;
                              return Text(
                                'RM $youOwnDebt',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Roboto'),
                              );
                            } catch (e) {
                              print('error you owe: ${e.toString()}');
                              return const CircularProgressIndicator.adaptive();
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
                            "Owe You",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: TSizes.sm,
                          ),
                          Obx(() {
                            try {
                              var ownYouDebt =
                                  expensesController.totalAmountOwnYou.value;
                              return Text(
                                'RM $ownYouDebt',
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
                              spacing: 10,
                              children: [
                                Row(
                                  children: [
                                    Radio(
                                      value: 'You Owe',
                                      groupValue: expensesController
                                          .radioSelectedValue.value,
                                      onChanged: (value) {
                                        expensesController
                                            .radioSelected(value!);
                                      },
                                    ),
                                    const Text('You Owe'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio(
                                      value: 'Owe You',
                                      groupValue: expensesController
                                          .radioSelectedValue.value,
                                      onChanged: (value) {
                                        expensesController
                                            .radioSelected(value!);
                                      },
                                    ),
                                    const Text('Owe You'),
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
                      PieChart(
                        PieChartData(
                          startDegreeOffset: 0,
                          sectionsSpace: 0,
                          centerSpaceRadius: 100,
                          sections: [
                            PieChartSectionData(
                              value: expensesController.highestPercent.value,
                              color: Colors.amberAccent,
                              radius: 45,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              value:
                                  expensesController.secondHighestPercent.value,
                              color: const Color.fromRGBO(68, 119, 249, 1),
                              radius: 25,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              value: expensesController.lastPercent.value,
                              color: const Color.fromARGB(255, 242, 24, 42),
                              radius: 20,
                              showTitle: false,
                            ),
                          ],
                        ),
                      ),
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
                        return Center(
                          child: Text(
                            expensesController.highestPercent.value.toString(),
                            style: const TextStyle(fontSize: TSizes.fontSizeLg),
                          ),
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
                            width: TSizes.spaceBtwItems,
                          ),
                          const Text(
                            'Food',
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                              '${expensesController.totalAmountOwnYouFood.value}')
                        ],
                      )
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
                            width: TSizes.spaceBtwItems,
                          ),
                          const Text(
                            'Personal',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                      const Row(
                        children: [Text("RM13,020")],
                      )
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
                          const Text(
                            'Other',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Obx(() {
                            return Text(
                                '${expensesController.totalAmountOwnYouOther.value}');
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
      // bottomNavigationBar: NavigationMenu(),
    );
  }
}
