import 'dart:convert';
import 'dart:io';

import 'package:electionlead/model/constituency_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'data.dart';
import 'helper.dart';
import 'login.dart';
import 'model/constcode_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'model/vinfo.dart';
import 'model/cinfo.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>  with SingleTickerProviderStateMixin{

  List<Lead> lead = [];
  List<Candidatel> candidate = [];
  cinfo? leaddata;
  List<ConstCodeModel> codeModel = [];
  TextEditingController constituencyCode = TextEditingController();
  TextEditingController currentRound = TextEditingController();
  List<String> partyList = [];
  String? candidateName;
  String? selectedParty;
  String? cname;
  String? state;
  bool validcode  = false;

  List<ConstituencyModel> constituencyList = [];
  String? candicode;
  String? pcode;
  vinfo? voteData;
  bool isLoading = true;
  bool isLeadLoading = false;
  bool IsvalidRound =  false;
  int LeadingIndex =  -1;
  int total = 0;
  String? leading_pcode;
  TextEditingController currentVotes = TextEditingController();
  TextEditingController roundno = TextEditingController();
  TextEditingController totalVotes = TextEditingController();

  late TabController _tabController;

  bool isEmpty = false;
  String callid = "";
  bool isValidLeadVotes =  true;
  late SharedPreferences sharedPreferences;
  late DatabaseHelper databaseHelper;
  var _key = GlobalKey<FormState>();

  getUniqueid() async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print("in this ${androidInfo.id}");
      setState(() {
        callid = androidInfo.id;
      });
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    }
  }


  @override
  void initState() {
    Helper().getEmail("email").then((value) {
     print("home $value");
     if(value == "admin@gmail.com"){
       setState(() {
         userid = value;
       });
     }
     else{
       _getCcode();
     }
    });

    getUniqueid();
    constituencyList =  Constituency.map<ConstituencyModel>((e) => ConstituencyModel.fromJson(e)).toList();
   /* databaseHelper = DatabaseHelper();
   databaseHelper.fetch().then((value) {
       constituencyList = value;

    print(constituencyList[1].state.toString());
   }).onError((error, stackTrace) {
     print("fetch error: $error");
     print("fetch stacktrace: $stackTrace");
   });*/
   _tabController = TabController(vsync: this, length: 2);
    super.initState();
  }
   @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
    _tabController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    var screen_width = MediaQuery.of(context).size.width;
    var screen_height = MediaQuery.of(context).size.height;

    return
      Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text("Election 2023"),
          centerTitle: true,
          actions: [
            IconButton(onPressed: (){
              showDialog(
                barrierDismissible: false,
                  context: context, builder: (context)=>AlertDialog(
                title: Text("Logout"),
                content: Text("Are you sure you want to logout?"),
                actions: [
                  TextButton(onPressed: ()async{
                    sharedPreferences = await SharedPreferences.getInstance();
                    sharedPreferences.clear();
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Login()), (route) => false);
                  }, child: Text("YES")),
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Text("NO"))
                ],
              )
              );

            }, icon: Icon(Icons.logout))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Form(
                key: _key,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: TextFormField(
                        maxLength: 5,
                        controller: constituencyCode,
                        keyboardType: TextInputType.number,
                        validator: (val){
                          if(val!.isEmpty){
                            return "Enter Constituency code";
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Enter constituency code",
                        ),

                        onFieldSubmitted: (val) {

                            partyList.clear();
                            selectedParty = null;
                            candidateName = null;
                            currentRound.clear();
                            roundno.clear();
                            cname = "NA";
                            state = "NA";
                            LeadingIndex = -1;
                            totalVotes.clear();
                            validcode = false;
                            IsvalidRound = false;
                            isLoading = true;
                            total = 0;
                            lead.clear();
                            leading_pcode = "";
                            if (_key.currentState!.validate()) {
                            //if (userid == "admin@gmail.com") {
                             // if ((userid != "admin@gmail.com")||(userid != "admin@gmail.com")) {
                                print('asdfghjk');
                              isLeadLoading = true;   //check
                              _getLeadData(constituencyCode.text);
                              _getVoteData(constituencyCode.text);
                                isLeadLoading = true;
                              for (int i = 0; i <
                                  constituencyList.length; i++) {
                                if (constituencyCode.text ==
                                    constituencyList[i].ccode) {
                                  setState(() {
                                    cname = constituencyList[i].cname;
                                    state = constituencyList[i].state;
                                  });
                                }
                              }
                           // }
                              //else{print('else part');}
                            //   else {
                            //   if(codeModel.first.stateId == 1) {
                            //     print(codeModel.first.stateId == 1);
                            //   /*  isLeadLoading = true;
                            //     _getLeadData(constituencyCode.text);
                            //     _getVoteData(constituencyCode.text);*/
                            //     for (int i = 0; i <
                            //         60; i++) {
                            //       if (constituencyCode.text ==
                            //           constituencyList[i].ccode) {
                            //         isLeadLoading = true;
                            //         _getLeadData(constituencyCode.text);
                            //         _getVoteData(constituencyCode.text);
                            //         setState(() {
                            //           validcode = true;
                            //           cname = constituencyList[i].cname;
                            //           state = constituencyList[i].state;
                            //         });
                            //       }
                            //     }
                            //   }else if (codeModel.first.stateId == 2){
                            //   /*  isLeadLoading = true;
                            //     _getLeadData(constituencyCode.text);
                            //     _getVoteData(constituencyCode.text);*/
                            //     for (int i = 60; i <
                            //         120; i++) {
                            //       if (constituencyCode.text ==
                            //           constituencyList[i].ccode) {
                            //         isLeadLoading = true;
                            //         _getLeadData(constituencyCode.text);
                            //         _getVoteData(constituencyCode.text);
                            //         setState(() {
                            //           validcode = true;
                            //           cname = constituencyList[i].cname;
                            //           state = constituencyList[i].state;
                            //         });
                            //       }
                            //     }
                            //   }
                            //   else if(codeModel.first.stateId == 3){
                            //    /* isLeadLoading = true;
                            //     _getLeadData(constituencyCode.text);
                            //     _getVoteData(constituencyCode.text);*/
                            //     for (int i = 120; i <
                            //         180; i++) {
                            //       if (constituencyCode.text ==
                            //           constituencyList[i].ccode) {
                            //         isLeadLoading = true;
                            //         _getLeadData(constituencyCode.text);
                            //         _getVoteData(constituencyCode.text);
                            //         setState(() {
                            //           validcode = true;
                            //           cname = constituencyList[i].cname;
                            //           state = constituencyList[i].state;
                            //         });
                            //       }
                            //     }
                            //   }
                            //   print("validcode : $validcode");
                            //   if (validcode == false) {
                            //     _alertDialog("Invalid code", "Invalid code");
                            //   }
                            // }
                          }
                        }
                      ),
                    ),

                    ElevatedButton(onPressed: (){

                        partyList.clear();
                        selectedParty = null;
                        candidateName = null;
                        currentRound.clear();
                        cname = "NA";
                        state = "NA";
                        roundno.clear();
                        total = 0;
                        leading_pcode = "";
                        LeadingIndex = -1;
                        validcode = false;
                        IsvalidRound = false;
                        isLoading = true;
                        totalVotes.clear();
                        lead.clear();
                        if(_key.currentState!.validate()) {

                        if (userid != "admin@gmail.com") {
                          isLeadLoading = true;
                          _getLeadData(constituencyCode.text);
                          _getVoteData(constituencyCode.text);
                          for (int i = 0; i <
                              constituencyList.length; i++) {
                            if (constituencyCode.text ==
                                constituencyList[i].ccode) {
                              setState(() {
                                cname = constituencyList[i].cname;
                                state = constituencyList[i].state;
                              });
                            }
                          }
                        } else {

                          if(codeModel.first.stateId == 1) {
                            print(codeModel.first.stateId == 1);

                            for (int i = 0; i <
                                60; i++) {
                              if (constituencyCode.text ==
                                  constituencyList[i].ccode) {
                                isLeadLoading = true;
                                _getLeadData(constituencyCode.text);
                                _getVoteData(constituencyCode.text);
                                setState(() {
                                  validcode = true;
                                  cname = constituencyList[i].cname;
                                  state = constituencyList[i].state;
                                });
                              }
                            }
                          }else if (codeModel.first.stateId == 2){

                            for (int i = 60; i <
                                120; i++) {
                              if (constituencyCode.text ==
                                  constituencyList[i].ccode) {
                                isLeadLoading = true;
                                _getLeadData(constituencyCode.text);
                                _getVoteData(constituencyCode.text);
                                setState(() {

                                  validcode = true;
                                  cname = constituencyList[i].cname;
                                  state = constituencyList[i].state;
                                });
                              }
                            }
                          }
                          else if(codeModel.first.stateId == 3){

                            for (int i = 120; i <
                                180; i++) {
                              if (constituencyCode.text ==
                                  constituencyList[i].ccode) {
                                isLeadLoading = true;
                                _getLeadData(constituencyCode.text);
                                _getVoteData(constituencyCode.text);
                                setState(() {
                                  validcode = true;
                                  cname = constituencyList[i].cname;
                                  state = constituencyList[i].state;
                                });
                              }
                            }
                          }
                          if (validcode == false) {
                            _alertDialog("Invalid code", "Invalid code");
                          }
                        }
                      }
                    }, child: Text("Enter")),


                    ElevatedButton(onPressed: (){
                      lead.clear();
                      candidate.clear();
                      constituencyCode.clear();
                      currentRound.clear();
                      cname = "";
                      state = "";
                      roundno.clear();
                      partyList.clear();
                      candidateName = null;
                      totalVotes.clear();
                      isLoading = true;
                      setState(() {

                      });
                    }, child: Text("Reset"))
                  ],
                ),
              ),
              SizedBox(height: 5,),
              TabBar(
                indicator: BoxDecoration(
                    border: Border.all(color: Colors.black),

                    borderRadius: BorderRadius.circular(
                    16.0,
                  ),

                  color: Colors.greenAccent
                ),
                controller: _tabController,
                  tabs: [
                    Container(
                        width:screen_width*50,
                        decoration:BoxDecoration(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        margin: EdgeInsets.only(top: 8),
                        padding: EdgeInsets.all(10.0),

                        child: Text(
                          "LEAD",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        )),


                    Container(
                        width:screen_width*50,
                        decoration:BoxDecoration(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        margin: EdgeInsets.only(top: 8),

                        padding: EdgeInsets.all(10.0),

                        child: Text(
                          "VOTES",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        )),
              ]),

          Expanded(
            child: TabBarView(
              controller: _tabController,
                children: [
            isLeadLoading == false?SizedBox(
              height: screen_height = MediaQuery.of(context).size.height * 0.80,
              child:
                  SingleChildScrollView(
                    child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                //  SizedBox(height: 20,),
                 // Text("LEAD INFORMATION", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
                 // SizedBox(height: 20,),

                  SizedBox(
                    height: 20,
                  ),
                  _detailsUI("Constituency Name", cname??"NA"),

                  _detailsUI("State", state??"NA"),

                  _detailsUI("Last Leading Party:", lead.isEmpty?"NA": "${lead.first.pNAME} (${lead.first.abbr}-${lead.first.pcode})" ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color:Colors.teal)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            Text("Last Lead Round",  style: TextStyle(fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                border: Border.all(color: Colors.black),
                              ),
                              child: Text(lead.isEmpty?"-1":lead.first.rno!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),),
                            ),
                            SizedBox(height: 10,)
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            Text("Current Lead Round", style: TextStyle(fontWeight: FontWeight.w500),),

                            Container(
                              width: MediaQuery.of(context).size.width * 0.30,
                              child: TextField(
                                maxLength: 2,
                                controller: currentRound,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "Enter Round No",
                                ),
                                onSubmitted: (value){
                                  if(int.parse(value) <= int.parse(lead.isEmpty?"-1":lead.first.rno!) ){
                                    _alertDialog("Lead Round", "Current lead round should be greater than last lead round");
                                  }
                                  else if(int.parse(value) >= 98){
                                    _alertDialog("Warning", "Please call the Calling Center for this round");
                                  }

                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.0),
                          width: screen_width,
                          color:Colors.black ,
                            child: Text("Leading party:", style:  TextStyle(color:Colors.white,fontWeight: FontWeight.w500, fontSize: 16),)),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: DropdownButton(
                            hint: Text("Select Leading Party Name"),
                            isExpanded: true,
                            value: selectedParty,
                            items: partyList.map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e))).toList(), onChanged: ( String? value){
                            setState(() {
                              selectedParty = value.toString();
                              int index = partyList.indexOf(selectedParty!);
                              candidateName = candidate[index].candiname;
                              pcode = candidate[index].pcode;
                              candicode = candidate[index].candicode;
                            });

                          },
                            underline: SizedBox(),),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.all(8),
                          width: screen_width,
                          color: Colors.black,
                            child: Text("Candidate Name:", style:  TextStyle(
                              color: Colors.white,
                                fontWeight: FontWeight.w500, fontSize: 16),)),
                        SizedBox(height: 10,),
                        Text(candidateName??"NA", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),)
                      ],
                    ),
                  ),

               //   _detailsUI("Candidate Name", candidateName??"NA"),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(onPressed: (){
                        var jsonBody = {
                          "CCODE":constituencyCode.text,
                          "RNO":currentRound.text,
                          "PCODE":pcode,
                          "CANDICODE":candicode,
                          "callid":callid
                        };
                        print(json.encode(jsonBody));
                        if(currentRound.text.isEmpty ){
                          _alertDialog("Round Alert", "Enter Current Lead Round");
                        }
                        else if(int.parse(currentRound.text) >= 98){
                          _alertDialog("Warning", "Please enter value less than or equal to 97");
                        }
                        else if(selectedParty == null){
                          _alertDialog("Leading Party", "Enter Leading Party");
                        }
                        else if(int.parse(currentRound.text) <= int.parse(lead.isEmpty?"-1":lead.first.rno!) ){
                          _alertDialog("Lead Round", "Current lead round should be greater than last lead round");
                        }
                        else{
                          _postLeadData(jsonBody);
                        }
                      }, child: Text("Submit")),

                    ],
                  ),
                ],
              ),
            ),
            ):Center(child: CircularProgressIndicator(),),

              isLoading==false?  SingleChildScrollView(
                child: Column(

                    children: [

                 //     SizedBox(height: 20,),
                 //     Text("VOTING INFORMATION", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
                      Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color:Colors.teal)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,

                              children: [


                                Text("Last Vote Round",  style: TextStyle(fontWeight: FontWeight.w500),),
                                SizedBox(height: 10,),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Text(lead.isEmpty?"-1":voteData!.voteRound!.first.rNO??"", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),),
                                ),
                                SizedBox(height: 10,)
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,

                              children: [
                                Text("Round Number", style: TextStyle(fontWeight: FontWeight.w500),),

                                Container(
                                  width: MediaQuery.of(context).size.width * 0.30,
                                  child: TextField(
                                    maxLength: 2,
                                    controller: roundno,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "Enter 2 digit number",
                                    ),
                                    onSubmitted: (value) {
                                         totalVotes.clear();
                                         total = 0;
                                         leading_pcode = "";
                                       for(int i =0;i<voteData!.candidate!.length;i++){
                                         voteData!.candidate![i].cvotes = "0";
                                       }

                                        if (int.parse(value) <= int.parse(
                                            lead.isEmpty?"-1":voteData!.voteRound!.first.rNO!)) {
                                          setState(() {
                                            IsvalidRound = false;
                                            LeadingIndex = -1;
                                          });

                                          _alertDialog("Round Number",
                                              "Round number should be more than last vote round");
                                        }
                                        else if (int.parse(value) >
                                            int.parse(lead.isEmpty?"-1":lead.first.rno!)) {
                                          setState(() {
                                            IsvalidRound = false;
                                            LeadingIndex = -1;
                                          });
                                          _alertDialog("Round Number",
                                              "Leads are not available for this round");
                                        }
                                        else {
                                           if(int.parse(value)<10) {

                                             _getVoteLead(
                                              constituencyCode.text, value.padLeft(2,"0"));
                                           }
                                           else{
                                             _getVoteLead(constituencyCode.text, value);
                                        }


                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(height: 20,),
                      // _detailsUI("Last Vote Round", voteData!.voteRound!.first.rno!),
                     /* SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.50,
                            child: TextField(
                              maxLength: 2,
                              controller: roundno,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Enter Round Number",
                              ),

                            ),
                          ),
                          ElevatedButton(onPressed: (){

                            if(int.parse(roundno.text) <= int.parse(voteData!.voteRound!.first.rno!)){
                              setState(() {
                                IsvalidRound = false;
                              });

                              _alertDialog("Round Number", "Round number should be more than last vote round");
                            }
                            else if(int.parse(roundno.text) > int.parse(lead.first.rno!)){
                              setState(() {
                                IsvalidRound = false;
                              });
                              _alertDialog("Round Number", "Leads are not available for this round");
                            }
                            else {
                              _getVoteLead(constituencyCode.text, roundno.text);
                            }
                          }, child: Text("Enter"))
                        ],
                      ),*/

                      DataTable(
                          columnSpacing: 10,
                          columns: [
                            DataColumn(label: Text("Candidate\nname")),
                            DataColumn(label: Text("Party")),
                            DataColumn(label: Text("Pcode")),
                            DataColumn(label: Text("Last\nVotes")),
                            DataColumn(label: Text("Votes"))
                          ], rows:  voteData!.candidate!.isNotEmpty? List.generate(voteData!.candidate!.length, (index) {
                            if(voteData!.candidate![index].pcode == leading_pcode){

                              setState(() {
                                LeadingIndex = index;
                              });
                            }
                        return DataRow(
                          color: index == LeadingIndex?MaterialStateProperty.all(Colors.red):MaterialStateProperty.all(Colors.white),
                            cells: [
                          DataCell(Container(width:120,child: Text(voteData!.candidate![index].candiname??""))),
                          DataCell(Text(voteData!.candidate![index].abbr??"")),
                          DataCell(Text(voteData!.candidate![index].pcode??"")),
                          DataCell(Text("${voteData!.candidate![index].votes!.toInt()}")),
                          DataCell(
                              TextFormField(
                            enabled: IsvalidRound,
                            initialValue:voteData!.candidate![index].cvotes.toString() ,
                           onChanged: (val){
                             voteData!.candidate![index].cvotes = val.toString();
                           },
                            keyboardType: TextInputType.number,
                              onFieldSubmitted: (val){
                                if (voteData!.candidate![index].cvotes!.isNotEmpty) {

                                  if (double.parse(
                                      voteData!.candidate![index].cvotes) <
                                      voteData!.candidate![index].votes!) {
                                    _alertDialog("Votes Alert",
                                        "Votes entered should be more than the Last Votes");
                                  }


                                }
                                else{
                                  _alertDialog("Votes", "Votes cannot be empty");
                                }
                              },),
                          ),

                        ]);
                      }):
                      [DataRow(cells: List.generate(5, (index) => DataCell(Text("")))
                      )
                      ]),
                      const SizedBox(height: 20,),
                      _detailsUI("Last Valid Votes", voteData!.validVote!.first.validVotes!.toInt().toString()),
                      SizedBox(height: 20,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Total"),
                          Text(total.toString(), style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.w500),),
                          ElevatedButton(onPressed: (){
                            int sum = 0;
                            isEmpty = false;
                            isValidLeadVotes = true;

                            for(int i = 0;i<voteData!.candidate!.length; i++) {
                            if(i != LeadingIndex) {
                              if (double.parse(
                                  voteData!.candidate![LeadingIndex].cvotes) <=double.parse(
                                  voteData!.candidate![i].cvotes)) {
                                // print(isValidLeadVotes);
                                isValidLeadVotes = false;
                                setState(() {

                                });
                              }
                            }

                                if (voteData!.candidate![i].cvotes
                                  .isNotEmpty) {
                                int votes = int.parse(
                                    voteData!.candidate![i].cvotes);
                                print(votes);
                                sum = sum + votes;

                                if (double.parse(
                                    voteData!.candidate![i].cvotes) <
                                    voteData!.candidate![i].votes!) {

                                  _alertDialog("Votes Alert",
                                      "Votes entered should be more than the Last Votes");
                                }

                              }
                              else{
                                setState(() {
                                  isEmpty = true;
                                });
                              }
                            }
                            if(isEmpty == true){
                              _alertDialog("Vote", "Votes cannot be empty");
                            }
                            if(isValidLeadVotes == false){
                              _alertDialog("Leading Votes Alert",
                                  "Leading Votes should more than others");
                            }


                            setState(() {
                              total = sum;
                            });
                            // to calculate the total votes entered by the user
                          }, child: Text("Calculate Total")),

                        ],

                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Enter Total Votes"),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.20,
                            child:  TextField(
                              controller: totalVotes,
                              keyboardType: TextInputType.number,
                            ),
                          )
                        ],
                      ),


                      ElevatedButton(onPressed: (){
                        for(int i = 0;i<voteData!.candidate!.length; i++) {
                           if(i != LeadingIndex) {
                             if (double.parse(
                                 voteData!.candidate![LeadingIndex].cvotes
                                     ) <= double.parse(
                                 voteData!.candidate![i].cvotes)) {
                               print(isValidLeadVotes);

                               isValidLeadVotes = false;
                               setState(() {

                               });
                             }
                           }
                          if (voteData!.candidate![i].cvotes
                              .isNotEmpty) {
                            /*int votes = int.parse(
                                voteData!.candidate![i].cvotes!.text);*/


                            if (double.parse(
                                voteData!.candidate![i].cvotes) <
                                voteData!.candidate![i].votes!) {

                              _alertDialog("Votes Alert",
                                  "Votes entered should be more than the Last Votes");
                            }

                          }
                          else{
                            setState(() {
                              isEmpty = true;
                            });
                          }
                        }
                        if(isEmpty == true){
                          _alertDialog("Vote", "Votes cannot be empty");
                        }
                       else if(isValidLeadVotes == false){
                          _alertDialog("Leading Votes Alert",
                              "Leading Votes should more than others");
                        }
                       else if (int.parse(roundno.text) <= int.parse(
                            lead.isEmpty?"-1":voteData!.voteRound!.first.rNO!)) {
                          setState(() {
                            IsvalidRound = false;
                            LeadingIndex = -1;
                          });

                          _alertDialog("Round Number",
                              "Round number should be more than last vote round");
                        }
                        else if (int.parse(roundno.text) >
                            int.parse(lead.isEmpty?"-1":lead.first.rno!)) {
                          setState(() {
                            IsvalidRound = false;
                            LeadingIndex = -1;
                          });
                          _alertDialog("Round Number",
                              "Leads are not available for this round");
                        }

                       else if(total.toString() != totalVotes.text  ){
                          _alertDialog("Total Votes", "Enter valid total votes");
                        }
                        else if(double.parse(totalVotes.text) < voteData!.validVote!.first.validVotes!)
                        {
                          _alertDialog("Total Votes", "Current Valid votes should be greater than the previous valid votes");
                        }
                        else if(roundno.text.isEmpty){
                          _alertDialog("Round Number", "Enter Round number");
                        }

                        else{
                          int VALID_VOTES_EXNOTA = int.parse(totalVotes.text) - int.parse(voteData!.candidate!.last.cvotes);
                          var jsonBody  = {
                            "CCODE": constituencyCode.text,
                            "VALID_VOTES": totalVotes.text,
                            "VALID_VOTES_EXNOTA":VALID_VOTES_EXNOTA ,
                            "RNO": roundno.text,
                            "WINNER": "0",
                            "Candidate":
                                List.generate(voteData!.candidate!.length, (index) {
                                 return {
                                   "PCODE": voteData!.candidate![index].pcode,
                                  "CANDICODE": voteData!.candidate![index].candicode,
                                  "VOTES": voteData!.candidate![index].cvotes
                                  };
                                })
                            /* [
                              {
                                "PCODE": voteData!.candidate!,
                                "CANDICODE": "1",
                                "VOTES": "120"
                              },
                              {
                                "PCODE": "007",
                                "CANDICODE": "2",
                                "VOTES": "10"
                              },
                              {
                                "PCODE": "028",
                                "CANDICODE": "3",
                                "VOTES": "20"
                              },
                              {
                                "PCODE": "701",
                                "CANDICODE": "4",
                                "VOTES": "30"
                              },
                              {
                                "PCODE": "999",
                                "CANDICODE": "5",
                                "VOTES": "40"
                              }
                            ]*/
                          };
                          print(json.encode(jsonBody));
                          _postVoteData(jsonBody);
                        }

                      }, child: Text("Submit Vote"))




                    ],
                  ),
              ): Container()
              ]),
          )

            ],
          ),
        ),
      );
  }
  _postVoteData(jsonBody)async{
    String url = "${Helper.baseUrl1}api/vote/update";
    var headers = {
      "Content-Type": "application/json"
    };
    try {
      var response = await http.post(Uri.parse(url), body: json.encode(jsonBody), headers: headers);
      print(response.body);
      if (response.statusCode == 200) {
        var msg = json.decode(response.body);
        _alertDialog("Vote Submission", msg);
        setState((){
          LeadingIndex = -1;
          totalVotes.clear();
          roundno.clear();
          IsvalidRound = false;
          total = 0;
          leading_pcode = "";
        });

        _getVoteData(constituencyCode.text);
      }
    }
    catch(e){
      print(e.toString());
    }
  }


  _postLeadData(jsonBody)async{
    String url = "${Helper.baseUrl1}api/lead/LeadEntry";
    var headers = {
      "Content-Type": "application/json"
    };
    try {
      var response = await http.post(Uri.parse(url), body: json.encode(jsonBody), headers: headers);
      print(response.body);
      if (response.statusCode == 200) {
        var msg = response.body.toString();
        _alertDialog("Lead Submission", msg);
        partyList.clear();
        selectedParty = null;
        candidateName = null;
        currentRound.clear();
        _getLeadData(constituencyCode.text);
      }
      else{
        _alertDialog("Lead Not Update", "Something went wrong");
      }
    }
    catch(e){
      print(e.toString());
    }
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


  _getLeadData(String code) async {
    String url = "${Helper.baseUrl1}api/lead/cinfo?ccode=$code";
    try {
      var response = await http.get(Uri.parse(url));
      print(url);
      print("Lead data ${response.statusCode}");
      print("Lead data ${response.body}");
      if (response.statusCode == 200) {

        var data = json.decode(response.body);
        leaddata = cinfo.fromJson(data);
        // if(leaddata!.candidate.isEmpty && leaddata!.lead.isEmpty){
        //   _alertDialog("Constituency", "Constituency code is invalid");
        // }
        for (int i = 0; i < leaddata!.candidate.length; i++) {
          partyList.add("${leaddata!.candidate[i].column1}(${leaddata!.candidate[i].aBBR}) - ${leaddata!.candidate[i].pcode}" );
        }
        lead = leaddata!.lead;
        candidate = leaddata!.candidate;
        setState(() {
          isLeadLoading = false;

        });
        return leaddata;
      }
      else{
        setState(() {
          isLeadLoading = false;
        });
        _alertDialog("Something went Wrong", "Something went wrong");
      }

    }
    catch(e){
      print(e.toString());
    }
  }

  _getVoteData(String code) async {

    String url = "${Helper.baseUrl1}api/vote/vinfo?ccode=$code";
    print(url);
    try {
      var response = await http.get(Uri.parse(url));
      print(response.body);
      if (response.statusCode == 200) {
        print("URL"+url);
        var data = json.decode(response.body);
        voteData = vinfo.fromJson(data);

        setState(() {
          LeadingIndex = -1;
          isLoading = false;
        });
        return voteData;
      }
      else{
        setState(() {
          isLoading = true;
        });
      }
   }
    catch(e){
      print(e.toString());
      print("catch");
     }
  }

  _getVoteLead(String code, String rno) async {

    String url = "${Helper.baseUrl1}api/vote/vlead?ccode=$code&rno=$rno";
    print(url);
    try {
      var response = await http.get(Uri.parse(url));
      print(response.body);
      if (response.statusCode == 200) {

       if(response.body.toString() == "null"){
         _alertDialog("Round Alert", "Leads not available fo this round");
         setState(() {
           IsvalidRound = false;
           LeadingIndex = -1;
         });
       }
       else{
          setState(() {
            LeadingIndex = -1;
            IsvalidRound = true;
            leading_pcode =json.decode(response.body);
          });
          print("data $leading_pcode");

       }
      }
    }
    catch(e){
      print(e.toString());
    }
  }

  _getCcode() async {
    String url = "${Helper.baseUrl}/party/consiscode";
    print(url);

    try {
      var headers = {
        "Content-Type": "application/json",
        "Authorization":"Bearer ${Helper.token??userToken}"
      };
      var response = await http.get(Uri.parse(url),headers: headers);

      print("ccode data ${response.body}");
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        codeModel = data.map<ConstCodeModel>((v)=>ConstCodeModel.fromJson(v)).toList();
        setState(() {

        });
        return codeModel;
      }
      else if(response.statusCode == 500){
        sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.clear();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Login()), (route) => false);
      }
      else{
        setState(() {
        });
      }

    }
    catch(e){
      print(e.toString());
    }
  }

  _detailsUI(String name, String data) {
    return Container(
      margin: const EdgeInsets.all(7),
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade300,
              ))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 150,
            alignment: Alignment.topLeft,
            child: Text(
              name,
              style: TextStyle(
                color: Color.fromARGB(255, 32, 60, 83),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.topRight,
              child: Text(
                data,
                style: TextStyle(
                  color: Color.fromARGB(255, 32, 60, 83),
                  fontWeight: FontWeight.w500,
                  fontSize: 15
                ),
                textAlign: TextAlign.right,
              ),
            ),
          )
        ],
      ),
    );
  }

}
