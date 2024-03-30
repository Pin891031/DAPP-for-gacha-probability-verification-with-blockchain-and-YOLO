import 'dart:io';

/// gamelist:String[] 遊戲池
/// cardlist0:String[]  第0個遊戲卡池
/// cardlist1:String[]  第1個遊戲卡池
/// cardlist2:String[]  第2個遊戲卡池
/// cardlist3:String[]  第3個遊戲卡池
/// cardlist:String[][] 卡池的二微陣列
/// cardMap:Map<String, List> Map<遊戲池,卡池>
/// =======以下為測試資料，之後會改=========
/// dataMap:Map<String, double> 星數:百分比
/// totalMap:Map<String, int> 星數:數量
/// detailMap:Map<String, int>  角色:數量
/// total:int 角色總數
/// ====================================
/// dropdownValuegame:String  當前選則遊戲
/// dropdownValuecard:String  當前選擇卡池
/// list:String[] 當前選則遊戲的卡池陣列
/// tempDir:Directory 程式資料夾位置
/// tempPath:String 程式資料夾位置
/// isPort:bool port打開了沒
/// isFABOpen:bool  FAB打開了沒

const List<String> gamelist = <String>["請選擇遊戲","公連","馬娘","原神"];
const List<String> cardlist0 = <String>["請選擇卡池"];
const List<String> cardlist1 = <String>["請選擇卡池","一般池","公主祭"];
const List<String> cardlist2 = <String>["請選擇卡池","黃金船池","特別周池"];
const List<String> cardlist3 = <String>["請選擇卡池","八重神子池","雷電將軍池"];

const List<List<String>> cardlist = [cardlist0,cardlist1,cardlist2,cardlist3];
Map<String, List> cardMap = Map.fromIterables(gamelist,cardlist);

Map<String, double> dataMap = {"Null":100};  //星數:百分比
Map<String, int> totalMap = {"Null":100};  //星數:數量
Map<int, int> detailMap = {};  //角色:數量
int total = 0;  //角色總數

String dropdownValuegame = cardMap.keys.first;
String dropdownValuecard = cardMap.values.first.first;
List<String> list = cardlist.first;

String serverIP = "192.168.1.114";

Directory? tempDir;
String? tempPath;
bool isPort = false;
bool isFABOpen = false;

// 角色map
List<String> roleMap = [
  "日和",
  "怜",
  "禊",
  "胡桃",
  "依里",
  "鈴莓",
  "優花梨",
  "碧",
  "美咲",
  "步未",
  "莉瑪",
  "茉莉",
  "茜里",
  "宮子",
  "雪",
  "七七香",
  "美里",
  "鈴奈",
  "香織",
  "美美",
  "綾音",
  "鈴",
  "惠理子",
  "忍",
  "真陽",
  "栞",
  "千歌",
  "空花",
  "珠希",
  "美冬",
  "深月",
  "紡希",
  "純(聖誕節)",
  "杏奈",
  "真步",
  "璃乃",
  "初音",
  "霞",
  "伊緒",
  "咲戀",
  "望",
  "妮諾",
  "秋乃",
  "鏡華",
  "智",
  "真琴",
  "伊莉亞",
  "純",
  "靜流",
  "莫妮卡",
  "流夏",
  "吉塔",
  "亞里莎",
  "雪菲",
  "嘉夜",
  "祈梨",
  "安",
  "古蕾婭",
  "空花(大江戶)",
  "妮諾(大江戶)",
  "碧(插班生)",
  "克蘿依",
  "琪愛兒",
  "優妮",
  "美美(萬聖節)",
  "露娜",
  "伊莉亞(聖誕節)",
  "霞(魔法少女)",
  "鈴(遊俠)",
  "真陽(遊俠)",
  "璃乃(奇幻)",
  "七七香(夏日)",
  "純(夏日)",
  "茜里(天使)",
  "依里(天使)",
  "伶(萬聖節)",
  "莫妮卡(魔法少女)",
  "智(魔法少女)",
  "咲戀(聖誕節)",
  "霞(夏日)",
  "真琴(灰姑娘)",
  "真步(灰姑娘)",
  "克蘿依(聖學祭)",
  "琪愛兒(聖學祭)",
  "優妮(聖學祭)",
  "祈梨(時空旅者)",
  "嘉夜(時空旅者)",
  "碧(工作服)",
  "美冬(工作服)",
  "靜流(夏日)",
  "千歌(夏日)",
  "深月(大江戶)",
  "雪(大江戶)",
  "鈴奈(萬聖節)",
  "伊緒(黑暗)",
  "空花(黑暗)",
  "璃乃(聖誕節)",
  "胡桃(舞台)",
  "美咲(舞台)",
  "祈梨(怪盜)",
  "杏奈(海盜)",
  "忍(海盜)",
  "優花梨(露營)",
  "班比",
  "優依(夏日)",
  "鏡華(夏日)",
  "真步(探險家)",
  "綾音(探險家)",
  "七七香(萬聖節)",
  "茉莉(狂野)",
  "矛依未",
  "帆稀",
  "拉比林斯達",
  "似似花",
  "克莉絲提娜",
  "蘭法",
  "美空",
  "愛梅斯",
  "日和(公主)",
  "優依(公主)",
  "伶(公主)",
  "貪吃佩可(公主)",
  "可可蘿(公主)",
  "凱留(公主)",
  "初音＆栞",
  "禊＆美美＆鏡華",
  "秋乃＆咲戀",
  "安＆古蕾婭",
  "貪吃佩可(夏日)",
  "鈴莓(夏日)",
  "凱留(夏日)",
  "珠希(夏日)",
  "忍(萬聖節)",
  "美咲(萬聖節)",
  "千歌(聖誕節)",
  "綾音(聖誕節)",
  "日和(新年)",
  "優衣(新年)",
  "靜流(情人節)",
  "鈴奈(夏日)",
  "咲戀(夏日)",
  "真琴(夏日)",
  "真步(夏日)",
  "鏡華(萬聖節)",
  "克莉絲提娜(聖誕節)",
  "貪吃佩可(新年)",
  "可可蘿(新年)",
  "凱留(新年)",
  "流夏(夏日)",
  "初音(夏日)",
  "紡希(萬聖節)",
  "秋乃(聖誕節)",
  "似似花(新年)",
  "可可蘿(祭服)",
  "惠理子(夏日)",
  "望(夏日)",
  "香織(萬聖節)",
  "宮子(聖誕節)",
  "雪菲(新年)",
  "伊莉亞(新年)",
  "克蕾琪塔",
  "貪吃佩可(超載)",
  "凱留(超載)",
  "步未(怪盜)",
  "靜流(黑暗)",
  "伶(夏日)",
  "美美(夏日)",
  "涅婭",
  "智(萬聖節)",
  "克莉絲提娜(狂野)",
  "茜里(聖誕節)",
  "帆稀(新年)",
  "美里(新年)",
  "望(解放者)",
  "矛依未(解放者)",
];