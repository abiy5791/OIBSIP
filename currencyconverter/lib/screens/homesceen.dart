import 'package:currencyconverter/components/anyToany.dart';
import 'package:currencyconverter/components/usdToany.dart';
import 'package:currencyconverter/models/ratesmodel.dart';
import 'package:currencyconverter/service/fetchdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Ratesmodel> result;
  late Future<Map> allcurrencies;

  @override
  void initState() {
    super.initState();
    result = fetchRates();
    allcurrencies = fetchCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Currency Converter"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          width: width,
          height: height,
          child: SingleChildScrollView(
            child: FutureBuilder<Ratesmodel>(
              future: result,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error loading data');
                } else {
                  return FutureBuilder<Map>(
                    future: allcurrencies,
                    builder: (context, currencysnapshot) {
                      if (currencysnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (currencysnapshot.hasError) {
                        return const Text('Error loading data');
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            UsdToAny(
                              currencies: currencysnapshot.data!,
                              rates: snapshot.data!.rates,
                            ),
                            AnyToAny(
                              currencies: currencysnapshot.data!,
                              rates: snapshot.data!.rates,
                            ),
                          ],
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
