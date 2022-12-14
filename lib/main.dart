import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
//https://www.macoratti.net/19/06/flut_lisb3.htm

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ListView - Http e Json'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key,required this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {

  //Inicializa um list vazio para nao dar erro de inicialização no app.
  List data = [];

  // Função para obter os dados JSON
  Future<String> getJSONData() async {
    var response = await http.get(
        Uri.parse("https://unsplash.com/napi/photos/Q14J2k8VE3U/related"),
        // Aceita somente resposta JSON
        headers: <String, String>{"Accept": "application/json"}
    );

    setState(() {
      // Pega os dados JSON
      data = json.decode(response.body)['results'];
    });

    return "Dados obtidos com sucesso";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:  _criaListView()
    );
}

Widget _criaListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: data.isEmpty ? 0 : data.length,
      itemBuilder: (context, index) {
        return _criaImagemColuna(data[index]);
      }
    );
}

Widget _criaImagemColuna(dynamic item) => Container(
      decoration: const BoxDecoration(
        color: Colors.white54
      ),
      margin: const EdgeInsets.all(4),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: item['urls']['small'],
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fadeOutDuration: const Duration(seconds: 1),
            fadeInDuration: const Duration(seconds: 3),
          ),
          _criaLinha(item)
        ],
      ),
    );

Widget _criaLinha(dynamic item) {
    return ListTile(
      title: Text(
        item['description'] == null ? '' : item['description']
      ),
      subtitle: Text("Likes: ${item['likes']}"),
    );
  }
  
  @override
  void initState() {
    super.initState();
    // Chama o método getJSONData() quando a app inicializa
    getJSONData();
  }
}