import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shallows/services.dart/auth_service.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.lightBlue,
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Welcome to',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    text: 'the Shallows',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 90,
                  ),
                  child: TextFormField(
                    controller: emailController,
                    validator: validateEmail,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 90,
                    right: 90,
                    bottom: 40,
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
                      //border: InputBorder.none,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Sign Up'),
                      onPressed: user != null
                          ? null
                          : () async {
                              setState(() => isLoading = true);
                              if (_formKey.currentState!.validate()) {
                                try {
                                  dynamic result = await _auth.register(
                                    emailController.text,
                                    passwordController.text,
                                  );
                                  if (result == null) {
                                    print('error registering');
                                  } else {
                                    print('registered');
                                    print(result.uid);
                                  }
                                  Navigator.pop(context);
                                } catch (error) {
                                  print(error);
                                }

                                setState(() => isLoading = false);
                              }
                            },
                    ),
                    ElevatedButton(
                      child: Text('Back'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
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
