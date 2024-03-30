import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';

import 'MyFAB.dart';
import 'MyFirstPage.dart';
import 'MySecPage.dart';
import 'Parameter.dart';
import 'ShowImg.dart';
import 'ShowResults.dart';
import 'UploadPage.dart';

//===================
//程式進入點
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

//=============================
//懸浮視窗進入點
@pragma("vm:entry-point")
void overlayMain() {
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:MyFAB()
  )
  );
}

/// 根節點
/// 所有繼承自StatelessWidget和StatefulWidget的class都有build方法
/// build方法是選染畫面的地方
/// build裡回傳的MaterialApp的參數routes是介面導航，每個map都是一頁。
/// 照著routes的順序讀會比較好
/// 之後出現的FAB = 懸浮按鈕
/// 共用變數都放在Parameter.dart裡
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// getPath(): void 取得程式資料夾
  /// tempPath: String  程式資料夾位置，此變數宣告在Parameter.dart裡
  Future<void> getPath() async {
    tempDir = await getExternalStorageDirectory();//getApplicationDocumentsDirectory();
    tempPath = tempDir?.path;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getPath();
    return MaterialApp(
      title: 'Card Draw Verification System',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
                color: Color(0xFF000000),
                fontSize: 24
            ),
          )
      ),
      initialRoute: '/',
      routes: {
        '/':(context){return const MyFirstPage(title: '偵測系統',);},
        '/Sec':(context){return const MySecPage(title: '統計結果');},
        '/Upload':(context){return UploadPage(title: '上傳影像', currentDirPath: tempPath!,);},
        '/Sec/ShowResults':(context){return const ShowResults(title: '細項機率',);},
        '/Sec/ShowImg':(context){return const ShowImg(title: '抽卡圖片',);},
      },
    );
  }
}