class UserInfo {
  UserInfo(
      {required this.user,
      required this.email,
      required this.token,
      required this.avatar});

  final user;
  final email;
  final token;
  final avatar;

  String get Token {
    return token;
  }

  String get Email {
    return email;
  }

  String get UserName {
    return user;
  }

  String get Avatar {
    return avatar;
  }
}
