import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_project/Screens/register.dart';
// import 'package:flutter_otp_verification_ui/register.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(232, 254, 255, 1),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Column(
            children: [
              Image.asset(
                'assets/images/hello.png',
                width: 240,
              ),
              SizedBox(
                height: 18,
              ),
              Text(
                "Let's get started",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Never a better time than now to start.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 38,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    // onPressed: () {},
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Register()),
                    );
                  },
                  style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Color.fromRGBO(0, 157, 255, 1)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Text(
                      'Register',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
