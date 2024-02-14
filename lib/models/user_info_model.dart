class UserInfoModel {
  UserInfoModel({
    required this.user,
    required this.email,
    required this.token,
    required this.avatar,
    required this.inbound,
    required this.outbound,
    required this.frpToken,
    required this.traffic,
  });

  final String user;
  final String email;
  final String token;
  final String avatar;
  final int inbound;
  final int outbound;
  final String frpToken;
  final int traffic;

  UserInfoModel.fromJson(Map<String, dynamic> json)
      : user = json['username'],
        token = json['token'],
        email = json['email'],
        avatar = json['avatar'],
        inbound = json['inbound'],
        outbound = json['outbound'],
        frpToken = json['frp_token'],
        traffic = json['traffic'];

  Map<String, dynamic> toJson() => {
        'username': user,
        'token': token,
        'email': email,
        'avatar': avatar,
        'inbound': inbound,
        'outbound': outbound,
        'frp_token': frpToken,
        'traffic': traffic
      };
}
