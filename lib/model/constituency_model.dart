class ConstituencyModel {
  String? ccode;
  String? cname;
  String? state;

  ConstituencyModel({this.ccode, this.cname, this.state});

  ConstituencyModel.fromJson(Map<String, dynamic> json) {
    ccode = json['ccode'];
    cname = json['cname'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ccode'] = this.ccode;
    data['cname'] = this.cname;
    data['state'] = this.state;
    return data;
  }
}
