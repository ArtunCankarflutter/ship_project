import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_2/screens/login_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ship_detail_screen.dart';
import 'compare_screen.dart';
import '../providers/favorites_provider.dart'; 
import 'favorites_screen.dart'; 
import 'admin_screen.dart';
import '../services/admin_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> sellingShips = [];
  List<dynamic> rentalShips = [];
  List<Map<String, dynamic>> filteredShips = [];
  String searchText = "";
  String selectedFilter = "All";
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    fetchSellingShips();
    fetchRentalShips();
    _checkAdminStatus();
  }
Future<void> _checkAdminStatus() async {
  final adminStatus = await AdminService.isUserAdmin();
  if (mounted) {
    setState(() {
      isAdmin = adminStatus;
    });
  }
}  

Future<void> fetchSellingShips() async {
  final response = await http.get(Uri.parse("http://localhost/get_ships.php"));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    setState(() {
      sellingShips = data.map((ship) {
        ship['selling_price'] = ship['selling_price'] != null
            ? int.tryParse(ship['selling_price'].toString()) ?? 0
            : 0; 
        ship['user_rating'] = double.tryParse(ship['user_rating']?.toString() ?? "0.0") ?? 0.0; // Parse as float
        return ship;
      }).toList();
      applyFilters(); 
    });
  } else {
    print("Failed to load selling ships");
  }
}

Future<void> fetchRentalShips() async {
  final response =
      await http.get(Uri.parse("http://localhost/get_rental_ships.php"));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    setState(() {
      rentalShips = data.map((ship) {
        ship['rental_price_per_day'] = ship['rental_price_per_day'] != null
            ? int.tryParse(ship['rental_price_per_day'].toString()) ?? 0
            : 0; 
        ship['user_rating'] = double.tryParse(ship['user_rating']?.toString() ?? "0.0") ?? 0.0; // Parse as float
        return ship;
      }).toList();
      applyFilters(); 
    });
  } else {
    print("Failed to load rental ships");
  }
}


void applyFilters({
  int minSellingPrice = 0,
  int maxSellingPrice = 100000000,
  int minRentalPrice = 0,
  int maxRentalPrice = 100000,
  double minLength = 0,
  double maxLength = 1000,
  double minWidth = 0,
  double maxWidth = 100,
  List<String> shipTypes = const [],
  int userRating = 1,
}) {
  setState(() {
    List<Map<String, dynamic>> filteredSellingShips = [];
    List<Map<String, dynamic>> filteredRentalShips = [];
    
    // Check if selling price filter is being used
    bool isSellingPriceFiltered = minSellingPrice > 0 || maxSellingPrice < 100000000;
    // Check if rental price filter is being used
    bool isRentalPriceFiltered = minRentalPrice > 0 || maxRentalPrice < 100000;
    
    // Filter selling ships
    if (!isRentalPriceFiltered) {  // Only include selling ships if rental price filter is not active
      filteredSellingShips = sellingShips.map((ship) => Map<String, dynamic>.from(ship)).where((ship) {
        final price = ship['selling_price'] is int 
            ? ship['selling_price'] 
            : int.tryParse(ship['selling_price'].toString()) ?? 0;
        
        bool passes = true;
        
        // Price filter
        passes = price >= minSellingPrice && price <= maxSellingPrice;
        
        // Length and Width filters
        if (passes) {
          final length = double.tryParse(ship['ship_length']?.toString() ?? '0') ?? 0.0;
          final width = double.tryParse(ship['ship_width']?.toString() ?? '0') ?? 0.0;
          
          bool lengthPasses = length >= minLength && length <= maxLength;
          bool widthPasses = width >= minWidth && width <= maxWidth;
          passes = lengthPasses && widthPasses;
        }
        
        // Type filter
        if (passes && shipTypes.isNotEmpty) {
          final shipType = (ship['ship_type'] ?? '').toString().trim();
          passes = shipTypes.any((type) => 
            type.trim().toLowerCase() == shipType.toLowerCase()
          );
        }
        
        // Rating filter
        if (passes && userRating > 1) {
          final rating = double.tryParse(ship['user_rating']?.toString() ?? '0') ?? 0.0;
          passes = rating >= userRating;
        }
        
        // Search filter
        if (passes && searchText.isNotEmpty) {
          passes = ship['ship_name'].toString().toLowerCase().contains(searchText.toLowerCase());
        }
        
        return passes;
      }).toList();
    }

    // Filter rental ships
    if (!isSellingPriceFiltered) {  // Only include rental ships if selling price filter is not active
      filteredRentalShips = rentalShips.map((ship) => Map<String, dynamic>.from(ship)).where((ship) {
        final price = ship['rental_price_per_day'] is int 
            ? ship['rental_price_per_day'] 
            : int.tryParse(ship['rental_price_per_day'].toString()) ?? 0;
        
        bool passes = true;
        
        // Price filter
        passes = price >= minRentalPrice && price <= maxRentalPrice;
        
        // Length and Width filters
        if (passes) {
          final length = double.tryParse(ship['ship_length']?.toString() ?? '0') ?? 0.0;
          final width = double.tryParse(ship['ship_width']?.toString() ?? '0') ?? 0.0;
          
          bool lengthPasses = length >= minLength && length <= maxLength;
          bool widthPasses = width >= minWidth && width <= maxWidth;
          passes = lengthPasses && widthPasses;
        }
        
        // Type filter
        if (passes && shipTypes.isNotEmpty) {
          final shipType = (ship['ship_type'] ?? '').toString().trim();
          passes = shipTypes.any((type) => 
            type.trim().toLowerCase() == shipType.toLowerCase()
          );
        }
        
        // Rating filter
        if (passes && userRating > 1) {
          final rating = double.tryParse(ship['user_rating']?.toString() ?? '0') ?? 0.0;
          passes = rating >= userRating;
        }
        
        // Search filter
        if (passes && searchText.isNotEmpty) {
          passes = ship['ship_name'].toString().toLowerCase().contains(searchText.toLowerCase());
        }
        
        return passes;
      }).toList();
    }

    // If no price filters are active, show all filtered ships
    if (!isSellingPriceFiltered && !isRentalPriceFiltered) {
      filteredShips = [...filteredSellingShips, ...filteredRentalShips];
    } 
    // If selling price filter is active, show only selling ships
    else if (isSellingPriceFiltered) {
      filteredShips = filteredSellingShips;
    }
    // If rental price filter is active, show only rental ships
    else {
      filteredShips = filteredRentalShips;
    }
  });
}




void resetFilters() {
  setState(() {
    // First, print the counts to debug
    print('\nReset Filters - Initial counts:');
    print('Selling ships: ${sellingShips.length}');
    print('Rental ships: ${rentalShips.length}');
    
    searchText = "";
    selectedFilter = "All";
    
    // Make sure we're creating new lists to avoid reference issues
    filteredShips = [
      ...List<Map<String, dynamic>>.from(sellingShips),
      ...List<Map<String, dynamic>>.from(rentalShips)
    ];
    
    // Print final count to verify
    print('Combined ships after reset: ${filteredShips.length}');
  });
}



void showFilterOptions() {
  int minSellingPrice = 0;
  int maxSellingPrice = 100000000; // Maximum selling price
  int minRentalPrice = 0;
  int maxRentalPrice = 100000; // Maximum rental price per day
  double minShipLength = 0; // Initial min length filter value
  double maxShipLength = 1000; // Max length
  double minShipWidth = 0; // Initial min width filter value
  double maxShipWidth = 100; // Max width
  List<String> selectedShipTypes = [];
  int selectedRating = 0; // Initial user rating filter value

  // Dynamically gather all ship types
  final allShipTypes = {
    ...sellingShips.map((ship) => ship['ship_type']?.toString() ?? ""),
    ...rentalShips.map((ship) => ship['ship_type']?.toString() ?? ""),
  }.where((type) => type.isNotEmpty).toList();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Filters",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const Divider(),

                  // Price Filter
                  ExpansionTile(
                    title: const Text("Price"),
                    children: [
                      // Selling Price Filter
                      const Text(
                        "Selling Price",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      RangeSlider(
                        values: RangeValues(
                          minSellingPrice.toDouble(),
                          maxSellingPrice.toDouble(),
                        ),
                        min: 0,
                        max: 100000000, // Adjust the maximum value accordingly
                        divisions: 100,
                        labels: RangeLabels(
                          "\$${minSellingPrice.toString()}",
                          "\$${maxSellingPrice.toString()}",
                        ),
                        onChanged: (values) {
                          setModalState(() {
                            minSellingPrice = values.start.toInt();
                            maxSellingPrice = values.end.toInt();
                          });
                        },
                      ),
                      Text(
                        "Selling Price Range: \$${minSellingPrice} - \$${maxSellingPrice}",
                      ),
                      const SizedBox(height: 16),

                      // Rental Price Filter
                      const Text(
                        "Rental Price Per Day",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      RangeSlider(
                        values: RangeValues(
                          minRentalPrice.toDouble(),
                          maxRentalPrice.toDouble(),
                        ),
                        min: 0,
                        max: 100000, // Adjust the maximum value accordingly
                        divisions: 100,
                        labels: RangeLabels(
                    '\$${minRentalPrice.toStringAsFixed(0)}',
                    '\$${maxRentalPrice.toStringAsFixed(0)}',
                  ),
                        onChanged: (values) {
                          setModalState(() {
                            minRentalPrice = values.start.toInt();
                            maxRentalPrice = values.end.toInt();
                          });
                        },
                      ),
                      Text(
                        "Rental Price Range: \$${minRentalPrice} - \$${maxRentalPrice}",
                      ),
                    ],
                  ),

                  const Divider(),

                  // Dynamic Ship Type Filter
                  ExpansionTile(
                    title: const Text("Ship Type"),
                    children: [
                      Wrap(
                        spacing: 8,
                        children: allShipTypes.map((type) {
                          return FilterChip(
                            label: Text(type),
                            selected: selectedShipTypes.contains(type),
                            onSelected: (selected) {
                              setModalState(() {
                                if (selected) {
                                  selectedShipTypes.add(type);
                                } else {
                                  selectedShipTypes.remove(type);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),

                  // Ship Size Filter
                  ExpansionTile(
                    title: const Text("Size"),
                    children: [
                      // Length Filter
                      const Text(
                        "Ship Length (in meters)",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      RangeSlider(
                        values: RangeValues(
                          minShipLength,
                          maxShipLength,
                        ),
                        min: 0,
                        max: 1000, // Adjust the maximum value
                        divisions: 100,
                        labels: RangeLabels(
                          "${minShipLength.toInt()} m",
                          "${maxShipLength.toInt()} m",
                        ),
                        onChanged: (values) {
                          setModalState(() {
                            minShipLength = values.start;
                            maxShipLength = values.end;
                          });
                        },
                      ),
                      Text(
                        "Length Range: ${minShipLength.toInt()} m - ${maxShipLength.toInt()} m",
                      ),
                      const SizedBox(height: 16),

                      // Width Filter
                      const Text(
                        "Ship Width (in meters)",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      RangeSlider(
                        values: RangeValues(
                          minShipWidth,
                          maxShipWidth,
                        ),
                        min: 0,
                        max: 100, // Adjust the maximum value
                        divisions: 100,
                        labels: RangeLabels(
                          "${minShipWidth.toInt()} m",
                          "${maxShipWidth.toInt()} m",
                        ),
                        onChanged: (values) {
                          setModalState(() {
                            minShipWidth = values.start;
                            maxShipWidth = values.end;
                          });
                        },
                      ),
                      Text(
                        "Width Range: ${minShipWidth.toInt()} m - ${maxShipWidth.toInt()} m",
                      ),
                    ],
                  ),

                  // User Rating Filter
                  ExpansionTile(
                    title: const Text("User Rating"),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              index < selectedRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                            ),
                            onPressed: () {
                              setModalState(() {
                                selectedRating = index + 1;
                              });
                            },
                          );
                        }),
                      ),
                      Text("Minimum Rating: $selectedRating+ Stars"),
                    ],
                  ),

                  const Divider(),

                  ElevatedButton(
  onPressed: () {
    Navigator.pop(context);
    applyFilters(
      minSellingPrice: minSellingPrice,
      maxSellingPrice: maxSellingPrice,
      minRentalPrice: minRentalPrice,
      maxRentalPrice: maxRentalPrice,
      minLength: minShipLength,
      maxLength: maxShipLength,
      minWidth: minShipWidth,
      maxWidth: maxShipWidth,
      shipTypes: selectedShipTypes,
      userRating: selectedRating,
    );
  },
  child: const Text("Apply Filters"),
),

                ],
              ),
            ),
          );
        },
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ships Marketplace"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false, 
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              // Navigate to a screen that shows the list of favorite ships
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search by name",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                  applyFilters(); // Apply search filter
                });
              },
            ),
          ),
          // Büyük Gemi Resmi
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Image.network(
              "https://www.worldhistory.org/uploads/images/14047.png",
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Compare ve Filter Butonları
          Padding(
  padding: const EdgeInsets.all(8.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      ElevatedButton.icon(
        onPressed: () async {
          final selectedShips = await showDialog<List<Map<String, dynamic>>?>(
            context: context,
            builder: (context) {
              return CompareDialog(
                ships: filteredShips,
              );
            },
          );

          if (selectedShips != null && selectedShips.length == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompareScreen(
                  ship1: selectedShips[0],
                  ship2: selectedShips[1],
                ),
              ),
            );
          }
        },
        icon: const Icon(Icons.compare_arrows),
        label: const Text("Compare"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      Row(
        children: [
          ElevatedButton.icon(
            onPressed: resetFilters,
            icon: const Icon(Icons.refresh),
            label: const Text("Reset"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: showFilterOptions,
            icon: const Icon(Icons.filter_list),
            label: const Text("Filter"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    ],
  ),
),
          // Gemi Listesi
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 4,
    childAspectRatio: 0.65,
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
  ),
  itemCount: filteredShips.length,
  itemBuilder: (context, index) {
    final ship = filteredShips[index];

    return ShipCard(
      name: ship['ship_name'],
      type: ship['ship_type'],
      length: ship['ship_length'],
      width: ship['ship_width'],
      price: ship['selling_price'] ?? ship['rental_price_per_day'],
      imageUrl: ship['image_url'] ?? '',
      backgroundColor: ship['selling_price'] != null
          ? Colors.blue.shade700
          : Colors.green.shade700,
      shipData: ship,
      onFavorite: () {
        final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
        favoritesProvider.addFavorite(ship);
      },
    );
  },
),

            ),
          ),
        ],
      ),
      floatingActionButton: isAdmin ? FloatingActionButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AdminScreen(),
        ),
      );
    },
    backgroundColor: Colors.red,
    child: const Icon(Icons.admin_panel_settings),
    tooltip: 'Admin Panel',
  ) : null,
);
  }
}

class CompareDialog extends StatefulWidget {
  final List<Map<String, dynamic>> ships;

  const CompareDialog({required this.ships, Key? key}) : super(key: key);

  @override
  _CompareDialogState createState() => _CompareDialogState();
}

class _CompareDialogState extends State<CompareDialog> {
  Map<String, dynamic>? selectedShip1;
  Map<String, dynamic>? selectedShip2;

  @override
  Widget build(BuildContext context) {
    final ships = widget.ships;

    return AlertDialog(
      title: const Text("Select Two Ships to Compare"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<Map<String, dynamic>>(
            hint: const Text("Select Ship 1"),
            value: selectedShip1,
            items: ships.map((ship) {
              return DropdownMenuItem(
                value: ship,
                child: Text(ship['ship_name']),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedShip1 = value;
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButton<Map<String, dynamic>>(
            hint: const Text("Select Ship 2"),
            value: selectedShip2,
            items: ships.map((ship) {
              return DropdownMenuItem(
                value: ship,
                child: Text(ship['ship_name']),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedShip2 = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: selectedShip1 != null && selectedShip2 != null
              ? () {
                  Navigator.pop(context, [selectedShip1!, selectedShip2!]);
                }
              : null,
          child: const Text("Compare"),
        ),
      ],
    );
  }
}


class ShipCard extends StatelessWidget {
  final String name;
  final String type;
  final String length;
  final String width;
  final int price;
  final String? imageUrl;
  final Color backgroundColor;
  final Map<String, dynamic> shipData;
  final VoidCallback onFavorite; 


  const ShipCard({
    required this.name,
    required this.type,
    required this.length,
    required this.width,
    required this.price,
    required this.imageUrl,
    required this.backgroundColor,
    required this.shipData,
    required this.onFavorite,
    Key? key,
  }) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.directions_boat_filled,
                        size: 100,
                        color: Colors.grey,
                      ),
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              color: backgroundColor.withOpacity(0.9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Type: $type",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Length: $length m  Width: $width m",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    backgroundColor == Colors.blue.shade700
                        ? "Selling Price: \$${price.toString()}"
                        : "Rental Price/Day: \$${price.toString()}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.yellowAccent,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Add Buttons for "Buy Now" and "Rent Now"
                  ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShipDetailScreen(
          shipName: name,
          shipData: shipData,
        ),
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.amber, // Gold button color
  ),
  child: Text(
    backgroundColor == Colors.blue.shade700 ? "Buy Now" : "Rent Now",
    style: const TextStyle(
      color: Colors.black, // Black text for contrast
    ),
  ),
),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}





