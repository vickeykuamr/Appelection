import 'package:flutter/material.dart';

class VoteModel {
  VoteModel ({
    this.voteRound,
    this.leadRound,
    this.leadingParty,
    this.candidate,
    this.validVote,
    this.winParty,
  });

  List<Round>? voteRound;
  List<Round>? leadRound;
  List<LeadingParty>? leadingParty;
  List<Candidate>? candidate;
  List<ValidVote>? validVote;
  List<dynamic>? winParty;


  VoteModel.fromJson(Map<String, dynamic> json){
    voteRound = List.from(json['VoteRound']).map((e)=>Round.fromJson(e)).toList();
    leadRound = List.from(json['LeadRound']).map((e)=>Round.fromJson(e)).toList();
    leadingParty = List.from(json['LeadingParty']).map((e)=>LeadingParty.fromJson(e)).toList();
    candidate = List.from(json['Candidate']).map((e)=>Candidate.fromJson(e)).toList();
    validVote = List.from(json['ValidVote']).map((e)=>ValidVote.fromJson(e)).toList();
    winParty = List.castFrom<dynamic, dynamic>(json['WinParty']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['VoteRound'] = voteRound?.map((e)=>e.toJson()).toList();
    _data['LeadRound'] = leadRound?.map((e)=>e.toJson()).toList();
    _data['LeadingParty'] = leadingParty?.map((e)=>e.toJson()).toList();
    _data['Candidate'] = candidate?.map((e)=>e.toJson()).toList();
    _data['ValidVote'] = validVote?.map((e)=>e.toJson()).toList();
    _data['WinParty'] = winParty;
    return _data;
  }
}

class Candidate {
  Candidate({
    this.ccode,
    this.candicode,
    this.candiname,
    this.winner,
    this.abbr,
    this.votes,
    this.pcode,
   required this.cvotes
  });

  String? ccode;
  String? candicode;
  String? candiname;
  String? winner;
  String? abbr;
  double? votes;
  String? pcode;
  String cvotes = "0";
  Candidate.fromJson(Map<String, dynamic> json){
    ccode = json['ccode'];
    candicode = json['candicode'];
    candiname = json['candiname'];
    winner = json['winner'];
    abbr = json['abbr'];
    votes = json['votes'];
    pcode = json['pcode'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ccode'] = ccode;
    _data['candicode'] = candicode;
    _data['candiname'] = candiname;
    _data['winner'] = winner;
    _data['abbr'] = abbr;
    _data['votes'] = votes;
    _data['pcode'] = pcode;
    return _data;
  }
}

class Round {
  Round({
    this.rno,
  });

  String? rno;
  Round.fromJson(Map<String, dynamic> json){
    rno = json['RNO'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['RNO'] = rno;
    return _data;
  }
}

class LeadingParty {
  LeadingParty({
    this.pcode,
  });

  String? pcode;
  LeadingParty.fromJson(Map<String, dynamic> json){
    pcode = json['pcode'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['pcode'] = pcode;
    return _data;
  }
}

class ValidVote {
  ValidVote({
    this.validVotes,
  });

  double? validVotes;

  ValidVote.fromJson(Map<String, dynamic> json){
    validVotes = json['valid_votes'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['valid_votes'] = validVotes;
    return _data;
  }
}
