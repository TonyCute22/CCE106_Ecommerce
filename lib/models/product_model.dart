class Product{
  final String name;
  final String price;
  final String status;
  final String image;
  final String category;

  Product({

    required this.name,
    required this.price,
    required this.status,
    required this.image,
    required this.category,

  });

}

final List<Product> products = [
  Product(
    name: 'Nike Air Max 200',
    price:'180.00',
    status: 'Trending Now',
    image: 'assets/shoes1.jpg',
    category: 'Sneakers',
  ),
  Product(
    name: 'Nike Originals',
    price:'120.00',
    status: 'Out of Stock',
    image: 'assets/shoes2.jpg',
    category: 'Sneakers',
  ),
  Product(
    name: 'Adidas Hoodie Jacket',
    price:'90.00',
    status: 'Trending Now',
    image: 'assets/jacket1.png',
    category: 'Jackets',
  ),
  Product(
    name: 'Leather Jacket',
    price:'130.00',
    status: 'Out of Stock',
    image: 'assets/jacket2.png',
    category: 'Jackets',
  ),
];