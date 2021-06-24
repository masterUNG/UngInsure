import 'package:flutter/material.dart';
import 'package:unginsure/states/checkpin.dart';
import 'package:unginsure/states/list_insure.dart';
import 'package:unginsure/utility/my_constant.dart';

final Map<String, WidgetBuilder> map = {
  '/listInsure': (BuildContext context) => ListInsure(),
  
 
};

String? firstState;

void main() {
  firstState = MyConstant.routeListInsure;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyConstant.appName,
      routes: map,
      initialRoute: firstState,
    );
  }
}
