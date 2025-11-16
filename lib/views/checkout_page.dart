import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  final double totalAmount;

  const CheckoutPage({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Total Amount:",
              style: TextStyle(fontSize: 22),
            ),
            Text(
              "₱${totalAmount.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Order Completed"),
                      content: const Text("Thank you for your purchase!"),
                      actions: [
                        TextButton(
                          child: const Text("OK"),
                          onPressed: () {
                            Navigator.pop(context);        // close dialog
                            Navigator.pop(context);        // back to product page
                          },
                        )
                      ],
                    );
                  },
                );
              },
              child: const Text("Place Order", style: TextStyle(fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }
}
