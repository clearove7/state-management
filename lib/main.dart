import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FavoriteModel(maxItems: 20),
      child: const MyApp(),
    ),
  );
}

/// 负责管理 “收藏状态” 的 Model（Publisher）
/// 只要数据改变就 notifyListeners()，UI（Subscriber）会自动更新。
class FavoriteModel extends ChangeNotifier {
  FavoriteModel({required this.maxItems});

  final int maxItems;

  // 用 Set 保存被收藏的 item index（例如 0, 3, 10）
  final Set<int> _fav = <int>{};

  bool isFav(int index) => _fav.contains(index);

  void toggle(int index) {
    if (_fav.contains(index)) {
      _fav.remove(index);
    } else {
      _fav.add(index);
    }
    notifyListeners(); // 通知所有监听者刷新 UI
  }

  int get count => _fav.length;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FavoriteListPage(),
    );
  }
}

class FavoriteListPage extends StatelessWidget {
  const FavoriteListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final maxItems = context.read<FavoriteModel>().maxItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite List'),
        actions: [
          // 右上角显示收藏数量（可选，但很常见）
          Consumer<FavoriteModel>(
            builder: (context, model, _) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(child: Text('Fav: ${model.count}')),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: maxItems, // ✅ 限制 item = 20
        itemBuilder: (context, index) {
          // 只重建这一行（Consumer 包住 row）
          return Consumer<FavoriteModel>(
            builder: (context, model, _) {
              final isFav = model.isFav(index);

              return ListTile(
                title: Text('Item #$index'),
                trailing: IconButton(
                  onPressed: () => model.toggle(index),
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : null,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
