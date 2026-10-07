import 'package:flutter/material.dart';

import '../data/regions.dart';
import '../models/region_feed.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('World News'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: regions.length,
        itemBuilder: (context, index) {
          final RegionFeed region = regions[index];

          return Card(
            child: ListTile(
              title: Text(region.name),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                print('Região selecionada: ${region.name}');
              },
            ),
          );
        },
      ),
    );
  }
}