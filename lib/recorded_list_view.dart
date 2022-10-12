import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart' as dio;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';


class RecordListView extends StatefulWidget {
  final List<String> records;
  const RecordListView({
    Key? key,
    required this.records,
  }) : super(key: key);

  @override
  _RecordListViewState createState() => _RecordListViewState();
}

class _RecordListViewState extends State<RecordListView> {
  late int _totalDuration;
  late int _currentDuration;
  double _completedPercentage = 0.0;
  bool _isPlaying = false;
  int _selectedIndex = -1;
  bool isLocal = false;
  bool _isShown = true;

  @override
  Widget build(BuildContext context) {
    return widget.records.isEmpty
        ? Center(child: Text('No records yet'))
        : ListView.builder(
            itemCount: widget.records.length,
            shrinkWrap: true,
            reverse: true,
            itemBuilder: (BuildContext context, int i) {
              return ExpansionTile(
                title: Text('New recoding ${widget.records.length - i}'),
                subtitle: Text(_getDateFromFilePatah(
                    filePath: widget.records.elementAt(i))),
                onExpansionChanged: ((newState) {
                  if (newState) {
                    setState(() {
                      _selectedIndex = i;
                    });
                  }
                }),
                children: [
                  Container(
                    height: 140,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LinearProgressIndicator(
                          minHeight: 5,
                          backgroundColor: Colors.black,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green),
                          value: _selectedIndex == i ? _completedPercentage : 0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: _selectedIndex == i
                                  ? _isPlaying
                                      ? Icon(Icons.pause)
                                      : Icon(Icons.play_arrow)
                                  : Icon(Icons.play_arrow),
                              onPressed: () => _onPlay(
                                  filePath: widget.records.elementAt(i),
                                  index: i),
                            ),
                            IconButton(
                              icon: Icon(Icons.upload_file_outlined),
                              onPressed: () => _fileupload(
                                  context, widget.records.elementAt(i), i),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_outline),
                              onPressed: () => _delete(
                                context, widget.records.elementAt(i), i),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
  }
//   void _onLoading(BuildContext context) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return Dialog(
//         child: new Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             new CircularProgressIndicator(),
//             new Text("Loading"),
//           ],
//         ),
//       );
//     },
//   );
//   new Future.delayed(new Duration(seconds: 3), () {
//     Navigator.pop(context); //pop dialog
//    // _login();
//   });
// }
Future<void> _fileupload(BuildContext context, String filePath, int index) async {
  //    showDialog(
  //   context: context,
  //   barrierDismissible: false,
  //   builder: (BuildContext context) {
  //     return Dialog(
  //       child: new Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           new CircularProgressIndicator(),
            
  //         ],
  //       ),
  //     );
  //   },
  // );
  
  //   //Navigator.pop(context); //pop dialog
    try {
      ///[1] CREATING INSTANCE
      var dioRequest = dio.Dio();
      dioRequest.options.baseUrl = 'http://127.0.0.1:8000/api/v1';

      //[2] ADDING TOKEN
      dioRequest.options.headers["Authorization"] = "Token 897f04bf657caad25954f6867fda09680f90421f";
      // dioRequest.options.headers = {
      //   'Authorization': '897f04bf657caad25954f6867fda09680f90421f',
      //   // 'Content-Type': 'application/x-www-form-urlencoded'
      // };

      //[3] ADDING EXTRA INFO
      var formData =
          new dio.FormData.fromMap({'name': 'manojtest',
          'description':'This is a Audio Archive Demo1',
          'tags':'janastu,audio,demo,archive',
          'group':'10'});

      // //[4] ADD IMAGE TO UPLOAD
      var file = await dio.MultipartFile.fromFile(filePath,
            filename: basename(filePath),
           // contentType: MediaType("image", basename(image.path))
            );

      formData.files.add(MapEntry('upload', file));  

      //[5] SEND TO SERVER
      try{
      var response = await dioRequest.post("/archive/",
        data: formData,
      );
      }
      on DioError catch(e){
        throw Exception(e.response?.data); 

   }
      // final result = json.decode(response.toString())['result'];
      // print(result);
    } catch (err) {
      print('ERROR  $err');
    }
  //  // _login(); 

}
  void _delete(BuildContext context, String filePath, int index) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Please Confirm'),
            content: const Text('Are you sure to delete the audio?'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () async {
                    try {
                      final file = await File(filePath);
                      await file.delete();
                      setState(() {
                        widget.records.removeAt(index);
                        _isPlaying = false;
                        widget.records.length;
                      });
                      ;
                    } catch (e) {
                      return print('Recorded file path: $filePath, $index');
                    }

                    // Close the dialog
                    Navigator.of(context,rootNavigator: true).pop();
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context,rootNavigator: true).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }

  Future<void> _onPlay({required String filePath, required int index}) async {
    AudioPlayer audioPlayer = AudioPlayer();
    //if (kDebugMode) print('Recorded file path: $filePath, $index');

    if (!_isPlaying) {
      audioPlayer.play(DeviceFileSource(filePath));
      setState(() {
        _selectedIndex = index;
        _completedPercentage = 0.0;
        _isPlaying = true;
      });
    } else {
      audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    }

    audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
        _completedPercentage = 0.0;
      });
    });
    audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _totalDuration = duration.inMicroseconds;
      });
    });
//
    audioPlayer.onPositionChanged.listen((duration) {
      setState(() {
        _currentDuration = duration.inMicroseconds;
        _completedPercentage =
            _currentDuration.toDouble() / _totalDuration.toDouble();
      });
    });
  }
}

String _getDateFromFilePatah({required String filePath}) {
  String fromEpoch = filePath.substring(
      filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));

  DateTime recordedDate =
      DateTime.fromMillisecondsSinceEpoch(int.parse(fromEpoch));
  int year = recordedDate.year;
  int month = recordedDate.month;
  int day = recordedDate.day;

  return ('$year-$month-$day');
}
