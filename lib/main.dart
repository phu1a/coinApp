import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

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

class CryptoList extends StatefulWidget {
  const CryptoList({super.key, required this.title});
  final String title;

  @override
  State<CryptoList> createState() => _CryptoListState();
}

class _CryptoListState extends State<CryptoList> {
  List<CryptoCoin>? _cryptoCoinsList;

  @override
  void initState() {
    _loadCryptoCoins();
    super.initState();
  }

  Future<void> _loadCryptoCoins() async {
    _cryptoCoinsList = await CryptoCoinsRepository().getCoinsList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 38, 38, 38),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 38, 38, 38),
        title: Center(
          child: Text(
            'Crypto Currencies List',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
      ),
      body:
          (_cryptoCoinsList == null)
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                padding: const EdgeInsets.only(top: 16),
                separatorBuilder:
                    (context, index) => Divider(
                      color: const Color.fromARGB(113, 255, 255, 255),
                    ),
                itemCount: _cryptoCoinsList!.length,
                itemBuilder: (context, i) {
                  final coin = _cryptoCoinsList![i];
                  final coinName = coin.name;
                  final price = _cryptoCoinsList![i];
                  final priceUSD = price.priceInUSD;

                  return ListTile(
                    leading: Image.network(coin.imageUrl),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white54,
                    ),
                    title: Text(
                      coinName,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    subtitle: Text(
                      '${priceUSD.toString()} \$',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/coin',
                        arguments: coinName,
                        // MaterialPageRoute(builder: (context) => CryptoCoinScreen()),
                      );
                    },
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.download),
        onPressed: () async {
          _cryptoCoinsList = await CryptoCoinsRepository().getCoinsList();
          setState(() {});
        },
      ),
    );
  }
}

class CryptoCoinScreen extends StatefulWidget {
  const CryptoCoinScreen({super.key});

  @override
  State<CryptoCoinScreen> createState() => _CryptoCoinScreenState();
}

class _CryptoCoinScreenState extends State<CryptoCoinScreen> {
  String? coinName;
  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null) {
      log('You must provide args');
      return;
    }
    if (args is! String) {
      log('You must provide String args');
      return;
    }
    coinName = args;
    // setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            coinName ?? '...',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 38, 38, 38),
        iconTheme: IconThemeData(color: Colors.white),
      ),
    );
  }
}

class CryptoCoinsRepository {
  Future<List<CryptoCoin>> getCoinsList() async {
    final response = await Dio().get(
      'https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC,ETH,ADA,SOL,DOT,AVAX,LUNA,LINK,ALGO,ATOM&tsyms=USD',
    );
    final data = response.data as Map<String, dynamic>;
    final dataRaw = data['RAW'] as Map<String, dynamic>;
    final cryptoCoinList =
        dataRaw.entries.map((e) {
          final usdData =
              (e.value as Map<String, dynamic>)['USD'] as Map<String, dynamic>;
          final price = usdData['PRICE'];
          final imageUrl = usdData['IMAGEURL'];
          return CryptoCoin(
            name: e.key,
            priceInUSD: price,
            imageUrl: 'https://www.cryptocompare.com/$imageUrl',
          );
        }).toList();
    return cryptoCoinList;
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
