class Session {
  final num id;
  final String username;

  // TODO

  /// 从 JSON 导入数据
  Session.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        username = json["username"];

  /// 转为 JSON 数据
  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "username": username,
      };
}
