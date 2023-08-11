import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chatt/constants.dart';
import 'package:flash_chatt/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chatt/components/round_button.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
class RegistrationScreen extends StatefulWidget {
  static String id = "register_screen";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth =  FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpinner = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: "logo",
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;              },
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: kTextInputDecoration.copyWith(hintText: "Enter your Email"),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
               password = value;
                },
                style: TextStyle(
                  color: Colors.black,
                ),
                obscureText: true,
                decoration: kTextInputDecoration.copyWith(hintText: "Enter your password" ,),
              ),
              SizedBox(
                height: 14.0,
              ),
              RoundButton(text: "Register", onPressed: () async{
                setState(() {
                  showSpinner= true;
                });
               try {
                 final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                 if(newUser !=null){
                   Navigator.pushNamed(context, ChatScreen.id);
                 }else{
                   print("Error");
                   setState(() {
                     showSpinner = false;
                   });
                 }
               }catch(e){
                 print(e);
               }
              }, color: Colors.blueAccent),
            ],
          ),
        ),
      ),
    );
  }
}