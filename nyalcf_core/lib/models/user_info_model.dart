/// 用户信息模型
/// [username] 用户名
/// [id] 用户 ID
/// [email] 邮箱
/// [avatar] 头像链接
/// [inbound] 下行限速
/// [outbound] 上行限速
/// [traffic] 剩余流量
class UserInfoModel {
  UserInfoModel({
    required this.username,
    required this.id,
    required this.email,
    required this.avatar,
    required this.inbound,
    required this.outbound,
    required this.traffic,
  });

  final String username;
  final int id;
  final String email;
  final String avatar;
  final int inbound;
  final int outbound;
  final num traffic;

  /// 从 JSON 导入数据
  UserInfoModel.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        id = json['id'],
        email = json['email'],
        avatar = json['avatar'],
        inbound = json['inbound'],
        outbound = json['outbound'],
        traffic = num.parse(json['traffic'].toString());

  /// 转为 JSON 数据
  Map<String, dynamic> toJson() => {
        'username': username,
        'id': id,
        'email': email,
        'avatar': avatar,
        'inbound': inbound,
        'outbound': outbound,
        'traffic': traffic
      };
}
