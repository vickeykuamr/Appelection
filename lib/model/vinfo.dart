class vinfo {
  List<VoteRound>? voteRound;
  List<LeadRound>? leadRound;
  List<LeadingParty>? leadingParty;
  List<Candidate>? candidate;
  List<ValidVote>? validVote;
  List<WinParty>? winParty;

  vinfo(
      {this.voteRound,
        this.leadRound,
        this.leadingParty,
        this.candidate,
        this.validVote,
        this.winParty});

  vinfo.fromJson(Map<String, dynamic> json) {
    if (json['VoteRound'] != null) {
      voteRound = <VoteRound>[];
      json['VoteRound'].forEach((v) {
        voteRound!.add(new VoteRound.fromJson(v));
      });
    }
    if (json['LeadRound'] != null) {
      leadRound = <LeadRound>[];
      json['LeadRound'].forEach((v) {
        leadRound!.add(new LeadRound.fromJson(v));
      });
    }
    if (json['LeadingParty'] != null) {
      leadingParty = <LeadingParty>[];
      json['LeadingParty'].forEach((v) {
        leadingParty!.add(new LeadingParty.fromJson(v));
      });
    }
    if (json['Candidate'] != null) {
      candidate = <Candidate>[];
      json['Candidate'].forEach((v) {
        candidate!.add(new Candidate.fromJson(v));
      });
    }
    if (json['ValidVote'] != null) {
      validVote = <ValidVote>[];
      json['ValidVote'].forEach((v) {
        validVote!.add(new ValidVote.fromJson(v));
      });
    }
    if (json['WinParty'] != null) {
      winParty = <WinParty>[];
      json['WinParty'].forEach((v) {
        winParty!.add(new WinParty.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.voteRound != null) {
      data['VoteRound'] = this.voteRound!.map((v) => v.toJson()).toList();
    }
    if (this.leadRound != null) {
      data['LeadRound'] = this.leadRound!.map((v) => v.toJson()).toList();
    }
    if (this.leadingParty != null) {
      data['LeadingParty'] = this.leadingParty!.map((v) => v.toJson()).toList();
    }
    if (this.candidate != null) {
      data['Candidate'] = this.candidate!.map((v) => v.toJson()).toList();
    }
    if (this.validVote != null) {
      data['ValidVote'] = this.validVote!.map((v) => v.toJson()).toList();
    }
    if (this.winParty != null) {
      data['WinParty'] = this.winParty!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VoteRound {
  String? rNO;

  VoteRound({this.rNO});

  VoteRound.fromJson(Map<String, dynamic> json) {
    rNO = json['RNO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RNO'] = this.rNO;
    return data;
  }
}

class WinParty{
  String? pcode;

  WinParty({this.pcode});

  WinParty.fromJson(Map<String, dynamic> json) {
    pcode = json['RNO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RNO'] = this.pcode;
    return data;
  }

}

class LeadRound {
  String? rNO;

  LeadRound({this.rNO});

  LeadRound.fromJson(Map<String, dynamic> json) {
    rNO = json['RNO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RNO'] = this.rNO;
    return data;
  }
}

class LeadingParty {
  String? pcode;

  LeadingParty({this.pcode});

  LeadingParty.fromJson(Map<String, dynamic> json) {
    pcode = json['pcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pcode'] = this.pcode;
    return data;
  }
}

class Candidate {
  String? ccode;
  String? candicode;
  String? candiname;
  String? winner;
  String? abbr;
  double? votes;
  String? pcode;
  String cvotes = "0";

  Candidate(
      {this.ccode,
        this.candicode,
        this.candiname,
        this.winner,
        this.abbr,
        this.votes,
        this.pcode,
     required this.cvotes});

  Candidate.fromJson(Map<String, dynamic> json) {
    ccode = json['ccode'];
    candicode = json['candicode'];
    candiname = json['candiname'];
    winner = json['winner'];
    abbr = json['abbr'];
    votes = json['votes'];
    pcode = json['pcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ccode'] = this.ccode;
    data['candicode'] = this.candicode;
    data['candiname'] = this.candiname;
    data['winner'] = this.winner;
    data['abbr'] = this.abbr;
    data['votes'] = this.votes;
    data['pcode'] = this.pcode;
    return data;
  }
}

class ValidVote {
  double? validVotes;

  ValidVote({this.validVotes});

  ValidVote.fromJson(Map<String, dynamic> json) {
    validVotes = json['valid_votes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['valid_votes'] = this.validVotes;
    return data;
  }
}
