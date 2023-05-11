import 'dart:convert';

import 'package:electionlead/model/login_model.dart';
import 'package:electionlead/model/vote_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'helper.dart';
class VotingInfo extends StatefulWidget {
  String? ccode;
   VotingInfo({Key? key, this.ccode}) : super(key: key);

  @override
  State<VotingInfo> createState() => _VotingInfoState();
}

class _VotingInfoState extends State<VotingInfo> {
  VoteModel? voteData;
  bool isLoading = true;
  int total = 0;
  TextEditingController currentVotes = TextEditingController();
  TextEditingController roundno = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _getVoteData(widget.ccode!);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Voting information"),
        centerTitle: true,
      ),
      body: isLoading==false?SingleChildScrollView(
        child: Column(

          children: [
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Last Vote Round"),
                Text(voteData!.voteRound!.first.rno!)
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Round number"),
                Container(
                  width: MediaQuery.of(context).size.width *0.10,
                  child: TextField(
                    controller: roundno,
                    keyboardType: TextInputType.number,
                  ),
                )
              ],
            ),
            
            DataTable(
                columnSpacing: 25,
                columns: [
              DataColumn(label: Text("Candidate\nname")),
              DataColumn(label: Text("Party")),
              DataColumn(label: Text("Last\nVotes")),
              DataColumn(label: Text("Votes"))
            ], rows:  voteData!.candidate!.isNotEmpty? List.generate(voteData!.candidate!.length, (index) {
              return DataRow(cells: [
                DataCell(Text(voteData!.candidate![index].candiname??"")),
                DataCell(Text(voteData!.candidate![index].abbr??"")),
                DataCell(Text("${voteData!.candidate![index].votes}")),
                DataCell(TextField(
                  // controller: voteData!.candidate![index].cvotes,
                  keyboardType: TextInputType.number,)),
              ]);
            }):
            [DataRow(cells: List.generate(4, (index) => DataCell(Text("")))
            )
            ]),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Valid Votes"),
                Text(voteData!.validVote!.first.validVotes.toString())
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Total"),
                Text(total.toString())
              ],
            ),
            ElevatedButton(onPressed: (){
              int sum = 0;
              for(int i = 0;i<voteData!.candidate!.length; i++){
                sum += voteData!.candidate![i].cvotes! as int;
              }
             setState(() {
               total = sum;
             });
            }, child: Text("Validate Vote")),
            ElevatedButton(onPressed: (){}, child: Text("Submit Vote"))
            
          ],
        ),
      ):Center(child: CircularProgressIndicator())
    );
  }
  _getVoteData(String code) async {
    String url = Helper.baseUrl + "api/vote/vinfo?ccode=$code";
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        voteData = VoteModel.fromJson(data);
        print(voteData!.leadRound!.first.rno);
        setState(() {
        isLoading = false;
        });
        return voteData;
      }
    }
    catch(e){
      print(e.toString());
    }
  }
}
