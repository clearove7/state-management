import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => CartModel(), child: const MyApp()),
  );
}

class CartModel extends ChangeNotifier {
  final List<String> _items = [];

  List<String> get items => _items;

  void add(String item) {
    _items.add(item);
    notifyListeners();
  }

  void remove(String item) {
    _items.remove(item);
    notifyListeners();
  }

  int get totalPrice => _items.length * 42;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CatalogPage(),
    );
  }
}

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  static final List<Map<String, dynamic>> products = [
    {'name': 'Code Smell', 'color': Colors.red},
    {'name': 'Control Flow', 'color': Colors.pink},
    {'name': 'Interpreter', 'color': Colors.purple},
    {'name': 'Recursion', 'color': Colors.deepPurple},
    {'name': 'Sprint', 'color': Colors.indigo},
    {'name': 'Heisenbug', 'color': Colors.blue},
    {'name': 'Spaghetti', 'color': Colors.lightBlue},
    {'name': 'Hydra Code', 'color': Colors.cyan},
    {'name': 'Off-By-One', 'color': Colors.teal},
    {'name': 'Scope', 'color': Colors.green},
    {'name': 'Callback', 'color': Colors.lightGreen},
  ];

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFFFF7E6), // 👈 米色背景
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final item = products[index];
            final name = item['name'];
            final color = item['color'];
            final isAdded = context.watch<CartModel>().items.contains(name);

            return ListTile(
              leading: Container(width: 24, height: 24, color: color),
              title: Text(name),
              trailing: isAdded
                  ? const Icon(Icons.check, color: Colors.black)
                  : TextButton(
                      child: const Text('ADD'),
                      onPressed: () {
                        context.read<CartModel>().add(name);
                      },
                    ),
            );
          },
        ),
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Container(
        color: Colors.yellow,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: cart.items
                    .map(
                      (item) => ListTile(
                        leading: const Icon(Icons.check),
                        title: Text(item),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => cart.remove(item),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.black)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${cart.totalPrice}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: const Text('BUY'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SummaryPage()),
                      );
                    },
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

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Purchase Summary')),
      body: Container(
        color: const Color(0xFFFFF7E6),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thank you for your purchase!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Items:'),
            ...cart.items.map((e) => Text('- $e')),
            const SizedBox(height: 16),
            Text('Total: \$${cart.totalPrice}'),
            const Spacer(),
            Center(
              child: ElevatedButton(
                child: const Text('Back to Home'),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
