class User {
  int? id;
  String? username;
  String? imgUrl;

  User.fromMap(Map<String, dynamic> map)
      : this.id = map["id"],
        this.username = map["username"],
        this.imgUrl = map["imgUrl"];
}
