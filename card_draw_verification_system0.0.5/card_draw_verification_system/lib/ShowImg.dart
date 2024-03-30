import 'package:flutter/material.dart';

import 'Parameter.dart';
import 'ShowBigImg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_ipfs/src/service/image_picker.dart';

//=====================================================
///這頁用來顯示圖片
class ShowImg extends StatefulWidget {
  const ShowImg({super.key, required this.title});

  final String title;

  @override
  State<ShowImg> createState() => _ShowImgState();
}
//=======================================================
///_scrollController:ScrollController() 頁面滾動偵測器
///imgCount:int 目前圖片總數
///getImg:Image 用url找圖片
///
class _ShowImgState extends State<ShowImg> {

  final ScrollController _scrollController = ScrollController();

  static const loadingTag = "##loading##"; //表尾标记
  var _img = <String>[loadingTag];

  int imgMaxCount = 101;
  int imgCount = 0;
  int count = 0;

  //===============================================
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.separated(
        itemCount: _img.length~/2 == 0? 1 : (_img.length~/2)+1,
        itemBuilder: (context, index) {
          //如果到尾
          if ((index+1)*2 > _img.length) {
            //滑到沒圖片，繼續下載
            if (_img.length < imgMaxCount) {
              //下載
              _retrieveData();
              //顯示loading
              return Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: CircularProgressIndicator(strokeWidth: 2.0),
                ),
              );
            } else {
              //下載完畢
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "no more",
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
          }
          return ListTile(
              title: showRow(index)
          );
        },
        separatorBuilder: (context, index) => Divider(height: .0),
      )
    );
  }

  Future<void> _retrieveData() async {
    print("IP: $serverIP");
    var response = await http.get(Uri.http(serverIP, "/api/cids"));
    var responseBody = response.body;
    var data = convert.jsonDecode(response.body) as List<dynamic>;
    //print(data.toString());
    print(data.length);
    imgMaxCount = data.length;
    print(data[1]);
    setState(() {
      for(int i = 1;i < imgMaxCount;i++){
        count++;
        _img.insert(count-1, "http://" + serverIP + "/api/getImage?id=" + data[count]);
      }
    });

  }

  Row showRow(index){
    return Row(
      children: <Widget>[
        Expanded(flex: 10, child: showImg(_img[index*2])),
        if(_img[index*2+1]!=loadingTag)Expanded(flex: 1, child: SizedBox.fromSize(size: Size(1, 0))),
        if(_img[index*2+1]!=loadingTag)Expanded(flex: 10, child: showImg(_img[index*2+1])),
      ],
    );
  }

  Ink showImg(img) {
    String url = img;
    return Ink(
        child:InkWell(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ShowBigImg(title:"放大圖片", img:url, cid:url)));
            },
            child: Image.network(
              url,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ));
              },
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return const FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    'Not find image',
                    style: TextStyle(fontSize: 36),
                  ),
                );
              },
            )
        )
    );
  }
}