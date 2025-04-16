import 'package:flutter/material.dart';
import 'package:lesson1/apiGet.dart';
import 'package:lesson1/main.dart';

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
                      '${priceUSD.toStringAsFixed(2)} \$',
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
