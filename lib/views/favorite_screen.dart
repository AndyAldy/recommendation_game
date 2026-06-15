import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/game_provider.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    final favorites = provider.favoriteGames;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Games'),
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                'Belum ada game favorit yang ditambahkan.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final game = favorites[index];
                return ListTile(
                  leading: Image.network(
                    game.backgroundImage ?? '',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 60),
                  ),
                  title: Text(
                    game.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text('Release date ${game.released ?? '-'}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.yellow),
                      Text(game.rating.toString()),
                    ],
                  ),
                  onTap: () {
                    // Navigasi ke halaman detail saat diklik
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(game: game),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}