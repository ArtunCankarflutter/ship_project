import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _transactions = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchTransactions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchTransactions() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost/get_transactions.php'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            _transactions = data['data'] ?? [];
            _isLoading = false;
          });
        } else {
          throw Exception(data['error'] ?? 'Unknown error occurred');
        }
      } else {
        throw Exception('Failed to fetch transactions');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<dynamic> _getFilteredTransactions(String type) {
    return _transactions.where((t) => t['type']?.toString() == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Purchases'),
            Tab(text: 'Rentals'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTransactionList(_transactions),
                    _buildTransactionList(_getFilteredTransactions('purchase')),
                    _buildTransactionList(_getFilteredTransactions('rental')),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _fetchTransactions(),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildTransactionList(List<dynamic> transactions) {
    if (transactions.isEmpty) {
      return const Center(
        child: Text('No transactions found'),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchTransactions,
      child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          final isRental = transaction['type']?.toString() == 'rental';

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExpansionTile(
              title: Text(
                transaction['ship_name']?.toString() ?? 'Unknown Ship',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${transaction['full_name']?.toString() ?? 'Unknown'} - ${transaction['purchase_date']?.toString() ?? 'No date'}',
              ),
              leading: Icon(
                isRental ? Icons.calendar_today : Icons.shopping_cart,
                color: isRental ? Colors.blue : Colors.green,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Email', transaction['email']?.toString() ?? 'N/A'),
                      _buildDetailRow('Phone', transaction['phone_number']?.toString() ?? 'N/A'),
                      _buildDetailRow('Address', transaction['address']?.toString() ?? 'N/A'),
                      _buildDetailRow(
                        'Amount',
                        '\$${transaction['total_amount']?.toString() ?? '0'}',
                      ),
                      if (isRental) ...[
                        _buildDetailRow(
                          'Rental Start',
                          transaction['rental_start_date']?.toString() ?? 'N/A',
                        ),
                        _buildDetailRow(
                          'Rental End',
                          transaction['rental_end_date']?.toString() ?? 'N/A',
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}