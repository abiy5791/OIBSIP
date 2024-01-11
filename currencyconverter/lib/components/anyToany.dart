import 'package:currencyconverter/service/fetchdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnyToAny extends StatefulWidget {
  final currencies;
  final rates;
  const AnyToAny({super.key, required this.currencies, required this.rates});

  @override
  State<AnyToAny> createState() => _AnyToAnyState();
}

class _AnyToAnyState extends State<AnyToAny> {
  TextEditingController amountController = TextEditingController();
  String dropdownvalue1 = "AUD";
  String dropdownvalue2 = "AUD";
  String answer = 'Convert Result will be shown here ';
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Card(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Convert Any Currency",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(hintText: 'Enter a number'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    child: DropdownButton<String>(
                  value: dropdownvalue1,
                  icon: const Icon(Icons.arrow_drop_down_rounded),
                  iconSize: 24,
                  elevation: 15,
                  isExpanded: true,
                  underline: Container(
                    height: 2,
                    color: Colors.grey,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue1 = newValue!;
                    });
                  },
                  items: widget.currencies.keys
                      .toSet()
                      .toList()
                      .map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                )),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Text("To"),
                ),
                Expanded(
                    child: DropdownButton<String>(
                  value: dropdownvalue2,
                  icon: const Icon(Icons.arrow_drop_down_rounded),
                  iconSize: 24,
                  elevation: 15,
                  isExpanded: true,
                  underline: Container(
                    height: 2,
                    color: Colors.grey,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue2 = newValue!;
                    });
                  },
                  items: widget.currencies.keys
                      .toSet()
                      .toList()
                      .map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                )),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    answer = amountController.text +
                        ' ' +
                        dropdownvalue1 +
                        ' ' +
                        convertany(widget.rates, amountController.text,
                            dropdownvalue1, dropdownvalue2) +
                        ' ' +
                        dropdownvalue2;
                  });
                },
                child: Text("Convert")),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text(answer),
            )
          ],
        ),
      ),
    );
  }
}
