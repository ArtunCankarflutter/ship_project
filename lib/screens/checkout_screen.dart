import 'package:flutter/material.dart';
import 'payment_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<String, dynamic> shipData;
  final String shipName;

  const CheckoutScreen({
    Key? key,
    required this.shipData,
    required this.shipName,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  DateTime _rentalStartDate = DateTime.now();
  DateTime? _rentalEndDate;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _rentalStartDate : (_rentalEndDate ?? _rentalStartDate.add(const Duration(days: 1))),
      firstDate: isStartDate ? DateTime.now() : _rentalStartDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _rentalStartDate = picked;
          if (_rentalEndDate != null && _rentalEndDate!.isBefore(_rentalStartDate)) {
            _rentalEndDate = null;
          }
        } else {
          _rentalEndDate = picked;
        }
      });
    }
  }

  void _proceedToPayment() {
  if (_formKey.currentState!.validate()) {
    final isForSale = widget.shipData.containsKey('selling_price');
    
    if (!isForSale && _rentalEndDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an end date for rental')),
      );
      return;
    }

    double totalAmount;
    if (isForSale) {
      totalAmount = double.parse(widget.shipData['selling_price'].toString());
    } else {
      // Calculate number of days between start and end date
      final rentalDays = _rentalEndDate!.difference(_rentalStartDate).inDays + 1;
      final dailyRate = double.parse(widget.shipData['rental_price_per_day'].toString());
      totalAmount = dailyRate * rentalDays;
    }

    final customerDetails = {
      'fullName': _nameController.text,
      'email': _emailController.text,
      'phoneNumber': _phoneController.text,
      'address': _addressController.text,
      'totalAmount': totalAmount,
      if (!isForSale) ...{
        'rental_start': _rentalStartDate.toIso8601String(),
        'rental_end': _rentalEndDate!.toIso8601String(),
        'rental_duration': _rentalEndDate!.difference(_rentalStartDate).inDays + 1,
      },
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          shipData: widget.shipData,
          shipName: widget.shipName,
          customerDetails: customerDetails,
        ),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final isForSale = widget.shipData.containsKey('selling_price');

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout - ${widget.shipName}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Summary',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Ship: ${widget.shipName}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        isForSale
                            ? 'Price: \$${widget.shipData['selling_price']}'
                            : 'Daily Rate: \$${widget.shipData['rental_price_per_day']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Customer Information',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Shipping Address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              if (!isForSale) ...[
                const SizedBox(height: 24),
                Text(
                  'Rental Period',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _selectDate(context, true),
                        child: Text(
                          'Start: ${_rentalStartDate.toString().split(' ')[0]}',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _selectDate(context, false),
                        child: Text(
                          _rentalEndDate == null
                              ? 'Select End Date'
                              : 'End: ${_rentalEndDate!.toString().split(' ')[0]}',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _proceedToPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Proceed to Payment',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}