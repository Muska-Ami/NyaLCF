import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controller/dsetting.dart';

class LauncherSX {
  final DSettingController ds_c = Get.find();

  Widget widget() {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: ListView(
        children: <Widget>[
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('软件信息'),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SelectableText('通用软件名称：Nya LoCyanFrp! 乐青映射启动器'),
                        SelectableText('内部软件名称：${ds_c.app_name}'),
                        SelectableText('内壁软件包名：${ds_c.app_package_name}'),
                        SelectableText('软件版本：${ds_c.app_version}'),
                        SelectableText('著作权信息：登记中'),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(
                      left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
                  child: Text(
                    'Powered by Flutter framework.',
                    style: TextStyle(
                      color: Color.fromRGBO(57, 186, 255, 1.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
