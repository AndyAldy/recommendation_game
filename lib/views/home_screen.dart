import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/game_provider.dart';
import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Games For You'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onSubmitted: (query) {
                if (query.isNotEmpty) provider.searchGames(query);
                else {
                  provider.games.clear();
                  provider.currentPage = 1;
                  provider.fetchGames();
                }
              },
            ),
          ),
        ),
      ),
      body: provider.isLoading && provider.games.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.games.length + 1,
              itemBuilder: (context, index) {
                if (index == provider.games.length) {
                  if (!provider.isLoading) provider.fetchGames();
                  return Center(child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator()));
                }
                final game = provider.games[index];
                return ListTile(
                  leading: Image.network(game.backgroundImage ?? '', width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (_,__,___) => Icon(Icons.image)),
                  title: Text(game.name),
                  subtitle: Text('Release date: ${game.released ?? '-'}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.yellow),
                      Text(game.rating.toString()),
                    ],
                  ),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(game: game))),
                );
              },
            ),
    );
  }
}