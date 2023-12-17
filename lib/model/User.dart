class User {
  User(
      {required this.user,
      required this.email,
      required this.token,
      required this.avatar,
      required this.inbound,
      required this.outbound,
      required this.frp_token,
      required this.traffic});

  final String user;
  final String email;
  final String token;
  final String avatar;
  final int inbound;
  final int outbound;
  final String frp_token;
  final int traffic;

  User.fromJson(Map<String, dynamic> json)
      : user = json['username'],
        token = json['token'],
        email = json['email'],
        avatar = json['avatar'],
        inbound = json['inbound'],
        outbound = json['outbound'],
        frp_token = json['frp_token'],
        traffic = json['traffic'];

  Map<String, dynamic> toJson() => {
        'username': user,
        'token': token,
        'email': email,
        'avatar': avatar,
        'inbound': inbound,
        'outbound': outbound,
        'frp_token': frp_token,
        'traffic': traffic
      };
}
