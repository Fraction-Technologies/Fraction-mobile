import 'package:flutter/material.dart';
import 'package:pron/model/transaction_database.dart';

class Transactions extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const Transactions();

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  TextEditingController amountController = TextEditingController();
  DateTime _date;
  List<bool> dwButtons = [true, false];

  Tdbase _helper;

  @override
  void initState() {
    super.initState();
    setState(() {
      _helper = Tdbase.instance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Transaction'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: MediaQuery.of(context).size.height * 0.34,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The amount field
            TextField(
              textInputAction: TextInputAction.done,
              autofocus: false,
              showCursor: false,
              cursorWidth: 3,
              decoration: InputDecoration(
                hintText: ' Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
              controller: amountController,
              maxLines: 1,
            ),

            // Date field
            ListTile(
              title: Text(
                _date == null
                    ? 'Date'
                    : 'Selected date : ${_date.year} - ${_date.month} - ${_date.day}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(_date == null
                  ? 'The date on which you tool this trade'
                  : 'Long press to reset date'),
              leading: const Icon(Icons.calendar_today_outlined),
              onTap: () {
                _dateSetUp(context);
              },
              onLongPress: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text('Resetting date'),
                  ),
                );
                setState(() {
                  _date = null;
                });
              },
            ),

            // The deposit or withdrawal
            ToggleButtons(
              onPressed: (index) {
                setState(() {
                  if (index == 0) {
                    dwButtons[0] = true;
                    dwButtons[1] = false;
                  } else {
                    dwButtons[1] = true;
                    dwButtons[0] = false;
                  }
                });
              },
              fillColor: dwButtons[0] == true ? Colors.green : Colors.red,
              disabledColor: Colors.grey,
              selectedColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
              borderWidth: 3,
              children: const [
                Padding(
                  padding: EdgeInsets.all(17.0),
                  child: Text(
                    'Deposit',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.4),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(17.0),
                  child: Text(
                    'withdraw',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.4),
                  ),
                )
              ],
              isSelected: dwButtons,
            ),

            // The add to db button
            ElevatedButton(
              onPressed: () {
                _validateAndAddToDatabase();
              },
              child: Text(dwButtons[0] ? 'make deposit' : 'make withdrawal'),
            )
          ],
        ),
      ),
    );
  }

  _validateAndAddToDatabase() async {
    if (amountController.text.isNotEmpty && _date != null) {
      await _helper.insertTransaction(
        {
          Tdbase.amount: double.parse(
              double.parse(amountController.text).toStringAsFixed(2)),
          Tdbase.date: '${_date.year}/${_date.month}/${_date.day}',
          Tdbase.type: dwButtons[0] == true ? 1 : 0
        },
      );
      Navigator.pop(context, true);
    } else if (amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text('Please add an amount'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 3),
        content: Text('Pick a date'),
      ));
    }
  }

  _dateSetUp(BuildContext context) async {
    DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 50),
      lastDate: DateTime.now(),
    );

    setState(() {
      _date = pickedDate;
    });
  }
}
