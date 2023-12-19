import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controller/dsetting.dart';

class FrpcManagerSX {
  final DSettingController ds_c = Get.find();

  Widget widget() {
    return ListView(
      children: [
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
        )
      ],
    );
  }
}
