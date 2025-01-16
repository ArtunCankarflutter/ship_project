import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'checkout_screen.dart';
import '../providers/favorites_provider.dart'; 

class ShipDetailScreen extends StatefulWidget {
  final Map<String, dynamic> shipData;
  final String shipName;

  const ShipDetailScreen({
    Key? key,
    required this.shipName,
    required this.shipData,
  }) : super(key: key);

  @override
  State<ShipDetailScreen> createState() => _ShipDetailScreenState();
}

class _ShipDetailScreenState extends State<ShipDetailScreen> {
  bool isFavourite = false;
  double userRating = 0.0;
  bool isLoading = true;
  final TextEditingController _commentController = TextEditingController();

@override
void initState() {
  super.initState();
  fetchRating(widget.shipName); 
}

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> fetchRating(String shipName) async {
  try {
    final isRental = !widget.shipData.containsKey('selling_price');
    final response = await http.post(
      Uri.parse("http://localhost/get_rating.php"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "ship_name": shipName,
        "is_rental": isRental,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        userRating = data['rating']?.toDouble() ?? 0.0;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load rating');
    }
  } catch (e) {
    print('Error fetching rating: $e');
    setState(() {
      isLoading = false;
      userRating = 0.0;
    });
  }
}



  void toggleFavourite() {
    setState(() {
      isFavourite = !isFavourite;
    });
  }

  void proceedToCheckout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(
          shipData: widget.shipData,
          shipName: widget.shipName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shipData = widget.shipData;
    final isForSale = shipData.containsKey('selling_price');
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFavorite = favoritesProvider.isFavorite(shipData);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shipName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  shipData['image_url'] ?? '',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Type: ${shipData['ship_type']}",
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                "Length: ${shipData['ship_length']} m",
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                "Width: ${shipData['ship_width']} m",
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                isForSale
                    ? "Selling Price: \$${shipData['selling_price']}"
                    : "Rental Price: \$${shipData['rental_price_per_day']}/day",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              Text(
                "Seller: ${shipData['seller'] ?? "Unknown"}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    "User Rating:",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 8),
                  if (isLoading)
                    const CircularProgressIndicator()
                  else
                    RatingBar.builder(
                      initialRating: userRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 24,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) {
                        setState(() {
                          userRating = rating;
                        });
                      },
                    ),
                  const SizedBox(width: 8),
                  Text(userRating.toStringAsFixed(1)),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Comments',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _commentController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Write a comment...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Comments coming soon!')),
                          );
                        },
                        child: const Text('Post Comment'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: 
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              if (isFavorite) {
                favoritesProvider.removeFavorite(shipData);
              } else {
                favoritesProvider.addFavorite(shipData);
              }
            },
          ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: proceedToCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isForSale ? "Buy Now" : "Rent Now",
                    style: const TextStyle(fontSize: 18),
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







