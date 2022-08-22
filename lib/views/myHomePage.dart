// ignore: file_names
import 'package:flutter/material.dart';
import 'package:wallet/views/credentials.dart';
import 'package:wallet/views/home.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int currentIndex = 1;
  PageController pageController = PageController(
    initialPage: 1
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0
        ),
        body: PageView(
          controller: pageController,
          children: const <Widget>[
            Home(),
            Credentials()
            // TestForWebSocket(title: 'Test Web_Socket_Channel', channel: IOWebSocketChannel.connect('wss://echo.websocket.org'),)
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (int index){
            pageController.jumpToPage(index);
            setState(() {
              currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.wb_cloudy), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.attach_money_sharp), label: 'Credentials')
          ],
        )
      ),
    );
  }
}