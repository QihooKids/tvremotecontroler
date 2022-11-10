import 'dart:io';

import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tv remote',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '遥控器'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static const ANDROID_HOME = "ANDROID_HOME";
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _prefs.then((value){
      _controller.text = value.getString(ANDROID_HOME)??"";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
            Offstage(
              child: TextField(
                autofocus: false,
                decoration: InputDecoration(
                  labelText: "环境配置",
                  hintText: "输入 ANDROID_HOME 路径",
                  prefixIcon: Icon(Icons.android),
                ),
                onChanged: (text){
                  _prefs.then((value) => value.setString(ANDROID_HOME, text));
                },
                controller: _controller,
              ),
              offstage: true,
            ),
            _getRemoteControl(),
          ],
      ),
    );
  }

  Widget _getRemoteControl() {
    final shell = Shell();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 100,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: ElevatedButton(onPressed: (){
                  shell.run("adb shell input keyevent 19");
                }, child: Text("上")),
                width: 60,
                height: 30,
                margin: EdgeInsets.all(10),
            )],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
              child: ElevatedButton(onPressed: (){
                shell.run("adb shell input keyevent 21");
              }, child: Text("左")),
              width: 60,
              height: 30,
              margin: EdgeInsets.all(10),
            ),
              Container(
                child: ElevatedButton(onPressed: (){
                  shell.run("adb shell input keyevent 66");
                }, child: Text("确定")),
                width: 60,
                height: 30,
                margin: EdgeInsets.all(10),
              ),
              Container(
                child: ElevatedButton(onPressed: (){
                  shell.run("adb shell input keyevent 22");
                }, child: Text("右")),
                width: 60,
                height: 30,
                margin: EdgeInsets.all(10),
              ),],
          ),
          Container(
            child: ElevatedButton(onPressed: (){
              shell.run("adb shell input keyevent 20");
            }, child: Text("下")),
            width: 60,
            height: 30,
            margin: EdgeInsets.all(10),
          ),
          SizedBox(height: 100,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: ElevatedButton(onPressed: (){
                  shell.run("adb shell input keyevent 176");
                }, child: Text("设置")),
                width: 60,
                height: 30,
                margin: EdgeInsets.all(10),
              ),
              Container(
                child: ElevatedButton(onPressed: (){
                  shell.run("adb shell input keyevent 4");
                }, child: Text("返回")),
                width: 60,
                height: 30,
                margin: EdgeInsets.all(10),
              ),
              Container(
                child: ElevatedButton(onPressed: (){
                  shell.run("adb shell input keyevent 82");
                }, child: Text("菜单")),
                width: 60,
                height: 30,
                margin: EdgeInsets.all(10),
              ),],
          ),
        ],
      ),
    ) ;
  }
}
