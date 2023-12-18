import 'package:flutter/material.dart';

class FrpcManagerSX {
  Widget widget() {
    return ListView(
      children: [
        Card(
          child: Row(
            children: [
              Expanded(
                child: ListTile(
                  leading: Icon(Icons.cabin),
                  title: Text("Frpc版本"),
                ),
              ),
              Expanded(
                  child: Container(
                width: 50,
                child: DropdownButton(
                  items: [DropdownMenuItem(child: Text("Test"))],
                  onChanged: null,
                ),
              ))
            ],
          ),
        )
      ],
    );
  }
}
