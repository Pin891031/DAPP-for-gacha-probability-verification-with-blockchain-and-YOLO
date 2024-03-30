import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//=====================================================
class ShowBigImg extends StatefulWidget {
  const ShowBigImg({super.key, required this.title, required this.img, required this.cid});

  final String title;
  final String img; // 圖片
  final String cid;
  @override
  State<ShowBigImg> createState() => _ShowBigImgState();
}
//=======================================================

class _ShowBigImgState extends State<ShowBigImg> {

  //final ScrollController _scrollController = ScrollController()

  // 顯示圖片
  Ink getImg() {
    return Ink(
        child:InkWell(
            onTap: (){
              print("top Img");
            },
            child: Image.network(
              widget.img,
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
  //===============================================
  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     //imgCount += 10;
    //     setState(() {});
    //   }
    // });
    //imgCount += 10;
  }

  @override
  void dispose() {
    super.dispose();
    //_scrollController.dispose();
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
        body: Column(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: getImg()
                    ),
                    Expanded(
                        flex: 1,
                        child: SelectableText(
                          "cid:${widget.cid.split("id=")[1]}",
                          style: const TextStyle(
                              fontSize: 32
                          ),
                        )
                    ),
                  ],
        )
    );
  }
}