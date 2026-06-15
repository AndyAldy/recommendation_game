import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game.dart';
import '../provider/game_provider.dart';
import '../services/api_services.dart';

class DetailScreen extends StatefulWidget {
  final Game game;

  const DetailScreen({Key? key, required this.game}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<Map<String, dynamic>> _gameDetailFuture;

  @override
  void initState() {
    super.initState();
    // Memanggil API detail saat layar ini dibuka
    _gameDetailFuture = ApiService().getGameDetail(widget.game.id);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    final isFavorite = provider.isFavorite(widget.game.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        backgroundColor: Colors.transparent, // Mengikuti style mockup
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: () {
              provider.toggleFavorite(widget.game);
            },
          )
        ],
      ),
      extendBodyBehindAppBar: true, // Agar gambar cover bisa sampai ke area atas (AppBar)
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Cover
            Image.network(
              widget.game.backgroundImage ?? '',
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 300,
                color: Colors.grey[800],
                child: const Icon(Icons.image_not_supported, size: 50),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul Game
                  Text(
                    widget.game.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  
                  // Info Rilis & Rating
                  Row(
                    children: [
                      Text('Release date ${widget.game.released ?? '-'}'),
                      const SizedBox(width: 16),
                      const Icon(Icons.star, color: Colors.yellow, size: 16),
                      Text(' ${widget.game.rating}'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Deskripsi Game (Memuat dari FutureBuilder)
                  FutureBuilder<Map<String, dynamic>>(
                    future: _gameDetailFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Text('Gagal memuat deskripsi.');
                      } else if (snapshot.hasData) {
                        // Menggunakan description_raw agar tidak ada tag HTML
                        final description = snapshot.data!['description_raw'] ?? 'Tidak ada deskripsi.';
                        return Text(
                          description,
                          style: const TextStyle(fontSize: 14, height: 1.5),
                        );
                      }
                      return const SizedBox();
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