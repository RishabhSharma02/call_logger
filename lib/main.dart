import 'package:call_log/call_log.dart';
import 'package:call_logger_project/modals/Note_data.dart';
import 'package:call_logger_project/views/Notes_screen.dart';
import 'package:call_logger_project/views/call_logs_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';



Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

/// example widget for call log plugin
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    return ChangeNotifierProvider(
      create: (context) => Notedata(),
      builder:(context, child) =>MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: Call_log()
      ),
    );
  }
}