
import 'package:electionlead/helper.dart';
import 'package:electionlead/leads.dart';
import 'package:electionlead/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MyApp());
}


class MyApp extends StatefulWidget {
   MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  var token ;

  @override
  void initState() {
    // TODO: implement initState
    Helper().getToken("token").then((value) {
     print("user token: $userToken");
      setState(() {
        token = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("user token in build: $token");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo
      ),
      home: token == null?Login(): Home(),
    );
  }
}
