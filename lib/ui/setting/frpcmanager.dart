import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controller/dsetting.dart';

class FrpcManagerSX {
  final DSettingController ds_c = Get.find();

  Widget widget() {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: ListView(
        children: <Widget>[
          Obx(() => ds_c.frpc_download_tip.value),

          /*
        Card(
          child: Row(
            children: [
              Expanded(
                child: ListTile(
                  leading: Icon(Icons.cabin),
                  title: Text('Frpc版本'),
                ),
              ),
              Container(
                width: 80,
                margin: EdgeInsets.only(right: 25.0),
                child: Obx(
                  () => DropdownButton(
                    value: ds_c.frpc_version_value.value,
                    items: ds_c.frpc_version_widgets,
                    onChanged: (v) {
                      ds_c.frpc_version_value.value = v;
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        Card(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: Icon(Icons.cabin),
                      title: Text('GitHub下载源代理设置'),
                    ),
                  ),
                  Container(
                    width: 80,
                    margin: EdgeInsets.only(right: 25.0),
                    child: Obx(
                      () => DropdownButton(
                        value: ds_c.github_proxy_url_value.value,
                        items: ds_c.github_proxy_widgets,
                        onChanged: (v) {
                          ds_c.github_proxy_url_value.value = v;
                        },
                      ),
                    ),
                  )
                ],
              ),
              Obx(() => Text(
                    '当前代理：${ds_c.github_proxy_url}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  )),
              ElevatedButton(onPressed: null, child: Text('保存'))
            ],
          ),
        ),*/
        ],
      ),
    );
  }
}
