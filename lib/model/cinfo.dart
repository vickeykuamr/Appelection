class cinfo {
  List<Lead> lead = [];
  List<Candidatel> candidate = [];

  cinfo({required this.lead, required this.candidate});

  cinfo.fromJson(Map<String, dynamic> json) {
    if (json['Lead'] != null) {
      lead = <Lead>[];
      json['Lead'].forEach((v) {
        lead!.add(new Lead.fromJson(v));
      });
    }
    if (json['Candidate'] != null) {
      candidate = <Candidatel>[];
      json['Candidate'].forEach((v) {
        candidate!.add(new Candidatel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lead != null) {
      data['Lead'] = this.lead!.map((v) => v.toJson()).toList();
    }
    if (this.candidate != null) {
      data['Candidate'] = this.candidate!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Lead {
  String? ccode;
  String? rno;
  String? abbr;
  String? pcode;
  String? cANDICODE;
  String? pNAME;

  Lead(
      {this.ccode,
        this.rno,
        this.abbr,
        this.pcode,
        this.cANDICODE,
        this.pNAME});

  Lead.fromJson(Map<String, dynamic> json) {
    ccode = json['ccode'];
    rno = json['rno'];
    abbr = json['abbr'];
    pcode = json['pcode'];
    cANDICODE = json['CANDICODE'];
    pNAME = json['PNAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ccode'] = this.ccode;
    data['rno'] = this.rno;
    data['abbr'] = this.abbr;
    data['pcode'] = this.pcode;
    data['CANDICODE'] = this.cANDICODE;
    data['PNAME'] = this.pNAME;
    return data;
  }
}

class Candidatel {
  String? ccode;
  String? aBBR;
  String? pcode;
  String? column1;
  String? candicode;
  String? candiname;

  Candidatel(
      {this.ccode,
        this.aBBR,
        this.pcode,
        this.column1,
        this.candicode,
        this.candiname});

  Candidatel.fromJson(Map<String, dynamic> json) {
    ccode = json['ccode'];
    aBBR = json['ABBR'];
    pcode = json['pcode'];
    column1 = json['Column1'];
    candicode = json['candicode'];
    candiname = json['candiname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ccode'] = this.ccode;
    data['ABBR'] = this.aBBR;
    data['pcode'] = this.pcode;
    data['Column1'] = this.column1;
    data['candicode'] = this.candicode;
    data['candiname'] = this.candiname;
    return data;
  }
}
