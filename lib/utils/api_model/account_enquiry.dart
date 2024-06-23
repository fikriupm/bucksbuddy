import 'dart:convert';
import 'dart:ui';

import 'package:bucks_buddy/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AccountEnquiry {
  String bankAccount;
  String bankAccountNumber;
  AccountEnquiry({
    required this.bankAccount,
    required this.bankAccountNumber,
  });

  static const String host =
      'https://certification.api.development.developer.inet.paynet.my/v1/picasso-guard'; //  actual host
  static const String finalUrl =
      'https://certification.api.developer.inet.paynet.my/v1/picasso-guard/banks/duitnow-payment/v2/initiate';
  var createdDateTime =
      DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(DateTime.now());

  //get dynamic business message id
  Future<String> getBusinessMessageId() async {
    var url = Uri.parse(
        '$host/test/helper/business-message-id?transactionCode=CREDIT_TRANSFER');
    var response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(
          'Failed to get businessMessageId: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

// get dynamic authentication
  Future<String> getJwsToken(String businessMessageId) async {
    final url =
        '$host/test/helper/jws-token?businessMessageId=$businessMessageId';
    final headers = {'Content-Type': 'application/json'};

    try {
      Map<String, dynamic> body = {
        "data": {
          "businessMessageId": businessMessageId,
          "createdDateTime": createdDateTime,
          "interbankSettlementAmount": 1.0,
          "debtor": {'name': "john", "id": '123456789'},
          "debtorAccount": {
            "id": '0123456789',
            "type": "SVGS",
            "residentStatus": "1",
            "productType": "I",
            "shariaCompliant": "Y",
            "details": "1"
          },
          "creditorAgent": {"id": "PICAMYK1"},
          "creditorAccount": {"id": '123456789', "type": "SVGS"},
          "creditor": {"name": 'john', "id": '0123456789', "idType": "01"},
          "recipientReference": "Payment Reference",
          "paymentDescription": "Payment Description",
          "secondaryValidationIndicator": "Y"
        }
      };
      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception(
            'Failed to get JWS Token: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Exception: $e');
    }
  }

  Future<void> sendPostRequest() async {
    try {
      // Get businessMessageId
      var businessMessageId = await getBusinessMessageId();

      // Get jwsToken
      var jwsToken = await getJwsToken(businessMessageId);

      // Prepare headers
      Map<String, String> headers = {
        'Authorization': jwsToken, // Ensure this is a valid token
        'X-Business-Message-Id': businessMessageId,
        'X-Client-Id': 'abdf0b6d49d84045959caf7cb5cb9fb3',
        'X-Gps-Coordinates': '40.689263,74.044505',
        'X-Ip-Address': '192.168.100.8',
        'Content-Type': 'application/json'
      };

      // Define the request body
      Map<String, dynamic> body = {
        "data": {
          "businessMessageId": businessMessageId,
          "createdDateTime": createdDateTime,
          "interbankSettlementAmount": 1.0,
          "debtor": {'name': "john", "id": '123456789'},
          "debtorAccount": {
            "id": '0123456789',
            "type": "SVGS",
            "residentStatus": "1",
            "productType": "I",
            "shariaCompliant": "Y",
            "details": "1"
          },
          "creditorAgent": {"id": "PICAMYK1"},
          "creditorAccount": {"id": '123456789', "type": "SVGS"},
          "creditor": {"name": 'john', "id": '0123456789', "idType": "01"},
          "recipientReference": "Payment Reference",
          "paymentDescription": "Payment Description",
          "secondaryValidationIndicator": "Y"
        }
      };

      // Convert the body to a JSON string
      String jsonBody = json.encode(body);

      // Send the POST request
      var response = await http.post(Uri.parse(finalUrl),
          headers: headers, body: jsonBody);

      // Check the response status code
      if (response.statusCode == 200) {
        print('Success: ${response.body}');

        Get.snackbar(
          'Account Inqury Successful',
          'Bank Account $bankAccount ($bankAccountNumber) is exists',
          //nnti tukar gambar yg sesuai
          icon: const Padding(
            padding: EdgeInsets.only(top: 15.0, left: 8.0),
            child: Image(
              image: AssetImage(TImages.duitnow),
            ),
          ),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.grey.withOpacity(0.7),
          borderRadius: 20,
          margin: const EdgeInsets.all(15),
          colorText: Colors.black,
          duration: const Duration(seconds: 2),
          isDismissible: true,
          forwardAnimationCurve: Curves.easeOutBack,
        );
      } else {
        print('Failed: ${response.statusCode} ${response.reasonPhrase}');
        print('Response Body: ${response.body}');
        Get.snackbar(
          'Account Inqury UnSuccessful',
          'Bank Account $bankAccount ($bankAccountNumber) is not Exists',
          //nnti tukar gambar yg sesuai
          icon: const Image(
            image: AssetImage(TImages.duitnow),
          ),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.5),
          borderRadius: 20,
          margin: const EdgeInsets.all(15),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          isDismissible: true,
          forwardAnimationCurve: Curves.easeOutBack,
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
