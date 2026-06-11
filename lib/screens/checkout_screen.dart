import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CheckoutScreen extends StatefulWidget {
  final Product product;

  const CheckoutScreen({
    super.key,
    required this.product,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController quantityController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.product.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Current Stock: ${widget.product.stock}', 
              // inside _CheckoutScreenState so product belongs to widget above
            ),

            const SizedBox(height: 20),

            TextField(
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity to Sell',
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                int quantitySold = 
                  int.parse(quantityController.text);

                int newStock = 
                  widget.product.stock - quantitySold;

                final box = Hive.box('inventory');

                box.put(
                  widget.product.hiveKey,
                  {
                    'name': widget.product.name,
                    'price': widget.product.price,
                    'stock': newStock,
                  },
                );

                print(box.values);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('New Stock: $newStock'),
                  ),
                );
              },

              child: const Text('Complete Sale'),
            ),
          ],
        ),
      ),
    );
  }
}