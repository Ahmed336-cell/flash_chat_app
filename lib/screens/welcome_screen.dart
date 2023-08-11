import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chatt/components/round_button.dart';
class WelcomeScreen extends StatefulWidget {
  static String id = "welcome_screen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {

  late AnimationController _controller ;
late Animation _animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  _controller  = AnimationController(
    vsync: this,
    duration: Duration(seconds: 1),

    );

  _animation = ColorTween(begin: Colors.blueGrey,end: Colors.white).animate(_controller);
    _controller.forward();

    _controller.addListener(() {
      setState(() {
      });
      print(_animation.value);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: "logo",
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundButton(text: "Log In", onPressed: (){
              Navigator.pushNamed(context, LoginScreen.id);
            }, color: Colors.lightBlue,),
            RoundButton(text: "Register", onPressed: (){
              Navigator.pushNamed(context, RegistrationScreen.id);

            }, color: Colors.blueAccent)
          ],
        ),
      ),
    );
  }
}

