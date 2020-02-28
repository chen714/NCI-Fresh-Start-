class User {
  final String uid;
  final String email;
  User({this.uid, this.email});
}

class UserData {
  final String uid;
  final String email;
  final String name;
  final bool isFaculty;
  final String courseCode;

  UserData({this.uid, this.email, this.name, this.courseCode, this.isFaculty});
}
