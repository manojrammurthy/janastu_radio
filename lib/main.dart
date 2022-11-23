import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'RecordPage.dart';
import 'papadlistview.dart';


void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

 
class _MyAppState extends State<MyApp> {
   int currentIndex = 0;
   final widgetTitle = ["Home", "Record Audio", "playfrompapad"];
 
  final List<Widget> _pages = <Widget>[
    Homepage(),
     Recordpage(),
     AudioListView(),
];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JanastuHome',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title:  Text(widgetTitle.elementAt(currentIndex)),
        ),
        body: Center(
          child: _pages.elementAt(currentIndex)
        ),

        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.white,
          items:  [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'Record Audio',
              icon: Icon(Icons.mic),
            ),
            BottomNavigationBarItem(
              label: 'Play From Papad',
              icon: Icon(Icons.radio),
            )
          ],
          currentIndex: currentIndex,
          onTap: (int Index) {
            setState(
              () {
                currentIndex = Index;
              },
            );
          },
        ),
      ),
    );
  }
}

