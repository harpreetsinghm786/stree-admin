import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:streeadmin/categories/Categorywidget.dart';
import 'package:streeadmin/constants.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();


  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark
    ));

    return FutureBuilder(
        future: _initialization,

        builder: (context, snapshot) {

          if (snapshot.hasError) {
            print("Something Went Wrong>>"+snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              child: Center(
                  child: CircularProgressIndicator(color: pink,)),
            );
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const MyHomePage(title: 'Flutter Demo Home Page'),
          );
        });

  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return  DefaultTabController(
       initialIndex: 0,
       length: 5,
       child: Scaffold(
         appBar: AppBar(
           backgroundColor: pink,
           title: Text('Stree Admin',style: titlestyle()),
           bottom: const TabBar(
             isScrollable: true,
             indicatorColor:Colors.white,
             tabs: <Widget>[
               Tab(
                 child: Text("Safety Podcasts"),
               ),
               Tab(
                 child: Text("Safety Gadgets"),
               ),
               Tab(
                 child: Text("Safety Schemes"),
               ),
               Tab(
                 child: Text("Safety Apps"),
               ),
               Tab(
                 child: Text("Safety Laws"),
               ),

             ],
           ),
         ),
         body: TabBarView(
           children: <Widget>[
             Categorywidget(category: "Safetypodcasts"),
             Categorywidget(category: "Safetygadgets"),
             Categorywidget(category: "Safetyschemes"),
             Categorywidget(category: "Safetyapps"),
             Categorywidget(category: "Safetylaws"),

           ],
         ),
       ),
     );
  }
}
