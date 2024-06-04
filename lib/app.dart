import 'package:bucks_buddy/bindings/general_bindings.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:bucks_buddy/utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // title: TTexts.appName,
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      // debugShowCheckedModeBanner: false,
      initialBinding: GeneralBindings(),
      /// color tu boleh tukar yellow cair ke apa
      home: const Scaffold(backgroundColor: Color.fromARGB(255, 255, 246, 75), body: Center(child: CircularProgressIndicator(color: Colors.white,),),),
    );
  }
}