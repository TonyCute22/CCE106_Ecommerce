import 'package:flutter/material.dart';
import 'package:task8_ecommerce/models/product_model.dart';
import 'checkout_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int selectedIndex = 0;
  int currentNavIndex = 0;

  Set<Product> favoriteProducts = {};
  List<Product> cart = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GANDEZA: E-Commerce App'),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _getCurrentPage(),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentNavIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            currentNavIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
        ],
      ),
    );
  }

  Widget _getCurrentPage() {
    if (currentNavIndex == 0) return _buildHome();
    if (currentNavIndex == 1) return _buildFavorites();
    return _buildCart();
  }

  // ----------------------------------------------------------
  // HOME SECTION
  // ----------------------------------------------------------

  Widget _buildHome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Our Products",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _categoryButton("All Products", 0),
            _categoryButton("Jackets", 1),
            _categoryButton("Sneakers", 2),
          ],
        ),

        const SizedBox(height: 15),

        Expanded(child: _buildProductGrid()),
      ],
    );
  }

  Widget _categoryButton(String title, int index) {
    final isSelected = selectedIndex == index;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      onPressed: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Text(title),
    );
  }

  Widget _buildProductGrid() {
    List<Product> displayProducts;

    if (selectedIndex == 0) {
      displayProducts = products;
    } else if (selectedIndex == 1) {
      displayProducts =
          products.where((product) => product.category == 'Jackets').toList();
    } else {
      displayProducts =
          products.where((product) => product.category == 'Sneakers').toList();
    }

    return GridView.builder(
      itemCount: displayProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final product = displayProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  // ----------------------------------------------------------
  // PRODUCT CARD
  // ----------------------------------------------------------

  Widget _buildProductCard(Product product) {
    final bool isFavorite = favoriteProducts.contains(product);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(product.image, fit: BoxFit.cover),
            ),
          ),

          const SizedBox(height: 8),

          // NAME
          Text(
            product.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          // PRICE
          Text(
            "₱${product.price}",
            style: const TextStyle(color: Colors.green, fontSize: 14),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Favorite Button
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    if (isFavorite) {
                      favoriteProducts.remove(product);
                    } else {
                      favoriteProducts.add(product);
                    }
                  });
                },
              ),

              // ADD TO CART BUTTON
              IconButton(
                icon: const Icon(Icons.add_shopping_cart, color: Colors.blue),
                onPressed: () {
                  setState(() {
                    cart.add(product);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${product.name} added to cart!"),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // FAVORITES
  // ----------------------------------------------------------

  Widget _buildFavorites() {
    if (favoriteProducts.isEmpty) {
      return const Center(
        child: Text("No favorite products yet.",
            style: TextStyle(fontSize: 18, color: Colors.grey)),
      );
    }

    final items = favoriteProducts.toList();

    return GridView.builder(
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        return _buildProductCard(items[index]);
      },
    );
  }

  // ----------------------------------------------------------
  // CART SYSTEM
  // ----------------------------------------------------------

  Widget _buildCart() {
    if (cart.isEmpty) {
      return const Center(
        child: Text("Your cart is empty.",
            style: TextStyle(fontSize: 18, color: Colors.grey)),
      );
    }

    double total = 0;
    for (var item in cart) {
      total += double.parse(item.price);
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cart.length,
            itemBuilder: (context, index) {
              final product = cart[index];
              return ListTile(
                leading: Image.asset(product.image, width: 50),
                title: Text(product.name),
                subtitle: Text("₱${product.price}"),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      cart.removeAt(index);
                    });
                  },
                ),
              );
            },
          ),
        ),

        // Checkout Button
        Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CheckoutPage(totalAmount: total),
                ),
              );
            },
            child: Text(
              "Checkout (₱${total.toStringAsFixed(2)})",
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}
