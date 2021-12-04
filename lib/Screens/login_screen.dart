import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';

import 'home_screen.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String verificationId;
  late String newCode;
  bool showLoading = false;

  void _onCountryChange(CountryCode countryCode) {
    //TODO : manipulate the selected country code here
    print("New Country selected: " + countryCode.toString());
    newCode = countryCode.toString();
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
      await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

     if (authCredential.user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      _scaffoldKey.currentState!
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }

  getMobileFormWidget(context) {
    return Column(
      children: [
        CountryCodePicker(
          onChanged: _onCountryChange,
          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
          initialSelection: 'IN',
          favorite: ['+91','IN'],
          // optional. Shows only country name and flag
          showCountryOnly: false,
          // optional. Shows only country name and flag when popup is closed.
          showOnlyCountryWhenClosed: false,
          // optional. aligns the flag and the Text left
          alignLeft: false,
        ),
        // SizedBox(
        //   width: 400,
        //   height: 60,
        //   child: CountryCodePicker(
        //     onChanged: print,
        //     enabled: true,
        //     hideMainText: true,
        //     showFlagMain: true,
        //     showFlag: true,
        //     initialSelection: 'IN',
        //     favorite: ['+91','IN'],
        //     hideSearch: false,
        //     showCountryOnly: false,
        //     showOnlyCountryWhenClosed: false,
        //     alignLeft: false,
        //   ),
        // ),
        const Spacer(),

        TextField(
          controller: phoneController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Mobile Number",
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
        const SizedBox(
          height: 26,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color(0xFF0D47A1),
                        Color(0xFF1976D2),
                        Color(0xFF42A5F5),
                      ],
                    ),
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  primary: Colors.white,
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () async {
                  setState(() {
                    showLoading = true;
                  });

                  await _auth.verifyPhoneNumber(
                    phoneNumber: newCode + phoneController.text,
                    verificationCompleted: (phoneAuthCredential) async {
                      setState(() {
                        showLoading = false;
                      });
                      //signInWithPhoneAuthCredential(phoneAuthCredential);
                    },
                    verificationFailed: (verificationFailed) async {
                      setState(() {
                        showLoading = false;
                      });
                      _scaffoldKey.currentState!.showSnackBar(
                          SnackBar(content: Text(verificationFailed.message.toString())));
                    },
                    codeSent: (verificationId, resendingToken) async {
                      setState(() {
                        showLoading = false;
                        currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                        this.verificationId = verificationId;
                      });
                    },
                    codeAutoRetrievalTimeout: (verificationId) async {},
                  );
                },
                child: const Text('SEND OTP'),
              ),
            ],
          ),
        ),
        // TextButton(
        //   style: TextButton.styleFrom(
        //     padding: const EdgeInsets.all(16.0),
        //     primary: Colors.black,
        //     textStyle: const TextStyle(fontSize: 20),
        //   ),
          // onPressed: () async {
          //   setState(() {
          //     showLoading = true;
          //   });
          //
          //   await _auth.verifyPhoneNumber(
          //     phoneNumber: phoneController.text,
          //     verificationCompleted: (phoneAuthCredential) async {
          //       setState(() {
          //         showLoading = false;
          //       });
          //       //signInWithPhoneAuthCredential(phoneAuthCredential);
          //     },
          //     verificationFailed: (verificationFailed) async {
          //       setState(() {
          //         showLoading = false;
          //       });
          //       _scaffoldKey.currentState!.showSnackBar(
          //           SnackBar(content: Text(verificationFailed.message.toString())));
          //     },
          //     codeSent: (verificationId, resendingToken) async {
          //       setState(() {
          //         showLoading = false;
          //         currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
          //         this.verificationId = verificationId;
          //       });
          //     },
          //     codeAutoRetrievalTimeout: (verificationId) async {},
          //   );
          // },
          // child: const Text("SEND OTP"),
          // color: Colors.blue,
          // textColor: Colors.white,
          //   splashColor: Colors.blueGrey,
        //),
        const Spacer(),
      ],
    );
  }

  getOtpFormWidget(context) {
    return Column(
      children: [
        const Spacer(),
        TextField(
          controller: otpController,
          decoration: const InputDecoration(
            hintText: "Enter OTP",
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        TextButton(
          onPressed: () async {
            PhoneAuthCredential phoneAuthCredential =
            PhoneAuthProvider.credential(
                verificationId: verificationId, smsCode: otpController.text);

            signInWithPhoneAuthCredential(phoneAuthCredential);
          },
          child: const Text("VERIFY"),
          // color: Colors.redAccent,
          // textColor: Colors.white,
        ),
        const Spacer(),
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: const Center(child: Text("This is my application", textAlign: TextAlign.center)),
          leading: IconButton(
            icon: const Icon(Icons.dashboard),
            onPressed: () {},
          ),
          backgroundColor: Colors.lightBlue,
        ),
        body: Container(
          child: showLoading
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
              ? getMobileFormWidget(context)
              : getOtpFormWidget(context),
          padding: const EdgeInsets.all(16),
        ));
  }
}