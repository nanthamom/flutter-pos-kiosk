import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'checkout_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  final List<Product> products = [];
  String searchQuery = ''; // search products

  @override
  void initState() { // screen opens, runs once
    super.initState();

    loadProducts(); // load saved products from Hive
  }

  void loadProducts() {
    final box = Hive.box('inventory'); // connect to Hive database
    // box.clear(); // delete key indexes
    print(box.keys);
    print(box.values);

    print('Total Hive Records: ${box.length}');
    print(box.values);
    
    for (var key in box.keys) { // loop through every saved item in Hive
      final item = box.get(key);
      products.add( // add each item into products list
        Product( // convert Hive data into Product Object
          hiveKey: key,
          name: item['name'],
          price: item['price'],
          stock: item['stock'],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

      final filteredProducts = products.where((product) {
        return product.name
              .toLowerCase()
              .contains(searchQuery.toLowerCase());
      }).toList();

      // Analytics Dashboard
      final totalProducts = products.length;
      final lowStockCount = products.where((product) {
        return product.stock <= 5;
      }).length;
      final inventoryValue = products.fold(0.0, (sum,product) {
        return sum + (product.price * product.stock);
      });

      return Scaffold(

      appBar: AppBar(
        title: const Text('Inventory & POS'),
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

                    nameController.clear();
                    priceController.clear();
                    stockController.clear();
                  },

                  child: const Text('Cancel'),
                ),

                TextButton(
                  onPressed: (){
                    setState(() {

                      final box = Hive.box('inventory');

                      box.delete('test');
                      print(box.keys);
                      print(box.values);

                      box.add({
                        'name': nameController.text,
                        'price': double.parse(priceController.text),
                        'stock': int.parse(stockController.text),
                      });

                      print(box.values);

                      products.add(
                        Product(
                        hiveKey: 0,
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

      body: Column(
      children: [

        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      const Text('Product'),
                      Text('$totalProducts'),
                  ],
                ),
              ),
            ),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const Text('Low Stock'),
                    Text('$lowStockCount'),
                  ],
                ),
              ),
            ),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const Text('value'),
                    Text('£${inventoryValue.toStringAsFixed(2)}'),
                  ],
                ),
              ),            
            ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: searchController,

            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },

            decoration: const InputDecoration(
              hintText: 'Search Products',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),

        Expanded(
          child: ListView.builder(
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {

              final product = filteredProducts[index];

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutScreen(
                      product: product,
                    ),
                  ),
                );

                nameController.text = product.name;
                priceController.text = product.price.toString();
                stockController.text = product.stock.toString();

                // showDialog(
                //   context: context, 
                //   builder:(context) {
                //     return AlertDialog(
                //       title: const Text("Edit Product"),

                //       content: Column(
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           TextField(
                //             controller: nameController,
                //             decoration: const InputDecoration(
                //               labelText: 'Product Name',
                //             ),
                //           ),

                //           TextField(
                //             controller: priceController,
                //             decoration: const InputDecoration(
                //               labelText: 'Price',
                //             ),
                //           ),

                //           TextField(
                //             controller: stockController,
                //             decoration: const InputDecoration(
                //               labelText: 'Stock',
                //             ),
                //           ),
                //         ],
                //       ),

                //       actions: [
                //         TextButton(
                //           onPressed: () {
                //             Navigator.pop(context);

                //             nameController.clear();
                //             priceController.clear();
                //             stockController.clear();
                //           },
                //           child: const Text('Cancel'),
                //         ),

                //         TextButton(
                //           onPressed: () {
                //             setState(() {
                              
                //               product.name = nameController.text;
                //               product.price = double.parse(priceController.text);
                //               product.stock = int.parse(stockController.text);

                //               nameController.clear();
                //               priceController.clear();
                //               stockController.clear();

                //             });

                //             Navigator.pop(context);
                //           },

                //           child: const Text('Save'),
                //         ),
                //       ],
                //     );
                //   },
                // );
              },
          
            title: Text(product.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  'Stock: ${product.stock}',
                ),
                if (product.stock <= 5)
                const Text(
                  '⚠ Low Stock',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
             trailing: Text('£${product.price}'),
            ),
          );
        }, // itemBuilder
      ), // ListView.builder
    ), // Expanded
  ], // children
), // Column
);

}
}// Scaffold