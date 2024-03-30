import 'package:flutter/material.dart';
// import 'packageipfs_client_flutter/ipfs_client_flutter.dart';

class IpfsTest extends StatefulWidget {
  const IpfsTest({super.key, required this.title});

  final String title;

  @override
  State<IpfsTest> createState() => _IpfsTestState();
}

class _IpfsTestState extends State<IpfsTest> {

  Future<void> ipfs() async {
    // IpfsClient ipfsClient = IpfsClient(url : 'http://192.168.1.117:5001');
    //var res = await ipfsClient.mkdir(dir: 'testDir');
    //debugPrint("00----$res");
    /*
    var res1 = await ipfsClient.write(
        dir: 'testDir/test01.txt',
        filePath: "C:\\Users\\user\\Desktop\\test01.txt",
        fileName: "test01.txt");
    debugPrint("01----$res1");

     */
    //var res2 = await ipfsClient.ls(dir: "testDir");
    //debugPrint("02----$res2");
    /*
    var res3 = await ipfsClient.read(dir: "testDir/test01.txt");
    debugPrint("03----$res3");

     */
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: (){
                ipfs();
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.black),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.purpleAccent),
              ),
              child: const Text('Test'),
            )
          ],
        ),
      ),
    );
  }
}