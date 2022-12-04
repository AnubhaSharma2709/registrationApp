import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:registration_app/helper/helper_function.dart';
import 'package:registration_app/pages/auth/homepage.dart';
import 'package:registration_app/pages/auth/registerpage.dart';
import 'package:registration_app/services/auth_service.dart';
import 'package:registration_app/services/database_service.dart';
import 'package:registration_app/widget/widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String email = "";
  String password = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? Center(
        child: CircularProgressIndicator(
          color: Colors.deepPurple,
        ),
      ) :SingleChildScrollView (
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 80,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Registration App",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Build by Anubha Sharma \n Fourth Project of CSI",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //Image.asset("assets/login.jpg"),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: " College Email",
                    prefixIcon: Icon(Icons.email, color: Colors.deepPurple),
                  ),
                  onChanged: (val) {
                    setState(() {
                      email = val;
                      print(email);
                    });
                  },
                  //check the validation
                  validator: (val) {
                    return RegExp(
                                r"^[a-zA-Z]+[0-9]+@[akgec]+\.[ac]+\.[in]+")
                            .hasMatch(val!)
                        ? null
                        : "Enter valid College Email";
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock, color: Colors.deepPurple),
                  ),
                  validator: (val) {
                    if (val!.length < 6) {
                      return "The password incorrect";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: (){
                      login();
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text.rich(TextSpan(
                  text:"Don't have an account?",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Register here",
                      style: const TextStyle(
                        color: Colors.deepPurpleAccent,
                        decoration: TextDecoration.underline
                      ),
                      recognizer: TapGestureRecognizer()..onTap= (){
                        nextScreen(context, const RegisterScreen());
                      },
                    ),
                  ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUserNameandPassword(email, password)
          .then((value) async{
        if(value == true){
         QuerySnapshot snapshot =
         await DatabaseService(
           uid: FirebaseAuth.instance.currentUser!.uid)
             .gettingUserData(email);
         //saving the values to our shared preferences
         await HelperFunctions.saveUserLoggedInStatus(true);
         await HelperFunctions.saveUserEmailSF(email);
         await HelperFunctions.saveUserNameSF(
           snapshot.docs[0]['fullName']);
           nextScreenReplace(context, const HomeScreen());
        }
        else{
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
