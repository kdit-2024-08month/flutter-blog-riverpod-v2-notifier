class User {
  int? id;
  String username;
  String? imgUrl;

  User.fromMap(Map<String, dynamic> map)
      : this.id = map["id"],
        this.username = map["username"],
        this.imgUrl = map["imgUrl"];
}

void main() {
  Map<String, dynamic> map = {
    "id": 1,
    "username": null,
  };

  User u = User.fromMap(map);
  print(u.id);
  print(u.username);
  print(u.imgUrl);
}
