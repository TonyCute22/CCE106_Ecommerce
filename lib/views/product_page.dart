import 'package:flutter/material.dart';
import 'package:task8_ecommerce/models/product_model.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int selectedIndex = 0;
  int currentNavIndex = 0;
  Set<Product> favoriteProducts = {};

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
        child: currentNavIndex == 0 ? _buildHome() : _buildFavorites(),
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
        ],
      ),
    );
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

        // Category Buttons
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

  // CATEGORY BUTTON
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

  // PRODUCT GRID
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
        childAspectRatio: 0.7,
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

    return GestureDetector(
      onTap: () {},
      child: Container(
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
            // PRODUCT IMAGE
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(product.image, fit: BoxFit.cover),
              ),
            ),

            const SizedBox(height: 8),

            // PRODUCT NAME
            Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            // PRICE
            Text(
              "₱${product.price}",
              style: const TextStyle(color: Colors.green, fontSize: 14),
            ),

            // FAVORITE ICON BUTTON
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
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
            )
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // FAVORITES PAGE
  // ----------------------------------------------------------

  Widget _buildFavorites() {
    if (favoriteProducts.isEmpty) {
      return const Center(
        child: Text(
          "No favorite products yet.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return GridView.builder(
      itemCount: favoriteProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        final product = favoriteProducts.toList()[index];
        return _buildProductCard(product);
      },
    );
  }
}
