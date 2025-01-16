import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/payment/card_input_formatters.dart';
import '../utils/api_helper.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> shipData;
  final String shipName;
  final Map<String, dynamic> customerDetails;

  const PaymentScreen({
    Key? key,
    required this.shipData,
    required this.shipName,
    required this.customerDetails,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  Future<void> _testConnection() async {
    final isConnected = await ApiHelper.testConnection();
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isConnected ? 'Connection successful' : 'Connection failed'),
        backgroundColor: isConnected ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> _processPayment() async {
  if (_formKey.currentState!.validate()) {
    try {
      final isForSale = widget.shipData.containsKey('selling_price');
      final table = isForSale ? 'buying_log' : 'renting_log';
      final amount = isForSale 
          ? widget.shipData['selling_price'] 
          : widget.shipData['rental_price_per_day'];

      // Parse dates and calculate total amount for rentals
      final totalAmount = isForSale 
          ? amount 
          : amount * (DateTime.parse(widget.customerDetails['rental_end'])
              .difference(DateTime.parse(widget.customerDetails['rental_start']))
              .inDays + 1);

      final payload = {
  'table': table,
  'full_name': widget.customerDetails['fullName'],
  'email': widget.customerDetails['email'],
  'phone_number': widget.customerDetails['phoneNumber'],
  'address': widget.customerDetails['address'],
  'ship_name': widget.shipName,
  'total_amount': totalAmount,
  'purchase_date': DateTime.now().toIso8601String(), 
};

if (!isForSale) {
  payload['rental_start_date'] = widget.customerDetails['rental_start'];
  payload['rental_end_date'] = widget.customerDetails['rental_end'];
}


      final response = await http.post(
        Uri.parse('http://localhost/log_transaction.php'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(payload),
      );


        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          if (!mounted) return;
          
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Payment Successful'),
              content: Text(
                isForSale
                    ? 'Congratulations! You have successfully purchased ${widget.shipName}.'
                    : 'Your rental of ${widget.shipName} has been confirmed.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          final errorData = json.decode(response.body);
          throw Exception(errorData['error'] ?? 'Failed to process payment');
        }
      } catch (e) {
        print('Error processing payment: $e');
        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isForSale = widget.shipData.containsKey('selling_price');
    final price = isForSale
        ? widget.shipData['selling_price']
        : widget.shipData['rental_price_per_day'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPaymentSummary(isForSale, price),
              const SizedBox(height: 24),
              _buildCardDetailsSection(),
              const SizedBox(height: 24),
              _buildPaymentButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentSummary(bool isForSale, dynamic price) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text('Ship: ${widget.shipName}'),
            if (!isForSale && widget.customerDetails['rental_start'] != null) ...[
              Text('Rental Start: ${widget.customerDetails['rental_start']}'),
              Text('Rental End: ${widget.customerDetails['rental_end']}'),
            ],
            Text(
              isForSale
                  ? 'Total Amount: \$$price'
                  : 'Daily Rate: \$$price',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Card Details',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _cardHolderController,
          decoration: const InputDecoration(
            labelText: 'Card Holder Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter card holder name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _cardNumberController,
          decoration: const InputDecoration(
            labelText: 'Card Number',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [CardNumberInputFormatter()],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter card number';
            }
            if (value.replaceAll(' ', '').length != 16) {
              return 'Card number must be 16 digits';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _expiryController,
                decoration: const InputDecoration(
                  labelText: 'MM/YY',
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [ExpiryDateFormatter()],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                    return 'Invalid format';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _cvvController,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (value.length != 3) {
                    return 'Invalid CVV';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _processPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        child: const Text(
          'Complete Payment',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}