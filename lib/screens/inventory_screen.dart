import 'package:flutter/material.dart';
import '../models/product.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  final List<Product> products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory & POS Kiosk'),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context, 
            builder: (context) {
            return AlertDialog(
              title: const Text('Add Product'),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                    ),
                  ),

                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                    ),
                  ),

                  TextField(
                    controller: stockController,
                    decoration: const InputDecoration(
                      labelText: 'Stock',
                    ),
                  ),
                ],
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  child: const Text('Cancel'),
                ),

                TextButton(
                  onPressed: (){
                    setState(() {
                      products.add(
                        Product(
                        name: nameController.text,
                        price: double.parse(priceController.text),
                        stock: int.parse(stockController.text),
                      
                      ),
                    );
                  });
                  
                  Navigator.pop(context);

                  nameController.clear();
                  priceController.clear();
                  stockController.clear();
                  },

                  child: const Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),

      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return Dismissible(
            key: Key(product.name), 

            onDismissed: (direction) {
              setState(() {
                products.removeAt(index);
              });
            },

            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              color: Colors.red,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            
            child: ListTile(
              onTap: () {
                nameController.text = product.name;
                priceController.text = product.price.toString();
                stockController.text = product.stock.toString();

                showDialog(
                  context: context, 
                  builder:(context) {
                    return AlertDialog(
                      title: const Text("Edit Product"),

                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Product Name',
                            ),
                          ),

                          TextField(
                            controller: priceController,
                            decoration: const InputDecoration(
                              labelText: 'Price',
                            ),
                          ),

                          TextField(
                            controller: stockController,
                            decoration: const InputDecoration(
                              labelText: 'Stock',
                            ),
                          ),
                        ],
                      ),

                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);

                            nameController.clear();
                            priceController.clear();
                            stockController.clear();
                          },
                          child: const Text('Cancel'),
                        ),

                        TextButton(
                          onPressed: () {
                            setState(() {
                              
                              product.name = nameController.text;
                              product.price = double.parse(priceController.text);
                              product.stock = int.parse(stockController.text);

                              nameController.clear();
                              priceController.clear();
                              stockController.clear();

                            });

                            Navigator.pop(context);
                          },

                          child: const Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },

            title: Text(product.name),
            subtitle: Text('Stock: ${product.stock}'),
            trailing: Text('£${product.price}'),
            ),
          );
        }, 
      ),
    );
  }
}