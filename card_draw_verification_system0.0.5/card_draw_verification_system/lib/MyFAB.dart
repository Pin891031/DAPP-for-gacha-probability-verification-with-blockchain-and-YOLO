import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

//===========================================
///繼承自StatefulWidget的class需要用另一個繼承state的class實作
class MyFAB extends StatefulWidget {
  const MyFAB({super.key});

  @override
  State<MyFAB> createState() => _MyFABState();
}

//============================================
///_kPortNameOverlay:String 懸浮視窗名字
///_kPortNameHome:String  本體介面名字
///_receivePort:ReceivePort() 開一個port，用來與懸浮視窗通訊
///homePort:SendPort  送訊息的
///isRecord:bool  正在錄影?
///isPause:bool 正在暫停?
///mySIcon:Widget 左邊數來第二個Icon
///myS2Icon:Widget  左邊數來第三個Icon
///myBIcon:Widget 大Icon
///initState():void 頁面初始化，所有東西都是在弄port
///_key:GlobalKey() 我不知道這幹嘛的
///closeFAB():void  關閉FAB
///start():void 開始錄影
///stop():void  停止錄影
///pause():void 暫停錄影
///resume():void  繼續錄影
class _MyFABState extends State<MyFAB> {

  static const String _kPortNameOverlay = 'OVERLAY'; //懸浮視窗名字
  static const String _kPortNameHome = 'UI'; //此介面名字
  final _receivePort = ReceivePort("來自FAB"); //開一個port，用來與懸浮視窗通訊
  SendPort? homePort; //送訊息的

  late bool isRecord; //正在錄影?
  late bool isPause; //正在暫停?
  late Widget mySIcon; //左邊數來第二個Icon
  late Widget myS2Icon; //左邊數來第三個Icon
  late Widget myBIcon; //大Icon
  //======================================================
  ///頁面初始化
  ///所有東西都是在弄port
  @override
  void initState() {
    super.initState();
    if (homePort != null) return;
    final res = IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      _kPortNameOverlay,
    );
    log("$res : HOME");
    //===================================================
    ///監聽port的callback
    _receivePort.listen((message) {
      log("message from UI: $message");
      if(message == 'error') {
        setState(() {
          stop();
        });
      }
    });
    stop();
  }
  @override
  void dispose(){
    super.dispose();
  }

  final _key = GlobalKey<ExpandableFabState>();
//=======================================================
  ///關閉FAB
  Future<void> closeFAB() async {
    if (isRecord) stop();
    await FlutterOverlayWindow.closeOverlay();
    final state = _key.currentState;
    if (state != null) {
      debugPrint('isOpen:${state.isOpen}');
      state.toggle();
    }
  }
//=======================================================
  ///開始錄影
  void start(){
    setState(() {
      isRecord = true;
      isPause = false;
      mySIcon = const Icon(Icons.stop);
      myS2Icon = const Icon(Icons.pause);
      myBIcon = const Icon(Icons.play_arrow);
    });
    homePort ??=
        IsolateNameServer.lookupPortByName(_kPortNameHome);
    homePort?.send('startRecord');
  }
  ///停止錄影
  void stop() {
    setState(() {
      isRecord = false;
      isPause = false;
      mySIcon = const Icon(Icons.play_arrow);
      myS2Icon = const Icon(Icons.pause);
      myBIcon = const Icon(Icons.stop);
    });
    homePort ??=
        IsolateNameServer.lookupPortByName(_kPortNameHome);
    homePort?.send('stopRecord');
  }
  ///暫停錄影
  void pause(){
    setState(() {
      isRecord = true;
      isPause = true;
      mySIcon = const Icon(Icons.stop);
      myS2Icon = const Icon(Icons.play_arrow);
      myBIcon = const Icon(Icons.pause);
    });
    homePort ??=
        IsolateNameServer.lookupPortByName(_kPortNameHome);
    homePort?.send('pauseRecord');
  }
  ///恢復錄影
  void resume(){
    setState(() {
      isRecord = true;
      isPause = false;
      mySIcon = const Icon(Icons.stop);
      myS2Icon = const Icon(Icons.pause);
      myBIcon = const Icon(Icons.play_arrow);
    });
    homePort ??=
        IsolateNameServer.lookupPortByName(_kPortNameHome);
    homePort?.send('resumeRecord');
  }
  //=============================================
  ///此頁面本身是一個懸浮視窗，裡面只有按鈕
  ///該按鈕是別人做的，需要用Scaffold包起來
  ///按鈕本身叫做ClipRect
  ///child是按鈕Icon
  ///children包含了三個小按鈕，打開大按鈕時顯示
  ///children從下到上依序是按鈕打開後從左到右的小按鈕
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ClipRect(child: ExpandableFab(
            key: _key,
            //duration: const Duration(seconds: 1),
            childrenOffset: const Offset(4, 4),
            distance: 50.0,
            type: ExpandableFabType.left,
            //fanAngle: 90,
            child: myBIcon,
            // foregroundColor: Colors.amber,
            // backgroundColor: Colors.green,
            // closeButtonStyle: const ExpandableFabCloseButtonStyle(
            //   child: Icon(Icons.abc),
            //   foregroundColor: Colors.deepOrangeAccent,
            //   backgroundColor: Colors.lightGreen,
            //),
            //overlayStyle: ExpandableFabOverlayStyle(
            //color: Colors.black.withOpacity(0.5),
            //  blur: 5,
            //),
            onOpen: () async {
              debugPrint('onOpen');
              await FlutterOverlayWindow.resizeOverlay(220, 90);
            },
            afterOpen: () {
              debugPrint('afterOpen');
            },
            onClose: () {
              debugPrint('onClose');
            },
            afterClose: () async {
              debugPrint('afterClose');
              await FlutterOverlayWindow.resizeOverlay(90, 90);
            },
            children: [
              FloatingActionButton.small(
                heroTag: null,
                child: myS2Icon,
                onPressed: () async {
                  if(isRecord){
                    isPause == false? pause() : resume();
                  }
                },
              ),
              FloatingActionButton.small(
                heroTag: null,
                child: mySIcon,
                onPressed: () async {
                  isRecord == false? start() : stop();
                },
              ),
              FloatingActionButton.small(
                heroTag: null,
                child: const Icon(Icons.logout),
                onPressed: () async {
                  closeFAB();
                },
              ),
            ]
        ),
        )
    );
  }
}