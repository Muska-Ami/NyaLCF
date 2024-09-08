/// 用户信息模型
/// [user] 用户名
/// [email] 邮箱
/// [token] 登录令牌
/// [avatar] 头像链接
/// [inbound] 下行限速
/// [outbound] 上行限速
/// [frpToken] Frp 令牌
/// [traffic] 剩余流量
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
  final num traffic;

  /// 从 JSON 导入数据
  UserInfoModel.fromJson(Map<String, dynamic> json)
      : user = json['username'],
        token = json['token'],
        email = json['email'],
        avatar = json['avatar'],
        inbound = json['inbound'],
        outbound = json['outbound'],
        frpToken = json['frp_token'],
        traffic = num.parse(json['traffic']);

  /// 转为 JSON 数据
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
