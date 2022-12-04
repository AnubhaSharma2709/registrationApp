import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:registration_app/helper/helper_function.dart';
import 'package:registration_app/pages/auth/homepage.dart';
import 'package:registration_app/pages/auth/loginpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;
  @override
  void initState(){
    super.initState();
    getUserLoggedInStatus();
  }


  getUserLoggedInStatus() async{
    await HelperFunctions.getUserLoggedInStatus().then((value){
      if(value!=null){
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor:Colors.pink,
        scaffoldBackgroundColor: Colors.white
      ),
      debugShowCheckedModeBanner: false,
      home: _isSignedIn? const HomeScreen() : const LoginScreen(),
    );
  }
}
