import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/game_provider.dart';
import '../provider/theme_provider.dart'; // Import ThemeProvider
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasSearchText = false; // State untuk mendeteksi teks di search bar

  @override
  void initState() {
    super.initState();
    // Pantau perubahan teks di textfield
    _searchController.addListener(() {
      setState(() {
        _hasSearchText = _searchController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context); // Ambil state tema

    return Scaffold(
      appBar: AppBar(
        title: const Text('Games For You'),
        // Tombol Toggle Dark Mode / Light Mode
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme(); // Balikkan mode tema saat diklik
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                // Tombol X (Clear) muncul HANYA jika ada teks
                suffixIcon: _hasSearchText 
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          FocusScope.of(context).unfocus();
                          provider.games.clear();
                          provider.currentPage = 1;
                          provider.fetchGames();
                        },
                      )
                    : null, // Jika kosong, set ke null (menghilang)
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
                  subtitle: Text('Release date ${game.released ?? '-'}'),
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