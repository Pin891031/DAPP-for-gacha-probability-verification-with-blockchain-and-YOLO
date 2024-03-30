import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'Parameter.dart';

//======================================
///此頁面會根據選擇的卡池來檢視該卡池的資料夾
///currentDirPath:String  目前路徑
class UploadPage extends StatefulWidget {
  UploadPage({super.key, required this.title, required this.currentDirPath});

  final String title;
  late String currentDirPath; // 目前路徑

  @override
  State<UploadPage> createState() => _UploadPageState();
}
//======================================
///HOST:String  伺服器IP位置
///PORT:String  伺服器Port
///currentFiles:FileSystemEntity[]  目前路徑下的檔案和資料夾
///directory:Directory()  以區分之路徑
///dirName:String 遊戲and卡池名
///getCurrentPathFiles():void 獲取當前路徑下的資料/資料夾
///upData():void  上傳影片
///getFileSize(int):String  翻譯檔案大小
///getCurrentPathFiles(String):void 獲取當前路徑下的資料/資料夾
///deleteFile():void  刪除檔案
///_buildFileItem(FileSystemEntity):Widget  將資料夾內的檔案弄成Widget顯示在畫面上
class _UploadPageState extends State<UploadPage> {
  static const String HOST = "192.168.1.117";
  static const int PORT = 7000;

  List<FileSystemEntity> currentFiles = []; // 目前路徑下的檔案和資料夾
  var directory; // 以區分之路徑
  String dirName = ""; // 遊戲and卡池名

  //====================================================
  ///初始化，定位至卡池資料夾
  @override
  void initState() {
    super.initState();
    directory = Directory(widget.currentDirPath);
    currentFiles = directory.listSync();
    debugPrint("00"+currentFiles.toString());
    getCurrentPathFiles(widget.currentDirPath);
    //debugPrint("00"+widget.currentDirPath);
    debugPrint("01"+currentFiles.toString());
  }

  Future<void> upData() async {
    int i = 0;
    try {
      while(i < currentFiles.length) {

        print("開始上傳");

        var dio = Dio();

        FormData formData = FormData.fromMap({
          'file[]': await MultipartFile.fromFile(
            currentFiles[i].path,
          ),
        });

        var response = await dio.post(
          "http://$serverIP/api/upload",
          data: formData,
          options: Options(
            contentType: 'multipart/form-data; boundary=${formData.boundary}',
          ),
        );

        i++;

        if (response.statusCode == 200) {
          //-----刪除已上傳之檔案-------
          var deleteFile = File(currentFiles[0].path);
          if (deleteFile.statSync().type == FileSystemEntityType.directory) {
            Directory directory = Directory(deleteFile.path);
            directory.deleteSync(recursive: true);
          } else if (deleteFile.statSync().type == FileSystemEntityType.file) {
            deleteFile.deleteSync();
          }
          getCurrentPathFiles(widget.currentDirPath);
          i--;
          debugPrint('已刪除影像');
          //-------------------------
        } else {
          print('UpData ERROR！');
        }
      }
    }catch(e){
      debugPrint('$e');
    }

    Navigator.pop(context);
    setState(() {});
  }

  String getFileSize(int fileSize) {
    String str = '';

    if (fileSize < 1024) {
      str = '${fileSize.toStringAsFixed(2)}B';
    } else if (1024 <= fileSize && fileSize < 1048576) {
      str = '${(fileSize / 1024).toStringAsFixed(2)}KB';
    } else if (1048576 <= fileSize && fileSize < 1073741824) {
      str = '${(fileSize / 1024 / 1024).toStringAsFixed(2)}MB';
    }

    return str;
  }

  // 獲取當前路徑下的資料/資料夾
  Future<void> getCurrentPathFiles(String path) async {
    try {
      Directory currentDir = Directory("$path/$dropdownValuegame/$dropdownValuecard");
      currentFiles = currentDir.listSync();
      List<FileSystemEntity> files = [];

      //創立對應的資料夾，如已存在，則跳轉進去
      if(!(await currentDir.exists())){
        await currentDir.create(recursive: true);
      }
      directory = currentDir;
      dirName = "$dropdownValuegame/$dropdownValuecard";
      //debugPrint("00$currentDir");

      // 遍歷所有檔案/資料夹
      for (var v in currentDir.listSync()) {
        // 去除不是以'Video'開頭的檔案和資料夾
        if (p.basename(v.path).substring(0,5) != 'Video') {
          //debugPrint(v.path.toString());
          continue;
        }
        if (FileSystemEntity.isFileSync(v.path)) {
          files.add(v);
        }
      }

      // 排序
      files.sort((a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()));

      currentFiles.clear();
      currentFiles.addAll(files);
      //debugPrint("01$directory");
      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      debugPrint("Directory does not exist！");
    }
  }
  //刪除檔案
  void deleteFile() {
    try {
      for (var file in currentFiles) {
        if (file.statSync().type == FileSystemEntityType.directory) {
          Directory directory = Directory(file.path);
          directory.deleteSync(recursive: true);
        } else if (file.statSync().type == FileSystemEntityType.file) {
          file.deleteSync();
        }
      }
    }on FileSystemException catch (e) {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) =>
              Dialog(
                  child: Text(e.message)
              )
      );
    }
    getCurrentPathFiles(widget.currentDirPath);
  }

  Widget _buildFileItem(FileSystemEntity file) {
    //String modifiedTime = DateFormat('yyyy-MM-dd HH:mm:ss', 'zh_TW').format(file.statSync().modified.toLocal());

    return InkWell(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.5, color: Color(0xffe5e5e5))),
        ),
        child: ListTile(
          /*leading: IconButton(
            onPressed: () {  },
            icon: const Icon(Icons.delete),
          ),//_buildImage(file.path),*/
          title: Text(file.path.substring(file.parent.path.length + 1)),
          subtitle: Text(getFileSize(file.statSync().size), style: const TextStyle(fontSize: 12.0)),
        ),
      ),
      onTap: () {
        OpenFile.open(file.path);
      },

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(dirName,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) =>
                    Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("確定刪除全部影像?", style: Theme
                                .of(context)
                                .textTheme
                                .titleLarge,),
                            const SizedBox(height: 15),
                            Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: <Widget>[
                                  TextButton(
                                    child: const Text('取消'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('確認'),
                                    onPressed: () {
                                      deleteFile();
                                      debugPrint('已刪除全部影像');
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                  ),
                                ]
                            )

                          ],
                        ),
                      ),
                    ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) =>
                    Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("確定上傳全部影像?", style: Theme
                                .of(context)
                                .textTheme
                                .titleLarge,),
                            const SizedBox(height: 15),
                            Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: <Widget>[
                                  TextButton(
                                    child: const Text('取消'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('確認'),
                                    onPressed: () {
                                      upData();
                                    },
                                  ),
                                ]
                            )

                          ],
                        ),
                      ),
                    ),
              );
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: currentFiles.isEmpty
          ? const Center(child: Text('目前無任何影像'))
          : Scrollbar(
          child: ListView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            children: currentFiles.map((e) {
              return _buildFileItem(e);
            }).toList(),
          )
      ),
    );
  }
}