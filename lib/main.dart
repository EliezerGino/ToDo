import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';


void main(){
  runApp(
    MaterialApp(
      home: Home()
    )
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _toDoController = TextEditingController();

  List _toDoList = [];

  @override
  void initState(){
    super.initState();

    _readData().then((data){
      setState(() {
         _toDoList = json.decode(data);
      });
    });
  }

  void _AddToDo(){
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo['title'] = _toDoController.text;
      _toDoController.text = '';
      newToDo['Ok'] = false;
      _toDoList.add(newToDo);
      _saveDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                  controller: _toDoController,
                  decoration: InputDecoration(
                    labelText: 'Nova Tarefa',
                    labelStyle: TextStyle(
                      color: Colors.blueAccent,
                    )
                  ),
                 ),
                ),
                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text(
                    'ADD'
                  ),
                  textColor: Colors.white,
                  onPressed: _AddToDo,
                )
              ],
            )
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10.0),
              itemCount: _toDoList.length,
              itemBuilder: buildIten
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIten (context, index){
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child:  CheckboxListTile(
        title: Text(_toDoList[index]["title"]),
        value: _toDoList[index]["Ok"],
        secondary: CircleAvatar(
          child: Icon(_toDoList[index]["Ok"] ? 
          Icons.check : Icons.error)),
          onChanged: (c){
            setState(() {
              _toDoList[index]["Ok"] = c;
              _saveDate();
            });
          },
        )
    );
  }


  //


  Future<File> _getFile() async {
  final directory = await getApplicationDocumentsDirectory();
  return File("${directory.path}/data.json");
  }

  Future<File> _saveDate() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }
  
  Future<String> _readData()async{
    try {
      final file = await _getFile();
      return file.readAsString();
    }catch(e){
      return null;
    }
  }

}

