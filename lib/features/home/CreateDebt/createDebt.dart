// create_debt_page.dart
import 'package:bucks_buddy/features/home/CreateDebt/controller/debt_ticket_controller.dart';
import 'package:bucks_buddy/features/home/CreateDebt/model/debt_ticket_model.dart';
import 'package:bucks_buddy/features/home/CreateDebt/displayForm.dart';
import 'package:bucks_buddy/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateDebtPage extends StatefulWidget {
  const CreateDebtPage({super.key});

  @override
  State<CreateDebtPage> createState() => _CreateDebtPageState();
}

class _CreateDebtPageState extends State<CreateDebtPage> {
  final _formKey = GlobalKey<FormState>();
  final DebtTicketController debtTicketController =
      Get.put(DebtTicketController());
  // Form field controllers
  final TextEditingController _creditorController = TextEditingController();
  final TextEditingController _debtorController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _bankAccountNoController =
      TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _creditorIDController = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();

  //

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data when the widget initializes
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
    }
  }

  @override
  void dispose() {
    _creditorController.dispose();
    _debtorController.dispose();
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
          await debtTicketController.doesDebtorExist(_debtorController.text);

      if (!debtorExists) {
        _showErrorDialog('The debtor does not exist.');
        return;
      }

      final ticketData = DebtTicket(
        creditor: _creditorController.text,
        debtor: _debtorController.text,
        amount: _amountController.text,
        bankAccount: _bankAccountController.text,
        bankAccountNumber: _bankAccountNoController.text,
        reference: _referenceController.text,
        phoneNumber: _phoneNumController.text,
        dateTime: DateTime.now().toString(),
        status: 'not_paid',
        //debtTicketId: debtTicketController.generatedTicketId()
      );

      await debtTicketController.saveDebtTicket(
          ticketData, _creditorIDController.text);

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

  void _showOverlay(BuildContext context, String message, GlobalKey key) {
    final overlay = Overlay.of(context);
    final renderBox = key.currentContext!.findRenderObject() as RenderBox;
    final overlayRenderBox = overlay.context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(
      Offset(renderBox.size.width, 0.0),
      ancestor: overlayRenderBox,
    );

    final entry = OverlayEntry(
      builder: (context) => Positioned(
        top: position.dy,
        left: position.dx,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 2), () => entry.remove());
  }

  Widget _buildLabeledTextField(String label, TextEditingController controller,
      {String hintText = '',
      String suffixText = '',
      TextInputType keyboardType = TextInputType.text,
      bool isReadOnly = false,
      Widget? suffixIcon,
      GlobalKey? iconKey}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 5),
            if (suffixIcon != null)
              GestureDetector(
                key: iconKey,
                onTap: () => _showOverlay(
                  context,
                  label == 'Creditor'
                      ? "Debt Receiver's username"
                      : "Debt Payer/Issuer's username",
                  iconKey!,
                ),
                child: suffixIcon,
              ),
          ],
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

  @override
  Widget build(BuildContext context) {
    final creditorIconKey = GlobalKey();
    final debtorIconKey = GlobalKey();

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
                    TImages
                        .logoMain, // Ensure this path matches your asset structure
                    height: 100,
                  ),
                ),
                const SizedBox(height: 10), // Reduced space
                _buildLabeledTextField(
                  'Creditor',
                  _creditorController,
                  isReadOnly: true,
                  suffixIcon: Icon(
                    Icons.info,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                  iconKey: creditorIconKey,
                ),
                const SizedBox(height: 10),
                _buildLabeledTextField(
                  'Debtor',
                  _debtorController,
                  hintText: 'Name',
                  suffixIcon: Icon(
                    Icons.info,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                  iconKey: debtorIconKey,
                ),
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
                          vertical: 16.0,
                          horizontal: 20.0) // Adjust padding as needed
                      ),
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
