import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kicksy/view/hq/hq_main.dart';

import 'package:kicksy/view/user/login.dart';
import 'package:kicksy/view/user/payment.dart';
import 'package:kicksy/view/user/usermain.dart';
import 'package:kicksy/vm/database_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Pretendard',
      ),
      home: const Usermain(),
    );
  }
}
