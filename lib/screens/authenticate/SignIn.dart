import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shallows/services/auth_service.dart';
import 'Register.dart';
import 'package:page_transition/page_transition.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String errorMessage = '';
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      home: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        child: Scaffold(
          body: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 58, 123, 213),
                  Color.fromARGB(255, 58, 96, 115),
                ],
              ),
            ),
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedOpacity(
                      opacity: .7,
                      //_currentOpacity fix this later
                      duration: const Duration(seconds: 2),
                      child: Padding(
                        padding: const EdgeInsets.all(50),
                        child: Image.asset('assets/Untitled-3.png'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 90,
                        vertical: 10,
                      ),
                      child: TextFormField(
                        controller: emailController,
                        validator: validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Username",
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          errorStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 90,
                        right: 90,
                        bottom: 0,
                      ),
                      child: TextFormField(
                        controller: passwordController,
                        validator: validatePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            errorStyle: TextStyle(
                              color: Colors.black,
                            ),
                            errorMaxLines: 3
                            //border: InputBorder.none,
                            ),
                        style: TextStyle(
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        errorMessage,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 15.0,
                                left: 20,
                              ),
                              child: ElevatedButton(
                                child: Text('Login'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.limeAccent[700],
                                  onPrimary: Colors.black87,
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                onPressed: user != null
                                    ? null
                                    : () async {
                                        if (_formKey.currentState!.validate()) {
                                          try {
                                            dynamic result = await _auth
                                                .signInWithEmailAndPassword(
                                                    emailController.text,
                                                    passwordController.text);
                                            if (result == null) {
                                              print('error signing in');
                                              errorMessage =
                                                  'Incorrect Password';
                                            } else {
                                              print('signed in');
                                              print(result.uid);
                                            }
                                          } on FirebaseAuthException catch (error) {
                                            errorMessage = error.message!;
                                          }

                                          setState(() {});
                                        }
                                      },
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                right: 0,
                              ),
                              child: TextButton(
                                child: Text('Forgot Password?'),
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  primary: Colors.limeAccent[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                            ),
                          ),
                          TextButton(
                            child: Text('Sign Up'),
                            style: TextButton.styleFrom(
                                primary: Colors.limeAccent[700],
                                textStyle: TextStyle(
                                  decoration: TextDecoration.underline,
                                )),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.size,
                                    alignment: Alignment.bottomCenter,
                                    child: Register(),
                                  ));
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty)
    return 'E-mail address is required.';

  String pattern = r'\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) return 'Invalid E-mail Address format.';

  return null;
}

String? validatePassword(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty)
    return 'Password is required.';

  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formPassword))
    return '''
      Password must be at least 8 characters, include an uppercase letter, number, and symbol.
    ''';

  return null;
}
