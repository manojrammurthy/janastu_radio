import 'dart:async';
import 'dart:io';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
//import 'audio_player.dart';
//import 'recorded_list_view.dart';
import 'HomePage.dart';
import 'RecordPage.dart';
import 'PapadPage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

 
class _MyAppState extends State<MyApp> {
   int currentIndex = 0;
   final widgetTitle = ["Home", "Record Audio", "playfrompapad"];
  //  late Directory appDirectory;
  // bool showPlayer = false;
  // String? audioPath;
  // List<String> records = [];

  // @override
  // void initState() {
  //   showPlayer = false;
  //   super.initState();
  //    getApplicationDocumentsDirectory().then((value) {
  //     appDirectory = value;
  //     appDirectory.list().listen((onData) {
  //       if (onData.path.contains('.aac')) records.add(onData.path);
  //     }).onDone(() {
  //       records = records.reversed.toList();
  //       setState(() {
  //         records.length;
  //       });
  //     });
  //   });
  // }

  final List<Widget> _pages = <Widget>[
    Homepage(),
     Recordpage(),
     Papadpage(),
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
                // switch (Index) {
                //   case 0:
                //     //Navigator.pushNamed(context, '/home');
                //     //print(context);
                //     break;
                //   case 1:
                //     //Navigator.pushNamed(context, '/recordAudio');
                //     print(Index);
                //     break;
                //   case 2:
                //     //Navigator.pushNamed(context,'/playfrompapad');
                //     print(Index);
                //     break;
                //   default:
                //     //Navigator.pushNamed(context, '/home');
                //     print(Index);
                //     break;
                // }
                
              },
            );
          },
        ),
      ),
    );
  }
}

