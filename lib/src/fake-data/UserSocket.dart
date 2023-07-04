class UserSocket {
  int id;
  bool isParent;
  String email;

  UserSocket({this.id, this.isParent, this.email});

  factory UserSocket.fromJson(Map<String, dynamic> json) {
    return UserSocket(
        id: json["id"] as int,
        isParent: json["parent"] as bool,
        email: json["email"] as String);
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'parent': isParent, 'email': email.toString()};
}
