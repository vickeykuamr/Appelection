import 'dart:async';
import 'dart:io';


import 'package:electionlead/model/constituency_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
String? userid = "";
String? userToken = "";
class Helper{
  static String? token ;
      /*-----------for authentication------------------*/
  static const String baseUrl = "http://5.189.135.70/election/api";
  /*-----------for main operation------------------*/
   /*static const String baseUrl1 = "http://electionapp.drivesu.in/NE2023/";*/
  static const String baseUrl1 = "http://52.66.18.185/elec2023/";

  setToken(String token) async{
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString("token", token);
  }
  setEmail(String email) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("email", email);
  }
   Future<String?> getEmail(String email) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userid = sharedPreferences.getString(email);
    return userid;
    print(userid);
  }
  Future<String?> getToken(String email) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userToken = sharedPreferences.getString(email);
    return userToken;
    print(userid);
  }
}

class DatabaseHelper{
   static Database? _database;

   Future<Database?> get database async {
     if(_database!= null){
       return _database;
     }
     _database = await initDatabase();
     return _database;
   }

   initDatabase() async{
     Directory documentDirectory = await getApplicationDocumentsDirectory();
     // for saving the directory using join
     String path = join(documentDirectory.path,"election.db");

     await deleteDatabase(path);

     var _database = openDatabase(path, version: 1, onCreate: _onCreate);
     return _database;
   }


  Future<void> _onCreate(Database db, int version) async{
   await db.execute("CREATE TABLE Constituencydata(ccode TEXT,"
       "cname TEXT,"
       "state TEXT)");
  }
//for inserting the data
  Future<ConstituencyModel> insert(ConstituencyModel constituencyModel)async{
    var dbClient = await database;
    await dbClient!.insert('Constituencydata', constituencyModel.toJson());
    return constituencyModel;
  }

  Future<List<ConstituencyModel>> fetch()async{
    var dbClient = await database;
    final List<Map<String,Object?>> querResult = await dbClient!.query('Constituencydata');
    return querResult.map((e) => ConstituencyModel.fromJson(e)).toList();
  }


}