class ConstCodeModel {
  int? id;
  String? center;
  int? stateId;
  String? consistencyCode;
  String? user;

  ConstCodeModel(
      {this.id, this.center, this.stateId, this.consistencyCode, this.user});

  ConstCodeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    center = json['center'];
    stateId = json['stateId'];
    consistencyCode = json['consistencyCode'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['center'] = this.center;
    data['stateId'] = this.stateId;
    data['consistencyCode'] = this.consistencyCode;
    data['user'] = this.user;
    return data;
  }
}
