import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(MyApp());
}
Future<List<Photo>>fetchPhotos(http.Client client)async{
  final response = await client.get('https://jsonplaceholder.typicode.com/photos');
  return compute(parsePhotos,response.body);
}
List <Photo> parsePhotos(String responseBody){
  final parsed = jsonDecode(responseBody).cast<Map<String,dynamic>>();
  return parsed.map<Photo>((json)=>Photo.fromJson(json)).toList();
}
class Photo{
  final int albumId;
  final int id;
  final String title;
  final String thumbnailUrl;

  Photo({this.albumId,this.id,this.title,this.thumbnailUrl});
  factory Photo.fromJson(Map<String ,dynamic>json){
    return Photo(albumId:json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }

}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Photo>>(future: fetchPhotos(http.Client()),
          builder: (context,snapshot){
        if(snapshot.hasError)print(snapshot.error);
        return snapshot.hasData ? PhotosList(photos:snapshot.data):Center (child: CircularProgressIndicator(),);
          }),
    );
  }
}

class PhotosList extends StatelessWidget{
  final List <Photo> photos;
  PhotosList({Key key, this.photos}):super(key:key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GridView.builder(gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),itemCount: photos.length,itemBuilder: (context,index){
      return Image.network(photos[index].thumbnailUrl);
    },);
  }
}