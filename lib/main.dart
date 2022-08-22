import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallet/views/myHomePage.dart';
import 'package:starflut/starflut.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion = "";

    try {
      String Path1  = await Starflut.getResourcePath();
      String Path2 = await Starflut.getAssetsPath();
      StarCoreFactory starcore = await Starflut.getFactory();
      StarServiceClass Service = await starcore.initSimple("test", "123", 0, 0, []);
      await starcore.regMsgCallBackP(
          (int serviceGroupID, int uMsg, Object wParam, Object lParam) async{
        print("$serviceGroupID  $uMsg   $wParam   $lParam");
        return null;
      });
      dynamic SrvGroup = await Service["_ServiceGroup"];

      /*--macos--*/
      int Platform = await Starflut.getPlatform();
      if( Platform == Starflut.MACOS ) {
        await starcore.setShareLibraryPath(
            Path1); //set path for interface library
        bool LoadResult = await Starflut.loadLibrary(Path1+"/libpython3.9.dylib");
        print("$LoadResult");  //--load
        await Starflut.setEnv("PYTHONPATH","/Library/Frameworks/Python.framework/Versions/3.9/lib/python3.9");
        String pypath = await Starflut.getEnv("PYTHONPATH");
        print("$pypath");
      }else if( Platform == Starflut.WINDOWS ) {
        await starcore.setShareLibraryPath(
            Path1.replaceAll("\\","/")); //set path for interface library
      }

      /*---script python--*/
      bool isAndroid = await Starflut.isAndroid();
      if( isAndroid == true ){
        await Starflut.copyFileFromAssets("testcallback.py", "flutter_assets/starfiles","flutter_assets/starfiles");
        await Starflut.copyFileFromAssets("testpy.py", "flutter_assets/starfiles","flutter_assets/starfiles");
        await Starflut.copyFileFromAssets("python3.6.zip", "flutter_assets/starfiles",null);  //desRelatePath must be null
        await Starflut.copyFileFromAssets("zlib.cpython-36m.so", null,null);
        await Starflut.copyFileFromAssets("unicodedata.cpython-36m.so", null,null);
        await Starflut.loadLibrary("libpython3.6m.so");
      }

      String docPath = await Starflut.getDocumentPath();
      print("docPath = $docPath");

      String resPath = await Starflut.getResourcePath();
      print("resPath = $resPath");

      dynamic rr1 = await SrvGroup.initRaw("python36", Service);
      print("initRaw = $rr1");

      var Result = await SrvGroup.loadRawModule("python", "", resPath + "/flutter_assets/starfiles/" + "testpy.py", false);
      print("loadRawModule = $Result");

      dynamic python = await Service.importRawContext(null,"python", "", false, "");
      print(await python["g1"]);

      StarObjectClass retobj = await python.call("tt", ["hello ", "world"]);
      print(await retobj[0]);
      print(await retobj[1]);
      

      // StarObjectClass yy = await python.call("yy", ["hello ", "world", 123]);
      // print(await yy.call("__len__",[]));

      StarObjectClass multiply = await Service.importRawContext(null,"python", "Multiply", true, "");
      StarObjectClass multiply_inst = await multiply.newObject(["", "", 33, 44]);
      print(await multiply_inst.getString());
      print(await multiply_inst.call("multiply", [11, 22]));

      await SrvGroup.clearService();
      await starcore.moduleExit();
      print("finish");

    } on PlatformException catch (e) {
      print("{$e.message}");
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }