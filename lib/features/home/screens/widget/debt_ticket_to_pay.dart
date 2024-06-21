// import 'package:bucks_buddy/features/home/CreateDebt/model/debt_ticket_model.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // For formatting date and time

// class DisplayForm extends StatelessWidget {
//   final DebtTicket debtTicket;

//   DisplayForm({required this.debtTicket});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Ticket for You Details'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container,
//               padding: EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'TICKET ID: ${debtTicket.debtTicketId}',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'From',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         debtTicket.status == 'not_paid' ? 'Not Pay' : 'Paid',
//                         style: TextStyle(
//                           color: debtTicket.status == 'not_paid'
//                               ? Colors.red
//                               : Colors.green,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Text(debtTicket.creditor),
//                   SizedBox(height: 10),
//                   Text(
//                     'To',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text(debtTicket.debtor),
//                   SizedBox(height: 10),
//                   Text(
//                     'Phone Number / Email',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text(debtTicket.phoneNumber),
//                   SizedBox(height: 10),
//                   Text(
//                     'Amount',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text('RM ${debtTicket.amount}'),
//                   SizedBox(height: 10),
//                   Text(
//                     'Bank',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text(debtTicket.bankAccount),
//                   SizedBox(height: 10),
//                   Text(
//                     'Account Number',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text(debtTicket.bankAccountNumber),
//                   SizedBox(height: 10),
//                   Text(
//                     'Descriptions',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text(debtTicket.reference),
//                   SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Icon(Icons.calendar_today, size: 20),
//                       SizedBox(width: 5),
//                       Text(
//                         DateFormat.yMMMMd().format(DateTime.parse(debtTicket.dateTime)),
//                       ),
//                       SizedBox(width: 20),
//                       Icon(Icons.access_time, size: 20),
//                       SizedBox(width: 5),
//                       Text(
//                         DateFormat.jm().format(DateTime.parse(debtTicket.dateTime)),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Spacer(),
//             ElevatedButton(
//               onPressed: () {
//                 // Handle payment process here
//               },
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.black, backgroundColor: Colors.yellow,
//                 minimumSize: Size(double.infinity, 50),
//               ),
//               child: Text('Proceed to Pay'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
