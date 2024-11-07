import 'package:crypto2/data/constant/constant.dart';
import 'package:crypto2/data/model/Crypto.dart';
import 'package:crypto2/screens/CoinPage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Crypto>? cryptoList;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/images/logo.png'),
            ),
            SpinKitWave(
              size: 30.0,
              color: greyColor,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getData() async {
    Response response = await Dio().get('https://api.coincap.io/v2/assets');

    List<Crypto> myList = response.data['data']
        .map<Crypto>((Element) => Crypto.mapJsonObject(Element))
        .toList();

    if (myList[0].name.isNotEmpty) {
      cryptoList = myList;
    } else {
      print('this is null !');
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoinPage(
          cryptoList: cryptoList,
        ),
      ),
    );
  }
}
