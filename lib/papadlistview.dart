import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

//@JsonSerializable()

class Audio {
   Audio({required this.id, required this.name, required this.description, required this.audiolink});
   
  final int id;
  final String name;
  final String description;
  final  String audiolink;

  factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio(
      id: json['id'],
      name: json['name'],
      audiolink: json['upload'] ?? '',
      description: json['description'] ,
    );
  }
}

class AudioListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Audio>>(
      future: _fetchAudios(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Audio>? data = snapshot.data;
          return _AudioListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<List<Audio>> _fetchAudios() async {

      var dioRequest = dio.Dio();
    dioRequest.options.baseUrl = 'http://127.0.0.1:8000/api/v1';

    //[2] ADDING TOKEN
    dioRequest.options.headers['content-Type'] = 'application/json';
    dioRequest.options.headers["Authorization"] = "Token 897f04bf657caad25954f6867fda09680f90421f";
    try{
    var response = await dioRequest.get("/archive/?group=10");
        final result = json.decode(response.toString());
    if (response.statusCode == 200) {
      String jsonResponse = jsonEncode(result['results']);
      List  jsonout = json.decode(jsonResponse);
      //print(result['results']);
      // print(jsonout);
      // print('success');
      return jsonout.map((audio) => new Audio.fromJson(audio)).toList();
    }
    } on DioError  catch (ex) {
      if(ex.type == DioErrorType.connectTimeout){
        throw Exception("Connection Timeout Exception");
      }
      throw Exception(ex.message);
    }
    // else {
      throw Exception('Failed to load jobs from API');
    // }
  }

  ListView _AudioListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          //if(data[index].audiolink.isEmpty) ;
          //https://github.com/flutter/flutter/issues/108705
         // issuses with livview item builder null values 
          return _tile(data[index].name, data[index].description, data[index].audiolink,Icons.music_note_rounded);
        });
  }

  ListTile _tile(String title, String subtitle, String audiolink, IconData icon) => ListTile(
            title: Text(title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
        subtitle: Text(subtitle),
        leading: Icon(
          icon,
          color: Colors.blue[500],
        ),
      );
}