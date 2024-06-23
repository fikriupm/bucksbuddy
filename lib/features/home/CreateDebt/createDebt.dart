import 'package:bucks_buddy/features/home/CreateDebt/controller/debt_ticket_controller.dart';
import 'package:bucks_buddy/features/home/CreateDebt/model/debt_ticket_model.dart';
import 'package:bucks_buddy/features/home/CreateDebt/displayForm.dart';
import 'package:bucks_buddy/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateDebtPage extends StatefulWidget {
  const CreateDebtPage({Key? key}) : super(key: key);

  @override
  State<CreateDebtPage> createState() => _CreateDebtPageState();
}

class _CreateDebtPageState extends State<CreateDebtPage> {
  final _formKey = GlobalKey<FormState>();
  final DebtTicketController debtTicketController =
      Get.put(DebtTicketController());

  // Form field controllers
  final TextEditingController _creditorController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _bankAccountNoController =
      TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _creditorIDController = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();

  String? selectedDebtor;

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data when the widget initializes
    _fetchFriends(); // Fetch friends list when the widget initializes
  }

  // Method to fetch user data and auto-fill form fields
  void _fetchUserData() async {
    try {
      final data = await debtTicketController.fetchUserData();

      setState(() {
        _creditorController.text = '${data['username']} / ${data['fullName']}';
        _bankAccountController.text = data['bankName'];
        _bankAccountNoController.text = data['accountNumber'];
        _creditorIDController.text = data['userId'];
        _phoneNumController.text = data['phoneNumber'];
      });
    } catch (e) {
      // Handle error
      print('Error fetching user data: $e');
    }
  }

  // Method to fetch friends list
  void _fetchFriends() async {
    try {
      await debtTicketController.fetchAllFriends();
    } catch (e) {
      // Handle error
      print('Error fetching friends: $e');
    }
  }

  @override
  void dispose() {
    // Dispose all text editing controllers
    _creditorController.dispose();
    _amountController.dispose();
    _bankAccountController.dispose();
    _bankAccountNoController.dispose();
    _referenceController.dispose();
    _phoneNumController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final debtorExists =
          await debtTicketController.doesDebtorExist(selectedDebtor!);

      if (!debtorExists) {
        _showErrorDialog('The debtor does not exist.');
        return;
      }

      final ticketData = DebtTicket(
        creditor: _creditorController.text,
        debtor: selectedDebtor!,
        amount: _amountController.text,
        bankAccount: _bankAccountController.text,
        bankAccountNumber: _bankAccountNoController.text,
        reference: _referenceController.text,
        phoneNumber: _phoneNumController.text,
        dateTime: DateTime.now().toString(),
        status: 'not_paid',
        debtTicketId: debtTicketController.generateTicketId(),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayForm(
            ticketData: ticketData.toJson(),
            id: _creditorIDController.text,
          ),
        ),
      );
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLabeledTextField(String label, TextEditingController controller,
      {String hintText = '',
      String suffixText = '',
      TextInputType keyboardType = TextInputType.text,
      bool isReadOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          readOnly: isReadOnly,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.withOpacity(0.5),
            hintText: hintText,
            suffixIcon: suffixText.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(suffixText,
                        style: const TextStyle(color: Colors.grey)),
                  )
                : null,
            hintStyle:
                const TextStyle(color: Colors.grey), // Light grey font for hint
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0), // Rounded corners
            ),
          ),
          keyboardType: keyboardType,
          validator: (value) {
            if (!isReadOnly && (value == null || value.isEmpty)) {
              return 'Please enter $label';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLabeledDropdownField(String label, String? value,
      {required List<String> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedDebtor = newValue;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select $label';
            }
            return null;
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Image.asset(
                    TImages.logoMain,
                    height: 100,
                  ),
                ),
                const SizedBox(height: 10),
                _buildLabeledTextField(
                  'Creditor',
                  _creditorController,
                  isReadOnly: true,
                ),
                const SizedBox(height: 10),
                Obx(() {
                  var friendNames = debtTicketController.friendNames;
                  if (friendNames.isEmpty) {
                    return Text('No Friend');
                  }
                  return _buildLabeledDropdownField(
                    'Debtor',
                    selectedDebtor,
                    items: friendNames, // Use friendNames directly
                  );
                }),
                const SizedBox(height: 10),
                _buildLabeledTextField(
                  'Amount',
                  _amountController,
                  hintText: '0.00',
                  suffixText: 'MYR',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                _buildLabeledTextField(
                  'Bank Account Name',
                  _bankAccountController,
                  isReadOnly: true,
                ),
                const SizedBox(height: 10),
                _buildLabeledTextField(
                  'Bank Account Number',
                  _bankAccountNoController,
                  isReadOnly: true,
                ),
                const SizedBox(height: 10),
                _buildLabeledTextField(
                  'Reference',
                  _referenceController,
                  hintText: '',
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFF0CA00).withOpacity(0.82),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 20.0)),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
