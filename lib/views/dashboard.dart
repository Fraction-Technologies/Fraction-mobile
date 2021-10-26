import 'package:flutter/material.dart';
import 'package:pron/model/database.dart';
import 'package:pron/views/trade_entry.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Map<String, dynamic>> trades = [];
  Dbase _helper;
  double totalInvestment = 0.0;
  double accountBalance = 0;
  @override
  void initState() {
    super.initState();
    setState(() {
      _helper = Dbase.instance;
    });
    _refreshStorageData();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      // Add button

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xffAB9AFF),
        onPressed: () async {
          bool res = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return TradeEntry(
                  bs: 1,
                  edit: 0,
                  entry: '',
                  position: 0,
                  qty: '',
                  scrip: '',
                  sl: '',
                );
              },
            ),
          );

          if (res) {
            _refreshStorageData();
          }
        },
        label: const Text(
          'add',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 19, color: Colors.white),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
          size: 25,
        ),
      ),

      body: Column(
        children: [
          //  Ad banner
          Container(
            height: height * 0.1,
            width: width,
            margin:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 4),
            color: const Color(0xff4E60FF),
          ),

          //  Total investment
          dashLists(height * 0.09, width, const Color(0xff223A32),
              'Account balance  - ', '\$234'),

          //  Total asset under management
          dashLists(height * 0.09, width, const Color(0xff223A32),
              'Total Investment - ', '$totalInvestment'),

          // Position final
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                //  The icon indicating the position trend
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(right: 10, left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.cyan.shade300,
                    ),
                    height: height * 0.08,
                    child: Center(
                      child: Icon(
                        Icons.show_chart,
                        size: 30,
                        color: Colors.green.shade800,
                      ),
                    ),
                  ),
                ),

                // The text of position and the amoutn in red or green
                Expanded(
                  flex: 3,
                  child: Container(
                    height: height * 0.08,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    padding: const EdgeInsets.only(
                        left: 15, right: 25, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade200,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: const [
                        Text(
                          'Position',
                          style: TextStyle(color: Colors.black87, fontSize: 22),
                        ),
                        Text(
                          '\$2',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // The trades panel
          Container(
            height: height * 0.3,
            width: width,
            margin:
                const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
            ),
            child: trades.isEmpty
                ? const Center(
                    child: Text('Add your first trade'),
                  )
                : _pageview(height, width),
          ),
        ],
      ),
    );
  }

  _pageview(height, width) {
    return PageView.builder(
      pageSnapping: true,
      physics: const BouncingScrollPhysics(),
      itemCount: trades.length,

      // The trade cards that are shown in the main screen
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xff6C61B8),
          ),
          height: height * 0.3,
          width: width,
          child: InkWell(
            onLongPress: () {
              _deleteTrade(index);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // The  scrip date , positoin and icon button to delete
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),
                    color: Colors.black54,
                  ),
                  padding: const EdgeInsets.only(
                      top: 7, bottom: 7, right: 15.0, left: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // The scrip and date panels
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${trades[index]['scrip']} ',
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),

                          const SizedBox(
                            width: 15,
                          ),

                          // The dates panel
                          Container(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 4,
                              bottom: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: trades[index]['buyorsell'] == 1
                                    ? [
                                        Colors.green[500],
                                        Colors.lightGreen[500]
                                      ]
                                    : [Colors.pink[500], Colors.red[500]],
                              ),
                            ),
                            child: Text(
                              '${trades[index]['date']}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // The edit and delete button dropdown
                      PopupMenuButton(onSelected: (value) {
                        if (value == 1) {
                          _editPage(index);
                        } else {
                          _deleteTrade(index);
                        }
                      }, itemBuilder: (context) {
                        return const [
                          PopupMenuItem(
                            child: Text('Edit'),
                            value: 1,
                          ),
                          PopupMenuItem(
                            child: Text('Delete'),
                            value: 2,
                          ),
                        ];
                      }),
                    ],
                  ),
                ),

                // The entry , Qty and SL tab
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //  The entry tab
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text(
                            'Entry',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '${trades[index]['entry']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          )
                        ],
                      ),

                      // The Qty tab
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Quantity',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '${trades[index]['qty']}',
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          )
                        ],
                      ),

                      // The sl tab
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Stop Loss',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            trades[index]['sl'] == null
                                ? 'NA'
                                : '${trades[index]['sl']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                // The row for intraday and shyt and approx trade worth
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //The  product type
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Product',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            trades[index]['longorshort'] == 0
                                ? 'Intraday'
                                : trades[index]['longorshort'] == 1
                                    ? 'Swing'
                                    : 'Delivery',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          )
                        ],
                      ),

                      // The total amount used tab
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trades[index]['buyorsell'] == 1
                                ? 'Approx Trade Worth'
                                : 'Approx Risk in Trade',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            trades[index]['buyorsell'] == 1
                                ? (trades[index]['entry'] *
                                        trades[index]['qty'])
                                    .toString()
                                : (trades[index]['qty'] *
                                        (-trades[index]['entry'] +
                                            trades[index]['sl']))
                                    .toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          )
                        ],
                      ),

                      const SizedBox(
                        width: 8,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget dashLists(height, width, Color color, String t1, String t2) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      padding: const EdgeInsets.only(left: 15, right: 25, top: 5, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            t1,
            style: const TextStyle(color: Colors.white, fontSize: 22),
          ),
          Text(
            t2,
            style: const TextStyle(
              fontSize: 22,
              color: Colors.lightGreenAccent,
            ),
          ),
        ],
      ),
    );
  }

  _refreshStorageData() async {
    List<Map<String, dynamic>> item = await _helper.fetchTrades();

    setState(() {
      trades = item;
    });
  }

  _deleteTrade(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text('Are you sure you want to delete this trade?'),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'cancel',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),

            // The cancel button on alert dialog
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.deepPurple.shade400)),
              onPressed: () {
                _helper.deleteTrade(trades[index]['id']);
                Navigator.pop(context);
                _refreshStorageData();
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );
  }

  _editPage(int index) async {
    bool res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TradeEntry(
            edit: 1,
            id: trades[index]['id'],
            scrip: trades[index]['scrip'],
            sl: '${trades[index]['sl']}',
            bs: trades[index]['buyorsell'],
            qty: '${trades[index]['qty']}',
            position: trades[index]['longorshort'],
            entry: '${trades[index]['entry']}',
          );
        },
      ),
    );
    if (res) {
      _refreshStorageData();
    }
  }
}
