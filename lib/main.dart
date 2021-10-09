// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_replication/controller/configuration_controller.dart';
import 'package:liquid_replication/styles.dart';
import 'package:liquid_replication/view/market_screen.dart';

void main() => runApp(GetMaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Instantiate configuration - getx
    final ConfigurationController appConfiguration =
        Get.put(ConfigurationController());
    //Material app
    return Obx(() {
      return CupertinoApp(
        theme: appConfiguration.isLightTheme.value
            ? Styles.lightTheme
            : Styles.dartTheme,
        home: MarketScreen(),
      );
    });
  }
}
