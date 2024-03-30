import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'Parameter.dart';

//==========================================================
///這頁是顯示虛擬資料的，包括圓餅圖和各角色的資料
class ShowResults extends StatefulWidget {
  const ShowResults({super.key, required this.title});

  final String title;

  @override
  State<ShowResults> createState() => _ShowResultsState();
}
//==========================================================
///fakeRole、fakeStar、totalMap、dataMap、detailMap都是虛擬資料的，之後會刪
///testAddData():void 增加虛擬資料
///_buildDataItem(String,int):Widget  將資料顯示在畫面上
class _ShowResultsState extends State<ShowResults> {

  Map<String, int> showMap = {};  //角色|星數:數量
  List<String> showImg = [];
  String bino = "";

  Future<void> callData() async {
    if(!mounted) {
      debugPrint("資料已中斷傳入");
      return;
    }
    try {
      print("IP: $serverIP");
      var response = await http.get(Uri.http(serverIP, "/api/starCount"));
      var responseBody = response.body;
      print("responseBody");
      print(responseBody);
      var data = convert.jsonDecode(response.body) as Map<String, dynamic>;
      List<String> dataString = ["", "one_star_count", "two_star_count", "three_star_count"];
      List<String> dataStringChinese = ["", "1星", "2星", "3星"];
      print(data);
      for (int i = 1; i < 4; i++) {
        String star = "$i星";
        totalMap[star] = data[dataString[i]];
        total += totalMap[star]!;
        showMap[dataStringChinese[i]] = totalMap[star]!;
      }
      for (var element in totalMap.keys) {
        double probability;
        try {
          probability = totalMap[element]! / total;
        } catch (e) {
          probability = 0;
        }
        dataMap[element] = probability;
      }

      setState(() {});

      response = await http.get(Uri.http(serverIP, "/api/bino"));
      responseBody = response.body;
      bino = convert.jsonDecode(response.body) as String;

      response = await http.get(Uri.http(serverIP, "/api/allRolesCount"));
      responseBody = response.body;
      print("responseBody");
      print(responseBody);
      var allRolesCount = convert.jsonDecode(response.body) as List<dynamic>;
      print(allRolesCount.length);
      //print(allRolesCount[5].runtimeType);
      for(int i = 0;i < allRolesCount.length; i++){
        if(allRolesCount[i] == 0) continue;
        detailMap[i] = allRolesCount[i];
      }
      detailMap.forEach((key, value) {
        showMap[roleMap[key]] = value;
      });
      for(int i = 0; i < allRolesCount.length; i++){
        if(allRolesCount[i] != 0) {
          showImg.add("http://$serverIP/api/getRolesImage?id=${i+1}");
        }
      }

      setState(() {});
    }
    catch(e) {
      print("ERROR callData: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    showMap = {};
    dataMap = {};  //星數:百分比
    totalMap = {};  //星數:數量
    detailMap = {};  //角色:數量
    total = 0;  //角色總數
    callData();
  }

  Widget _buildDataItem(String name, int total, int index) {
    return ListTile(
        leading: index >= 3? showImgF(showImg[index-3]):null,
        title: Text(name),
        //subtitle: Text("${fakeStar[fakeRole.indexOf(name)]}星"),
        trailing: Text(total.toString()),
        leadingAndTrailingTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        )
    );
  }

  Ink showImgF(img) {
    String url = img;
    return Ink(
        child: InkWell(
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
  //====================================================
  ///ListView可以顯示一個清單
  ///PieChart圓餅圖
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
        body: showMap.isEmpty
            ? const Center(child: Text('Loading...'))
            : ListView.separated(
              itemCount: showMap.length + 1,
              itemBuilder: (context, index) {
                if(index==0){
                  return InkWell(
                      child: PieChart(
                        dataMap: dataMap,
                        legendOptions: const LegendOptions(
                          showLegendsInRow: false,
                          legendPosition: LegendPosition.right,
                          showLegends: true,
                          legendTextStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValueBackground: true,
                          showChartValues: true,
                          showChartValuesInPercentage: false,
                          showChartValuesOutside: false,
                          decimalPlaces: 2,
                        ),
                      ),
                      onTap: () {
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
                                      Text(
                                        bino, style: Theme
                                          .of(context)
                                          .textTheme
                                          .titleLarge,),
                                      const SizedBox(height: 15),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        );
                      });
                } else {
                  return _buildDataItem(showMap.keys.toList()[index-1],
                      showMap.values.toList()[index-1],
                      index-1);
                }
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
        )
    );
  }
}