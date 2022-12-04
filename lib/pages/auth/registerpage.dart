import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:registration_app/helper/helper_function.dart';
import 'package:registration_app/pages/auth/homepage.dart';
import 'package:registration_app/pages/auth/loginpage.dart';
import 'package:registration_app/services/auth_service.dart';
import 'package:registration_app/widget/widget.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? Center(
        child: CircularProgressIndicator(
          color: Colors.deepPurple,
        ),
      ):SingleChildScrollView(
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
                    labelText: "Full Name",
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.deepPurple,
                    ),
                  ),
                  validator: (val) {
                    if (val!.isNotEmpty) {
                      return null;
                    } else {
                      return "Name cannot be empty";
                    }
                  },
                  onChanged: (val) {
                    setState(() {
                      fullName = val;
                    });
                  },
                ),
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
                    labelText: "Enter your Password",
                    prefixIcon: Icon(Icons.lock, color: Colors.deepPurple),
                  ),
                  validator: (val) {
                    if (val!.length < 6) {
                      return "Password is too short";
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
                    onPressed: () {
                      register();
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text.rich(TextSpan(
                  text: "Already have an Account?",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Login Here",
                      style: const TextStyle(
                          color: Colors.deepPurpleAccent,
                          decoration: TextDecoration.underline
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {
                          nextScreen(context, const LoginScreen());
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
    register() async {
      if (formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        await authService
            .registerUserWithEmailandPassword(fullName, email, password)
            .then((value) async{
             if(value == true){
               await HelperFunctions.saveUserLoggedInStatus(true);
               await HelperFunctions.saveUserEmailSF(email);
               await HelperFunctions.saveUserNameSF(fullName);
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
