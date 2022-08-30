import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:fraction/services/ad_services.dart';

class StockPS extends StatefulWidget {
  const StockPS({Key key}) : super(key: key);

  @override
  _StockPSState createState() => _StockPSState();
}

class _StockPSState extends State<StockPS> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController capitalContorller = TextEditingController();
  TextEditingController riskController = TextEditingController();
  TextEditingController entryController = TextEditingController();
  TextEditingController slController = TextEditingController();
  TextEditingController targetController = TextEditingController();
  TextEditingController leverageController = TextEditingController();
  // BannerAd _bannerAd;

  // bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    // _bannerAd = BannerAd(
    //   adUnitId: AdServices().androidBannerId,
    //   request: const AdRequest(),
    //   size: AdSize.banner,
    //   listener: BannerAdListener(
    //     onAdLoaded: (_) {
    //       setState(() {
    //         _isBannerAdReady = true;
    //       });
    //     },
    //     onAdFailedToLoad: (ad, err) {
    //       _isBannerAdReady = false;
    //       ad.dispose();
    //     },
    //   ),
    // )..load();
  }

  @override
  void dispose() {
    // _bannerAd.dispose();

    capitalContorller.dispose();
    riskController.dispose();
    entryController.dispose();
    slController.dispose();
    targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Position Size Calculator',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),

      // body of the stocks page

      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: ListView(
            children: [
              // _isBannerAdReady
              //     ? Center(
              //         child: SizedBox(
              //           width: _bannerAd.size.width.toDouble(),
              //           height: _bannerAd.size.height.toDouble(),
              //           child: AdWidget(ad: _bannerAd),
              //         ),
              //       )
              //     : const SizedBox(),
              SizedBox(
                height: height * 0.02,
              ),

              // Capital Field
              TextFormField(
                autofocus: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  return null;
                },
                maxLines: 1,
                cursorWidth: 3,
                decoration: InputDecoration(
                  labelText: 'Capital',
                  hintText: 'Eg. 20000',
                  hintStyle: const TextStyle(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                controller: capitalContorller,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                cursorColor: Colors.deepPurple.shade300,
                cursorHeight: 28,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              SizedBox(
                height: height * 0.02,
              ),

              // Leverage on capital
              TextFormField(
                autofocus: true,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  return null;
                },
                maxLines: 1,
                cursorWidth: 3,
                decoration: InputDecoration(
                  labelText: ' Leverage on capital',
                  hintText: 'Eg. If 2X, type 2. If 5X, type 5.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                controller: leverageController,
                keyboardType: TextInputType.number,
                cursorColor: Colors.deepPurple.shade300,
                cursorHeight: 28,
                textInputAction: TextInputAction.next,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: height * 0.02,
              ),

              // Risk Field
              TextFormField(
                autofocus: true,

                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return 'This field cannot be empty';
                  }
                },
                maxLines: 1,
                cursorWidth: 3,
                decoration: InputDecoration(
                  hintText: ' Risk ( % )',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                controller: riskController,
                keyboardType: TextInputType.number,
                cursorColor: Colors.deepPurple.shade300,
                cursorHeight: 28,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              // The Entry
              TextFormField(
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return 'This field cannot be empty';
                  } else if (double.parse(value) >
                      double.parse(capitalContorller.text)) {
                    return 'Entry Price cannot be over capital';
                  }
                },
                maxLines: 1, autofocus: true,

                cursorWidth: 3,
                decoration: InputDecoration(
                  hintText: ' Entry Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                controller: entryController,
                keyboardType: TextInputType.number,
                cursorColor: Colors.deepPurple.shade300,
                cursorHeight: 28,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: height * 0.02,
              ),

              // SL
              TextFormField(
                textInputAction: TextInputAction.next,
                autofocus: true,

                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return 'This field cannot be empty';
                  } else if (double.parse(value) >
                      double.parse(entryController.text)) {
                    return 'SL should always be smaller than entry';
                  }
                },
                maxLines: 1,
                cursorWidth: 3,
                decoration: InputDecoration(
                  hintText: ' Stop Loss',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                controller: slController,
                keyboardType: TextInputType.number,
                cursorColor: Colors.deepPurple.shade300,
                cursorHeight: 28,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: height * 0.02,
              ),

              // Target
              TextFormField(
                textInputAction: TextInputAction.done,
                autofocus: true,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return 'This field cannot be empty';
                  }
                },
                maxLines: 1,
                cursorWidth: 3,
                decoration: InputDecoration(
                  hintText: ' Target',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                controller: targetController,
                keyboardType: TextInputType.number,
                cursorColor: Colors.deepPurple.shade300,
                cursorHeight: 28,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: height * 0.06,
              ),
              //  fa button
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.deepPurple.shade400,
                  elevation: 1,
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      // Total capital leveraged leverage
                      double leverageBasedCapital =
                          double.parse(leverageController.text) *
                              double.parse(capitalContorller.text);

                      // Total money risking per trade AKA account risk

                      double accountRisk = double.parse(
                          ((double.parse(riskController.text) / 100.00) *
                                  leverageBasedCapital)
                              .toStringAsFixed(2));

// trade risk calc in percentage =   % difference in the entry and sl

                      double tradeRisk = double.parse(
                          (double.parse(entryController.text) -
                                  double.parse(slController.text))
                              .toStringAsFixed(2));

// Position Size in number of shares

                      int numberOfShares = (accountRisk / tradeRisk).round();

// Total risk with capital
                      double totalRisk = numberOfShares *
                          (double.parse((double.parse(entryController.text) -
                                  double.parse(slController.text))
                              .toStringAsFixed(2)));

// Total profit to be made
                      double targetProfit = numberOfShares *
                          (double.parse((double.parse(targetController.text) -
                                  double.parse(entryController.text))
                              .toStringAsFixed(2)));

// Rewars per share
                      double rewardPerShare = double.parse(
                          (double.parse(targetController.text) -
                                  double.parse(entryController.text))
                              .toStringAsFixed(2));

                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const ListTile(
                              tileColor: Colors.deepPurple,
                              title: Center(
                                child: Text(
                                  'Calculations',
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.white),
                                ),
                              ),
                            ),
                            content: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.9,
                              width: MediaQuery.of(context).size.width,
                              child: ListView(
                                children: [
                                  resultListTile(
                                      title: 'Leveraged Capital',
                                      subtitle: '$leverageBasedCapital'),
                                  resultListTile(
                                      title: 'Number of shares',
                                      subtitle: '$numberOfShares'),
                                  resultListTile(
                                      title: 'Total Risk Involved',
                                      subtitle: totalRisk.toStringAsFixed(2)),
                                  resultListTile(
                                      title: 'Risk per Share',
                                      subtitle:
                                          '${totalRisk / numberOfShares}'),
                                  resultListTile(
                                      title: 'Reward per Share',
                                      subtitle: '$rewardPerShare'),
                                  resultListTile(
                                      title: 'Target Profit',
                                      subtitle: '$targetProfit'),
                                  resultListTile(
                                      title: 'Risk to Reward ratio',
                                      subtitle:
                                          '${totalRisk / totalRisk} : ${(targetProfit / totalRisk).toStringAsFixed(2)}'),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.deepPurple.shade400),
                                ),
                                child: const Text(
                                  'Close',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  label: const Text(
                    'Caclulate',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget resultListTile({String title, String subtitle}) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
