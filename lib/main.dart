import 'package:flutter/material.dart';
import 'screens/inventory_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(); // start Hive system

  await Hive.openBox('inventory'); // creates inventory

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'POS Kiosk', 
      home: InventoryScreen(),
    );
  }
}