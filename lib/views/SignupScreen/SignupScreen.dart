import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grequizapp/Widgets/RoundedButton.dart';
import 'package:grequizapp/main.dart';
import 'package:grequizapp/views/LoginScreen/LoginScreen.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../MainScreen/MainScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Verification.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
static String verify="";
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String _phoneController = "";

  Future<void> googleSignIn(context) async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();

    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          await FirebaseAuth.instance.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
          );
        } on FirebaseException catch (error) {
          print(error.code);
        } catch (error) {
          print(error);
        } finally {}
      }
    }
  }
Future addUserDetails(String name, String email, String phoneNumber) async{
    await FirebaseFirestore.instance.collection('users').add({
      'name':name,
      'email':email,
      'phoneNumber':phoneNumber
    });
}
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 5,
                ),
                //cred https://www.flaticon.com/authors/trazobanana
                Image.asset(
                  'assets/images/man.png',
                  height: 100,
                ),
                const Expanded(child: SizedBox()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      "SIGNUP",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid Name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _nameController.text = value;
                  },
                  decoration: const InputDecoration(
                    // border: OutlineInputBorder(),
                    hintText: 'Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                //email id input
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid Email';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _emailController.text = value;
                  },
                  decoration: const InputDecoration(
                    // border: OutlineInputBorder(),
                    hintText: 'Email ID',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                IntlPhoneField(
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                  ),
                  onChanged: (phone) {
                    if (kDebugMode) {
                      print(phone.completeNumber);
                      setState(() {
                        _phoneController=phone.completeNumber ;
                      });
                    }
                  },
                  onCountryChanged: (country) {
                    print('Country changed to: ${country.name}');
                  },
                ),

                //password input
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid Password';
                    }
                    return null;
                  },
                  obscureText: _obscureText,
                  onChanged: (value) {
                    _passwordController.text = value;
                  },
                  decoration: InputDecoration(

                      // border: OutlineInputBorder(),
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: const Icon(Icons.visibility),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ), //confirmpassword

                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid Confirm Password';
                    }
                    return null;
                  },
                  obscureText: _obscureText,
                  onChanged: (value) {
                    _confirmpasswordController.text = value;
                  },
                  decoration: InputDecoration(

                      // border: OutlineInputBorder(),
                      hintText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: const Icon(Icons.visibility),
                      )),
                ),
                const Expanded(
                  child: SizedBox(),
                ),

                //signup button
                RoundedButton(
                  text: "SignUp",
                  press: () async {

                    if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(_emailController.text) &&
                        _passwordController.text ==
                            _confirmpasswordController.text &&
                        _passwordController.text.isNotEmpty) {
                      addUserDetails(_nameController.text,_emailController.text,_phoneController);
                      if (kDebugMode) {
                        print("Valid Signup");
                        print("Name: ${_nameController.text}");
                        print("Email: ${_emailController.text}");
                        print("Phone: ${_phoneController}");
                      } await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: _phoneController,
                        verificationCompleted: (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException e) {},
                        codeSent: (String verificationId, int? resendToken) {
                          SignupScreen.verify=verificationId;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyVerify(),),);
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                      final snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'On Snap!',
                          message: 'Successfully Signed Up!',
                          contentType: ContentType.success,
                        ),
                      );

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                      try {
                        final credential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        );
                        setState(() {
                          _emailController.text = "";
                          _passwordController.text = "";
                          _confirmpasswordController.text = "";
                        });

                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          if (kDebugMode) {
                            print('The password provided is too weak.');
                            final snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'On Snap!',
                                message: 'The password provided is too weak.',
                                contentType: ContentType.failure,
                              ),
                            );

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
                          }
                        } else if (e.code == 'email-already-in-use') {
                          if (kDebugMode) {
                            print('The account already exists for that email.');
                            final snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'On Snap!',
                                message:
                                    'The account already exists for that email.',
                                contentType: ContentType.failure,
                              ),
                            );

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
                          }
                        }
                      } catch (e) {
                        if (kDebugMode) {
                          print(e);
                        }
                      }
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(_emailController.text)) {
                      if (kDebugMode) {
                        print("Please Enter a Valid Email");
                      }
                      final snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'On Snap!',
                          message: 'Please Enter a valid email!',
                          contentType: ContentType.failure,
                        ),
                      );

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    } else if (_passwordController.text !=
                        _confirmpasswordController.text) {
                      if (kDebugMode) {
                        print("Passwords do not match");
                      }
                      final snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'On Snap!',
                          message: 'Passwords do not match!',
                          contentType: ContentType.failure,
                        ),
                      );

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    } else if (_passwordController.text.isEmpty) {
                      print("Empty password");
                      final snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'On Snap!',
                          message: 'Please enter a valid password!',
                          contentType: ContentType.failure,
                        ),
                      );

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    }
                  },
                  color: const Color(0xFF0065FF),
                ),
                //or
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Row(children: const [
                    Expanded(child: Divider(thickness: 2)),
                    Padding(
                      padding: EdgeInsets.only(left: 12, right: 12),
                      child: Text("OR"),
                    ),
                    Expanded(child: Divider(thickness: 2)),
                  ]),
                ),
                //sign in with google
                GestureDetector(
                  onTap: () => googleSignIn(context),
                  child: Container(
                    height: 50,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.network(
                            'http://pngimg.com/uploads/google/google_PNG19635.png',
                            fit: BoxFit.cover),
                        const SizedBox(
                          width: 5.0,
                        ),
                        const Text(
                          'Sign-up with Google',
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                //new to login / register
                RichText(
                  text: TextSpan(
                    text: "Have already registered?  ",
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      TextSpan(
                          text: "Login",
                          style: const TextStyle(
                            color: Color(0xFF0065FF),
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            }),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 22,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
