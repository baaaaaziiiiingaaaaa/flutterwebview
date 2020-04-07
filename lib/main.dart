import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Direct Turf',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  initState() {
    super.initState();
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 1'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Go To Page 2'),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PageTwo()));
          },
        ),
      ),
    );
  }
  Future onSelectNotification(String payload) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PageNotification(
          title: payload
      )),
    );
  }
}

class PageTwo  extends StatefulWidget {
  @override
  GetCurrentURLWebViewState createState() {
    return new GetCurrentURLWebViewState();
  }
}
class GetCurrentURLWebViewState extends State<PageTwo> {
  var urlWebview = "https://baaaaaziiiiingaaaaa.000webhostapp.com/test.php";
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  StreamSubscription<String> _onUrlChanged;

  @override
  initState() {
    super.initState();
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      if (mounted) {
        print(url);
        if (url.indexOf('notification.php') > 1)
        {
          print('notification');
          _notification();
        }
      }
    });
  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    flutterWebviewPlugin.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child : WebviewScaffold(
          key: scaffoldKey,
          url: urlWebview,
          hidden: true,
          withJavascript: true,
        )
    );
  }
}

class PageNotification extends StatelessWidget{
final String title;
const PageNotification({
Key key,
@required this.title,
}) : super(key: key);

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(title),
    ),
    body: Center(
      child: Text('OK'),
    ),
  );
}

  }
Future _notification() async {
  print('Add Notification');
  //var time = DateTime.now().add(Duration(seconds: 5));
  var time = DateTime.now();
  var payload = "Text Of Notification";
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      playSound: false, importance: Importance.Max, priority: Priority.High);
  var iOSPlatformChannelSpecifics =
  new IOSNotificationDetails(presentSound: false);
  var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  var flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.schedule(
    0,
    'Notification is up',
    'Clic for open!!!',
    time,
    platformChannelSpecifics,
    payload: payload,
  );
}

