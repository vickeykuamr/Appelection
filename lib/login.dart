import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:electionlead/leads.dart';
import 'package:electionlead/model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'data.dart';
import 'helper.dart';
import 'model/constituency_model.dart';



class Login extends StatefulWidget {
   Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  bool isObscure = true;
  Position? _position ;
  bool isLoading = false;
  late LocationPermission permission;



  String? file_path;

  var _key = GlobalKey<FormState>();



  InputDecoration buildInputDecoration(String s, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: const Color.fromRGBO(50, 62, 72, 1.0)),
      // hintText: hintText,
      contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      label: Text(s),
    );
  }
  _email() {
    return TextFormField(
      controller: _emailController,
      decoration: buildInputDecoration("Username", Icons.supervised_user_circle_outlined),
      validator: (val) => val == null ||
          val.isEmpty /* ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(val)*/
          ? 'Name can not be empty'
          : null,
    );
  }

  _pass() {
    return TextFormField(
      obscureText: isObscure,
      controller: _passController,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: Icon(Icons.lock, color: const Color.fromRGBO(50, 62, 72, 1.0)),
        // hintText: hintText,
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        suffixIcon: IconButton(
          icon: Icon(
            isObscure ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              isObscure = !isObscure;
            });
          },
        ),
      ),
      validator: (val) => val == null || val.length < 1
          ? 'Password can not be empty'
          : null,
    );
  }

  _button(){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(onPressed: ()async{

        if(_key.currentState!.validate()) {
          if (_emailController.text.trim() == "admin@gmail.com" &&
              _passController.text.trim() == "admin@123") {

            Helper().setEmail(_emailController.text.trim());
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (context) => Home()), (
                route) => false);
          }else {
          // _checkPermission();
            doLogin(_emailController.text, _passController.text);
          }
        /*  if (_emailController.text.trim() == "admin@gmail.com" &&
              _passController.text.trim() == "admin@123") {

            Helper().setEmail(_emailController.text.trim());
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (context) => Home()), (
                route) => false);
          }
          else {
            _alertDialog("Login Alert",
                "Invalid username or password");
            doLogin(_emailController.text, _passController.text, _position!);
          }*/
        }

      }, child: Text("Login", style: TextStyle(fontSize: 20),)),
    );
  }
  _alertDialog(String title, String content){
    return
      showDialog(context: context, builder: (context)=>AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("OK"))
        ],
      ));
  }

  _checkVaildLocation(Position position) async{

    String url = Helper.baseUrl + "/party/getlocation1";
    var body = {
      "latitude":position.latitude.toString() ,
      "longititude":position.longitude.toString()
    };
   print(body);
    var headers = {
      "Content-Type": "application/json",
      "Authorization":"Bearer ${Helper.token}"
    };
    print(url);
    try {
      var response = await http.post(
          Uri.parse(url), body: json.encode(body), headers: headers);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        if( result["location"] == "not valid location"){
          _alertDialog("Login Alert", "You are not at the authorized center");
        }
        else {
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => Home()), (
              route) => false);
        }
      }
      else {
        _alertDialog("Login Alert", "Location not found");
      }
    }
    catch (e) {
      print(e.toString());
    }
  }


  doLogin(String username, String password) async {

    String url = Helper.baseUrl + "/v1/auth/login";
    setState(() {
      isLoading = true;
    });
    var body = {
      "email":username,
      "password":password
    };
    var headers = {
      "Content-Type": "application/json"
    };
    print(url);
    try {
      var response = await http.post(
          Uri.parse(url), body: json.encode(body), headers: headers);
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {

        var result = json.decode(response.body);
        loginModel data = loginModel.fromJson(result);
        setState(() {
         Helper.token = data.token!;
         userToken = data.token!;
         isLoading = false;
        });
        Helper().setToken(data.token!);
        Helper().setEmail(data.email!);

       if(permission == LocationPermission.denied) {
         Navigator.pushAndRemoveUntil(
             context, MaterialPageRoute(builder: (context) => Home()), (
             route) => false);
       }else{
         _checkVaildLocation(_position!);

       }
      }
      else{
        setState(() {
          isLoading = false;
        });
        _alertDialog("Login Alert", "Enter correct username or password");
      }
    }
    catch (e) {
      print(e.toString());
    }
  }
  @override
  void initState() {

   // insertData();

    _checkPermission();
    super.initState();
  }
/*
  insertData(){
    DatabaseHelper databaseHelper = DatabaseHelper();
    var data =  Constituency.map<ConstituencyModel>((e) => ConstituencyModel.fromJson(e)).toList();
    // TODO: implement initState
    for(int i=0;i<Constituency.length;i++) {
      databaseHelper.insert(
          ConstituencyModel(
              ccode: data[i].ccode.toString(), cname: data[i].cname, state: data[i].state)
      ).then((value) {

      }).onError((error, stackTrace) {
        print('error while database entry is $error');
      */
/*  print('error while database entry stacktrace is $stackTrace');*//*

      });
    }
  }
*/



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 40),
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(height: 20,),
              Text("Karnataka Election 2023", style: TextStyle(
                  fontSize: 30, fontWeight: FontWeight.w500, ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20,),

              _email(),
              SizedBox(height: 20,),
              _pass(),
              SizedBox(height: 20,),
             isLoading==false? _button(): CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _checkPermission()async {
    var connectivityResult = await (Connectivity().checkConnectivity());


    permission = await Geolocator.checkPermission();



    print('permission $permission');

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      LocationPermission newPermission = await Geolocator.requestPermission();

      if (newPermission == LocationPermission.always ||
          newPermission == LocationPermission.whileInUse) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        setState(() {
          _position = position;
        });
        print("in this else part $position");
      }
    }
      else{

        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        print(position);
        if(mounted) {
          setState(() {
            _position = position;
          });
        }
      }

  }
}
