import 'package:crypto2/data/constant/constant.dart';
import 'package:crypto2/screens/HomePage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:crypto2/data/model/Crypto.dart';
import 'package:flutter/widgets.dart';

class CoinPage extends StatefulWidget {
  final List<Crypto>? cryptoList;

  CoinPage({super.key, this.cryptoList});

  @override
  State<CoinPage> createState() => _CoinPageState();
}

class _CoinPageState extends State<CoinPage> {
  String appBarTitle = 'کریپتو بازار';
  List<Crypto>? cryptoList;
  final _controller = TextEditingController();

  List<Crypto> _foundCryptoList = [];

  @override
  void initState() {
    super.initState();

    if (widget.cryptoList != null) {
      cryptoList = widget.cryptoList;
      _foundCryptoList = cryptoList!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: blackColor,
        title: Center(
          child: Text(
            appBarTitle,
            style: TextStyle(fontFamily: 'mh', color: greyColor),
          ),
        ),
      ),
      backgroundColor: blackColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'اسم رمز ارز معتبر را سرچ کنید',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 0, style: BorderStyle.none),
                    ),
                    filled: true,
                    fillColor: greenColor,
                    icon: Icon(Icons.search),
                    iconColor: greenColor,
                    hintStyle: TextStyle(fontFamily: 'mh', color: Colors.white),
                  ),
                  onChanged: search,
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                backgroundColor: Colors.green,
                color: blackColor,
                onRefresh: _refreshData,
                child: ListView.builder(
                  itemCount: _foundCryptoList.length,
                  itemBuilder: (context, index) {
                    return _getListTileItem(_foundCryptoList[index], index);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void search(String query) {
    List<Crypto> result = [];
    print(' on change in queary : => $query');
    if (query.isEmpty) {
      result = cryptoList!;
    } else {
      result = cryptoList!
          .where((crypto) =>
              crypto.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundCryptoList = result;
    });
  }

  bool isLessThanZero(double percentChange) {
    return percentChange <= 0 ? true : false;
  }

  Widget _getIcon(double number) {
    return isLessThanZero(number)
        ? Icon(
            Icons.trending_down,
            color: _getColor(number),
          )
        : Icon(
            Icons.trending_up,
            color: _getColor(number),
          );
  }

  Color _getColor(double number) {
    return isLessThanZero(number) ? redColor : greenColor;
  }

  Widget _getRow(double percentChange, int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(children: [
              Text(
                _foundCryptoList[index].priceUsd.toStringAsFixed(2),
                style: TextStyle(color: greyColor, fontSize: 18),
              ),
              Text(
                " \$",
                style: TextStyle(color: greyColor, fontSize: 18),
              )
            ]),
            Row(
              children: [
                Text(
                    _foundCryptoList[index]
                        .changePercent24Hr
                        .toStringAsFixed(2),
                    style: TextStyle(
                        color: _getColor(
                            (_foundCryptoList[index].changePercent24Hr)),
                        fontSize: 15)),
                Text(
                  ' %',
                  style: TextStyle(
                      color:
                          _getColor(_foundCryptoList[index].changePercent24Hr),
                      fontSize: 18),
                )
              ],
            ),
          ],
        ),
        _getIcon(_foundCryptoList[index].changePercent24Hr)
      ],
    );
  }

  Widget _getListTileItem(Crypto crypto, int index) {
    return ListTile(
        title: Text(
          crypto.name,
          style: TextStyle(color: greyColor),
        ),
        subtitle: Text(
          crypto.symbol,
          style: TextStyle(color: greyDarkColor),
        ),
        leading: Text(crypto.rank.toString(),
            style: TextStyle(color: greyDarkColor, fontSize: 16)),
        trailing: _getRow(crypto.changePercent24Hr, index));
  }

  Future<void> _refreshData() async {
    Response response = await Dio().get('https://api.coincap.io/v2/assets');

    List<Crypto> myList2 = response.data['data'].map<Crypto>(
      (element) {
        return Crypto.mapJsonObject(element);
      },
    ).toList();

    if (myList2[0].name != null) {
      setState(() {
        cryptoList = myList2;
      });
    }
  }
}
