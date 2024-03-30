import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ed_screen_recorder/ed_screen_recorder.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'MyAppBar.dart';
import 'Parameter.dart';

//===========================================
///繼承自StatefulWidget的class需要用另一個繼承state的class實作
class MyFirstPage extends StatefulWidget {
  const MyFirstPage({super.key, required this.title});
  final String title;
  @override
  State<MyFirstPage> createState() => _MyFirstPageState();
}
//=============================================
///screenRecorder:EdScreenRecorder  錄影實例
///inProgress:bool  沒用到，忘記是幹嘛的
///_kPortNameOverlay:String 懸浮視窗名字
///_kPortNameHome:String  此介面名字
///_receivePort:ReceivePort() 開一個port，用來與懸浮視窗通訊
///homePort:SendPort  送訊息的
///latestMessageFromOverlay:String  沒用到
///startRecord():void 開始錄影
///stopRecord():void  停止錄影
///pauseRecord():void 暫停錄影
///resumeRecord():void  繼續錄影
///changed(String):void 改變目前選擇的遊戲
class _MyFirstPageState extends State<MyFirstPage> {
  EdScreenRecorder? screenRecorder;
  bool inProgress = false;

  static const String _kPortNameOverlay = 'OVERLAY';
  static const String _kPortNameHome = 'UI';
  final _receivePort = ReceivePort("來自HOME");
  SendPort? homePort;
  String? latestMessageFromOverlay;

  //================================================
  ///screenRecorder:EdScreenRecorder();初始化錄影程式
  ///頁面初始化
  ///所有東西都是在弄port
  @override
  void initState() {
    super.initState();
    screenRecorder = EdScreenRecorder();
    if (homePort != null) return;
    bool res;
    res = IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      _kPortNameHome,
    );
    log("$res: OVERLAY");
    if(!isPort) {
      isPort = true;
      //===================================================
      ///監聽port的callback
      _receivePort.listen((message) {
        log("message from OVERLAY: $message");
        if (message == "startRecord") {
          //創立對應的資料夾，如已存在，則跳轉進去
          Directory newDir = Directory("$tempPath/$dropdownValuegame/$dropdownValuecard");
          if(!(newDir.existsSync())){
            newDir.createSync(recursive: true);
          }
          debugPrint("$tempPath");
          debugPrint("rec to $newDir");

          startRecord(fileName: "Video",path: "$tempPath/$dropdownValuegame/$dropdownValuecard");
        }
        else if (message == "pauseRecord") {
          pauseRecord();
        }
        else if (message == "resumeRecord") {
          resumeRecord();
        }
        else if (message == "stopRecord") {
          stopRecord();
        }
      });
    }
  }
  @override
  void dispose(){
    super.dispose();
  }


  Future<void> startRecord({required String fileName,required String path}) async {
    try {
      await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
      var startResponse = await screenRecorder?.startRecordScreen(
        fileName: fileName,
        //Optional. It will save the video there when you give the file path with whatever you want.
        //If you leave it blank, the Android operating system will save it to the gallery.
        dirPathToSave: path,
        audioEnable: false,
        width: context.size?.width.toInt() ?? 0,
        height: context.size?.height.toInt() ?? 0,
      );

      try {
        // screenRecorder?.watcher?.events.listen(
        //       (event) {
        //     log(event.type.toString(), name: "Event: ");
        //   },
        //   onError: (e) => kDebugMode ? debugPrint('ERROR ON STREAM: $e') : null,
        //   onDone: () => kDebugMode ? debugPrint('Watcher closed!') : null,
        // );
      } catch (e) {
        kDebugMode ? debugPrint('ERROR WAITING FOR READY: $e') : null;
      }

    } on PlatformException {
      kDebugMode ? debugPrint("Error: An error occurred while starting the recording!") : null;
      homePort ??=
          IsolateNameServer.lookupPortByName(_kPortNameOverlay);
      homePort?.send('error');
    } catch (e){
      await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      print(e);
      homePort ??=
          IsolateNameServer.lookupPortByName(_kPortNameOverlay);
      homePort?.send('error');
    }
  }

  Future<void> stopRecord() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    try {
      var stopResponse = await screenRecorder?.stopRecord();
    } on PlatformException {
      kDebugMode ? debugPrint("Error: An error occurred while stopping recording.") : null;
    }
  }

  Future<void> pauseRecord() async {
    try {
      await screenRecorder?.pauseRecord();
    } on PlatformException {
      kDebugMode ? debugPrint("Error: An error occurred while pause recording.") : null;
    }
  }

  Future<void> resumeRecord() async {
    try {
      await screenRecorder?.resumeRecord();
    } on PlatformException {
      kDebugMode ? debugPrint("Error: An error occurred while resume recording.") : null;
    }
  }


  void changed(String value) {
      dropdownValuegame = value;
      list = cardMap[value]!.cast<String>();
      dropdownValuecard = list.first;
  }

  Future<void> openFAB() async {
    debugPrint("$isFABOpen");
    if(isFABOpen == true){
      isFABOpen = false;
      await FlutterOverlayWindow.closeOverlay();
      return;
    }
    /// check if overlay permission is granted
    final bool status = await FlutterOverlayWindow.isPermissionGranted();
    if(!status) {
      /// request overlay permission
      /// it will open the overlay settings page and return `true` once the permission granted.
      final bool? status = await FlutterOverlayWindow
          .requestPermission();
    }
    await FlutterOverlayWindow.showOverlay(
      enableDrag: true,
      //alignment: OverlayAlignment.centerRight,
      //overlayTitle: "X-SLAYER",
      //overlayContent: 'Overlay Enabled',
      flag: OverlayFlag.defaultFlag,
      visibility: NotificationVisibility.visibilityPublic,
      positionGravity: PositionGravity.none,
      width: 220,//200 220
      height: 220,//150 220
    );
    isFABOpen = true;
  }
  //=========================================
  ///Center:Widget  排版用
  ///Column:Widget  排版用
  ///Expanded:Widget  排版用
  ///Text:Widget  標籤
  ///DropdownButton:Widget  下拉式選單
  ///dropdownValuegame:String 目前選擇的遊戲，宣告在Parameter.dart
  ///gamelist:String[]  遊戲清單，宣告在Parameter.dart
  ///DropdownMenuItem:Widget  下拉式選單的Item
  ///onChanged():void 下拉式選單選擇Item後的callback
  ///TextButton:Widget  按鈕
  ///onPressed():void 按鈕按下後的callback
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyAppBar(
        title: widget.title,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Expanded(child: Text(""),),
              Expanded(
                  child: Text("目前遊戲:$dropdownValuegame", style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge,)
              ),
              Expanded(
                  child: Text("目前卡池:$dropdownValuecard", style: Theme
                      .of(context)
                      .textTheme
                      .titleLarge,)
              ),
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
                      setState(() {
                        changed(value!);
                      });
                    },
                  )
              ),
              Expanded(
                  child:
                  DropdownButton<String>(
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
                      setState(() {
                        dropdownValuecard = value!;
                      });
                    },
                  )
              ),
              //====================================================
              ///開啟FAB
              ///Fluttertoast.showToast 顯示警告訊息
              TextButton(
                onPressed: () async {
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
                    openFAB();
                  }
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.black),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.blue),
                ),
                child: const Text("開啟偵測"),
              ),
              //====================================================
              ///開啟上傳影片頁面
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
                    Navigator.pushNamed(context, '/Upload');
                  }
                },
                child: const Text("檢視影像"),

              ),
              const Expanded(flex: 3,child: Text(""),),
            ],
          ),
        ),
      ),
    );
  }
}