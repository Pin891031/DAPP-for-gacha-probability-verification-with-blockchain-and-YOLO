import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {

  const MyAppBar({super.key, required this.title, this.body});

  //=======================================
  /// body: Widget  AppBar之外的介面

  final String title;
  final Widget? body;

  //=======================================
  /// 這邊只實作AppBar，就是頁面上方和左邊能拉出來的東西
  /// ListTile是按鈕 onTop()就是點擊後的回調函式
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(title),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('偵測系統'),
              //=======================================
              ///導航到目標頁面
              onTap: () {
                if (title != "偵測系統") {
                  Navigator.pushNamed(context, '/');
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              title: const Text('統計結果'),
              onTap: () {
                if (title != "統計結果") {
                  Navigator.pushNamed(context, '/Sec');
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
      body: body,
    );
  }
}