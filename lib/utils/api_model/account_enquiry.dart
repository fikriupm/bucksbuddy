import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AccountEnquiry {
  var businessMessageId = '';
  var createdDateTime =
      DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(DateTime.now());
  // picassoGuardURL
  static String host =
      'https://certification.api.development.developer.inet.paynet.my/v1/picasso-guard';

  //endpoint url for account Inquiry
  static String finalUrl =
      'https://certification.api.development.developer.inet.paynet.my/v1/picasso-guard/banks/duitnow-payment/v2/account-lookup';

  Future<String> sendGetRequest() async {
    var url = Uri.parse(
        '$host/test/helper/business-message-id?transactionCode=ACCOUNT_RESOLUTION_ENQUIRY');
    var response =
        await http.get(url, headers: {'content-type': 'application/json'});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(
          'Failed to fullfill the request ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  Future<String> sentPostRequest(businessMessageId) async {
    var url = Uri.parse(
        '$host/test/helper/jws-token?businessMessageId=$businessMessageId');
    try {
      Map<String, dynamic> body = {
        "data": {
          "businessMessageId": businessMessageId,
          "createdDateTime": createdDateTime,
          "interbankSettlementAmount": 1.00,
          "debtor": {"name": "Debtor Name", "id": "0123456789"},
          "debtorAccount": {
            "id": "0123456789",
            "type": "SVGS",
            "residentStatus": "1",
            "productType": "I",
            "shariaCompliant": "Y",
            "details": "1"
          },
          "creditorAgent": {"id": "PICAMYK1"},
          "creditorAccount": {"id": "110067101088", "type": "SVGS"},
          "creditor": {
            "name": "Creditor Name",
            "id": "0123456789",
            "idType": "01"
          },
          "recipientReference": "Payment Reference",
          "paymentDescription": "Payment Description",
          "secondaryValidationIndicator": "Y"
        }
      };
      var response = await http.post(url,
          headers: {'content-type': 'application/json'},
          body: jsonEncode(body));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw (Exception(
            'Failed to fullfill the request ${response.statusCode} :${response.reasonPhrase}'));
      }
    } catch (e) {
      throw Exception('Exception: $e');
    }
  }

  Future<void> finalPostRequest() async {
    try {
      var businessMessageId = await sendGetRequest();
      var jwsToken = await sentPostRequest(businessMessageId);

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
          "interbankSettlementAmount": 1.00,
          "debtor": {"name": "Debtor Name", "id": "0123456789"},
          "debtorAccount": {
            "id": "0123456789",
            "type": "SVGS",
            "residentStatus": "1",
            "productType": "I",
            "shariaCompliant": "Y",
            "details": "1"
          },
          "creditorAgent": {"id": "PICAMYK1"},
          "creditorAccount": {"id": "110067101088", "type": "SVGS"},
          "creditor": {
            "name": "Creditor Name",
            "id": "0123456789",
            "idType": "01"
          },
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
      } else {
        print('Failed: ${response.statusCode} ${response.reasonPhrase}');
        print('Response Body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
