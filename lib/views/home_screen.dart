import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/game_provider.dart';
import 'detail_screen.dart';

// Ubah menjadi StatefulWidget agar bisa menggunakan TextEditingController
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controller untuk memanipulasi teks di TextField
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    // Wajib dispose controller agar tidak terjadi memory leak
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Games For You'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController, // Hubungkan controller di sini
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                // Tambahkan tombol Clear (X) di sebelah kanan
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear(); // Hapus teks di UI
                    FocusScope.of(context).unfocus(); // Sembunyikan keyboard
                    
                    // Kembalikan ke daftar game awal
                    provider.games.clear();
                    provider.currentPage = 1;
                    provider.fetchGames();
                  },
                ),
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onSubmitted: (query) {
                if (query.isNotEmpty) {
                  provider.searchGames(query);
                } else {
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
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.games.length + 1,
              itemBuilder: (context, index) {
                // Logic Paging
                if (index == provider.games.length) {
                  if (!provider.isLoading) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      provider.fetchGames();
                    });
                  }
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                
                final game = provider.games[index];
                return ListTile(
                  leading: Image.network(
                    game.backgroundImage ?? '', 
                    width: 50, 
                    height: 50, 
                    fit: BoxFit.cover, 
                    errorBuilder: (_,__,___) => const Icon(Icons.image)
                  ),
                  title: Text(game.name),
                  subtitle: Text('Release date: ${game.released ?? '-'}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.yellow),
                      Text(game.rating.toString()),
                    ],
                  ),
                  onTap: () => Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (_) => DetailScreen(game: game))
                  ),
                );
              },
            ),
    );
  }
}