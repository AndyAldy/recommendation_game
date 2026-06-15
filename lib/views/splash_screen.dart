import 'package:flutter/material.dart';
import 'dart:async';
import 'main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

// 1. Tambahkan SingleTickerProviderStateMixin untuk animasi
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 2. Inisialisasi AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Durasi satu siklus napas (tarik-hembus)
      vsync: this,
    );

    // 3. Definisikan Tween Scaling (efek napas)
    // Berubah dari 95% ukuran asli (begin) ke 105% (end)
    _animation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // Transisi yang halus
      ),
    );

    // 4. Jalankan animasi berulang-ulang (repeat)
    // reverse: true membuatnya membesar lalu mengecil kembali
    _controller.repeat(reverse: true);

    // Logika navigasi (tetap sama, sedikit diperlama agar animasi terlihat)
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainNavigation()),
      );
    });
  }

  @override
  void dispose() {
    // 5. Wajib dispose controller agar hemat memori
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Pastikan warna background sama dengan tema utama agar transisi mulus
    // Di sini saya asumsikan dark mode (0xFF121212)
    return Scaffold(
      backgroundColor: const Color(0xFF121212), 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 6. Bungkus gambar dengan ScaleTransition untuk mengaktifkan animasi
            ScaleTransition(
              scale: _animation,
              child: Image.asset(
                'assets/app_icon.png', // Gambar logo napas resolusi tinggi
                width: 180, // Sesuaikan ukuran
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 50),
            const Text(
              'RAWG Games',
              style: TextStyle(
                fontSize: 32, 
                fontWeight: FontWeight.bold, 
                color: Colors.white,
                letterSpacing: 2.0, // Memberi sedikit jarak antar huruf agar modern
              ),
            ),
          ],
        ),
      ),
    );
  }
}