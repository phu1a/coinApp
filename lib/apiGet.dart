import 'package:dio/dio.dart';
import 'package:lesson1/abstractCoinsRepository.dart';
import 'package:lesson1/main.dart';

class CryptoCoinsRepository implements AbstractCoinsRepository {
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
