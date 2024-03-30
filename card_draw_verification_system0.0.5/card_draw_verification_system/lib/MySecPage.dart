import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pie_chart/pie_chart.dart';

import 'MyAppBar.dart';
import 'Parameter.dart';

class MySecPage extends StatefulWidget {
  const MySecPage({super.key, required this.title});

  final String title;

  @override
  State<MySecPage> createState() => _MySecPageState();
}
//===============================================
///changedGame(String):void 改變選擇的遊戲
///changedPool(String):void 改變選擇的卡池
///changedPool裡的dataMap、totalMap、detailMap、total都是虛擬資料的，之後會刪
///
class _MySecPageState extends State<MySecPage> {

  void changedGame(String value) {
    setState(() {
      dropdownValuegame = value;
      list = cardMap[value]!.cast<String>();
      dropdownValuecard = list.first;
    });
  }
  void changedPool(String value) {
    setState(() {
      dropdownValuecard = value;
      dataMap.clear();
      totalMap.clear();
      detailMap.clear();
      total = 0;
    });
  }

  @override
  void initState() {
    changedPool(dropdownValuecard);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyAppBar(
        title: widget.title,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Expanded(flex:2,child: Text(""),),
              Expanded(
                  child: DropdownButton<String>(
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge,
                    value: dropdownValuegame,
                    items: gamelist.map<DropdownMenuItem<String>>((
                        String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      changedGame(value!);
                    },
                  )
              ),
              Expanded(
                  child: DropdownButton<String>(
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge,
                    value: dropdownValuecard,
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      changedPool(value!);
                    },
                  )
              ),
              //====================================================
              ///開啟顯示機率頁面
              ///Fluttertoast.showToast 顯示警告訊息
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.black),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.blue),
                ),
                onPressed: () {
                  if(dropdownValuecard == "請選擇卡池") {
                    Fluttertoast.showToast(
                      msg: "請選擇卡池",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black45,
                      textColor: Colors.white,
                      fontSize: 16.0
                    );
                  }else{
                    Navigator.pushNamed(context, '/Sec/ShowResults');
                  }
                },
                child: const Text('顯示機率'),
              ),
              //====================================================
              ///開啟顯示抽卡圖片頁面
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.black),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.blue),
                ),
                onPressed: () {
                  if(dropdownValuecard == "請選擇卡池") {
                  Fluttertoast.showToast(
                  msg: "請選擇卡池",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black45,
                  textColor: Colors.white,
                  fontSize: 16.0
                  );
                  }else {
                    Navigator.pushNamed(context, '/Sec/ShowImg');
                  }
                },
                child: const Text('顯示抽卡圖片'),
              ),
              const Expanded(flex:3,child: Text(""),),
            ],
          ),
        ),
      ),
    );
  }
}