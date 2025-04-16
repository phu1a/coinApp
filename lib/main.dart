import 'package:lesson1/cryptoList.dart';
import 'cryptoCoinScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Currencies List',
      theme: ThemeData(
        textTheme: TextTheme(
          displayMedium: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 25,
          ),
          displaySmall: TextStyle(fontSize: 18, color: Colors.white70),
        ),
        dividerColor: Colors.black,
      ),
      routes: {
        '/': (context) => CryptoList(title: 'Crypto Currencies List'),
        '/coin': (context) => CryptoCoinScreen(),
      },
      // home: const CryptoList(title: 'Crypto Currencies List'),
    );
  }
}

class CryptoCoin {
  const CryptoCoin({
    required this.name,
    required this.priceInUSD,
    required this.imageUrl,
  });
  final String name;
  final double priceInUSD;
  final String imageUrl;
}
