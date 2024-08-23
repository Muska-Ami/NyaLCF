/// 用户信息模型
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

  /// 用户名
  final String user;
  /// 邮箱
  final String email;
  /// 登录令牌
  final String token;
  /// 头像链接
  final String avatar;
  /// 下行限速
  final int inbound;
  /// 上行限速
  final int outbound;
  /// Frp 令牌
  final String frpToken;
  /// 剩余流量
  final num traffic;

  UserInfoModel.fromJson(Map<String, dynamic> json)
      : user = json['username'],
        token = json['token'],
        email = json['email'],
        avatar = json['avatar'],
        inbound = json['inbound'],
        outbound = json['outbound'],
        frpToken = json['frp_token'],
        traffic = num.parse(json['traffic']);

  Map<String, dynamic> toJson() => {
        'username': user,
        'token': token,
        'email': email,
        'avatar': avatar,
        'inbound': inbound,
        'outbound': outbound,
        'frp_token': frpToken,
        'traffic': traffic.toString()
      };
}
