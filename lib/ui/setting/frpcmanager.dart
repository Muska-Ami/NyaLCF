import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controller/dsettingfrpc.dart';

class FrpcManagerSX {
  final DSettingFrpcController ds_c = Get.find();

  Widget widget() {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: ListView(
        children: <Widget>[
          Obx(() => ds_c.frpc_download_tip.value),
          Container(
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.warning),
                    title: Text('下载源镜像设置'),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /// TODO: 镜像选择
                        /// 纵向
                        Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: <Widget>[
                              /// 横向Container#1
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
