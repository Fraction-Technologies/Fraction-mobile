import 'package:flutter/material.dart';
import 'package:pron/views/dashboard.dart';
import 'package:pron/views/edit.dart';
import 'calculators.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int index = 0;
  var screens = [Dashboard(), Calculators(), Edit()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE5E5E5),
      body: screens[index],

// Drawer
      drawer: Drawer(
        child: Column(
          children: [
            Container(),
          ],
        ),
      ),

      // appbar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 1,
        title: Text('fraction'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.wb_sunny_outlined),
          )
        ],
        centerTitle: true,
      ),

      //    Bottom nav bar location here
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          height: MediaQuery.of(context).size.height * 0.07,
          // labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          indicatorColor: Color(0xff9b77da),
        ),
        child: NavigationBar(
          selectedIndex: this.index,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          onDestinationSelected: (nIndex) {
            setState(() {
              this.index = nIndex;
            });
          },
          animationDuration: Duration(seconds: 1),
          destinations: [
//  Tradebook Screen

            NavigationDestination(
                selectedIcon: Icon(Icons.book),
                icon: Icon(Icons.book_outlined),
                label: 'dashboard'),

// Stats Screen
            NavigationDestination(
                selectedIcon: Icon(Icons.pie_chart_rounded),
                icon: Icon(Icons.pie_chart_outline),
                label: 'calculator'),

// Reminders screen
            NavigationDestination(
              selectedIcon: Icon(Icons.edit),
              icon: Icon(Icons.edit_outlined),
              label: 'edit',
            ),
          ],
        ),
      ),
    );
  }
}