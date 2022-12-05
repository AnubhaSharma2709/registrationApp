import 'package:flutter/material.dart';
import 'package:registration_app/helper/helper_function.dart';
import 'package:registration_app/pages/auth/loginpage.dart';
import 'package:registration_app/services/auth_service.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthService authService = AuthService();
  String userName = "";
  String email = "";
  @override
  void initState() {
    super.initState();
    gettingUserData();
  }
  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
  }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.deepPurple[50],
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[400],
          ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 170),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Welcome Students",
                  style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),),
                Text("To Student Portal App",
                  style: TextStyle(
                    color: Colors.deepPurple[600],
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),),
                Icon(
                  Icons.account_circle_rounded,
                  size: 100,
                  color: Colors.deepPurple,
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Full Name", style: TextStyle(fontSize: 17,
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.w500)),
                    Text(userName, style: const TextStyle(fontSize: 15)),
                  ],
                ),
                const Divider(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Email", style: TextStyle(fontSize: 17,
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.w500)),
                    Text(email, style: const TextStyle(fontSize: 15),),
                  ],
                ),
              ],
            ),
          ),
        ),
      drawer: Drawer(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 50),
            children: <Widget>[
              Icon(
                Icons.account_circle,
                size: 150,
                color: Colors.deepPurple[600],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                userName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                email,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              const Divider(
                height: 2,
              ),
              ListTile(
                onTap: () async {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Logout"),
                          content: const Text("Are you sure you want to logout?"),
                          actions: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Text(
                                "No" , style: TextStyle(
                                color: Colors.red
                              ),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await authService.signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => const LoginScreen()),
                                        (route) => false);
                              },
                              icon: const Text(
                                "Yes",style: TextStyle(
                                color: Colors.green,
                              ),
                              ),
                            ),
                          ],
                        );
                      });
                },
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(Icons.exit_to_app),
                title: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
        ),
      );
    }
  }

