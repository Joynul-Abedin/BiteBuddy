class User {
  String? sId;
  String? name;
  String? email;
  String? role;
  bool? hasStore;

  User({this.sId, this.name, this.email, this.role, this.hasStore});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    hasStore = json['hasStore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['role'] = role;
    data['hasStore'] = hasStore;
    return data;
  }
}
