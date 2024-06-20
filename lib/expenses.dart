// lib/pages/expenses_page.dart
import 'package:bucks_buddy/common/styles/spacing_styles.dart';
import 'package:bucks_buddy/data/repositories/user/user_repository.dart';
import 'package:bucks_buddy/expenses_controller.dart';
import 'package:bucks_buddy/utils/constants/sizes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Expenses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ExpensesController expensesController = Get.put(ExpensesController());
    //final PaymentController paymentController = Get.put(PaymentController());

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 97,
                    width: 167,
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
                            "You Own",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: TSizes.sm,
                          ),
                          Obx(() {
                            // nnti buat method untuk check amount
                            var expenseAmount = expensesController.expenses;
                            var user = UserRepository.instance.fetchCurrentUserFriends(FirebaseAuth.instance.currentUser?.uid ?? '');
                            if (expenseAmount.isNotEmpty) {
                              var expenseAmount =
                                  expensesController.expenses.first;
                              print('${expenseAmount.amount}');
                              return Text(
                                '${expenseAmount.amount}',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Roboto'),
                              );
                            } else {
                              print('error');
                            }
                            return const CircularProgressIndicator();
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
                    width: 167,
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
                            "Own You",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: TSizes.sm,
                          ),
                          Obx(() {
                            // nnti buat method untuk check amount
                            var expenseAmount = expensesController.expenses;
                             var user = UserRepository.instance.fetchCurrentUserFriends(FirebaseAuth.instance.currentUser?.uid ?? '');
                            if (expenseAmount.isNotEmpty) {
                              var expenseAmount =
                                  expensesController.expenses.first;
                              print('${expenseAmount.amount}');
                              return Text(
                                '${expenseAmount.amount}',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Roboto'),
                              );
                            } else {
                              print('error');
                            }
                            return const CircularProgressIndicator();
                          })
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              const SizedBox(
                height: TSizes.spaceBtwInputFields,
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                      shape: BoxShape.rectangle,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () {
                            //buat method to trace all analysis
                          },
                          child: const Text('You Own'),
                        ),
                        TextButton(
                          onPressed: () {
                            //buat method to trace all analysis
                          },
                          child: const Text('Own You'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 110,
                  ),
                  Expanded(
                    child: Obx(() {
                      return Container(
                        height: 40,
                        width: 150,
                        padding: const EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: const Color.fromARGB(255, 226, 222, 222)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: expensesController.selectedValue.value,
                            items: const [
                              DropdownMenuItem<String>(
                                value: 'Month',
                                child: Text("Monthly"),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Year',
                                child: Text("Yearly"),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Day',
                                child: Text("Daily"),
                              ),
                            ],
                            onChanged: (String? newValue) {
                              expensesController.selectedValue.value =
                                  newValue!;
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Center(
                child: Container(
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
                              value: 45,
                              color: Colors.amberAccent,
                              radius: 45,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              value: 35,
                              color: const Color.fromRGBO(68, 119, 249, 1),
                              radius: 25,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              value: 20,
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
                      const Center(child: Text("65%")),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
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
                      const Row(
                        children: [Text('RM15,000')],
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
                      const Row(
                        children: [Text('RM2,590')],
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(),
    );
  }
}
