import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shallows/services/auth_service.dart';
//import 'package:shallows/screens/authenticate/residenceDropDown.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      home: Scaffold(
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
                      child: Image.asset(
                        'assets/Untitled-3.png',
                        width: 400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 90,
                    ),
                    child: TextFormField(
                      controller: emailController,
                      validator: validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
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
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 90,
                  //   ),
                  //   child: ResidenceDropdown(),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 90,
                      right: 90,
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
                        //border: InputBorder.none,
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
                      bottom: 40,
                    ),
                    child: TextFormField(
                      controller: confirmPasswordController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Empty';
                        } else if (val != passwordController.text) {
                          return "Does not match";
                        } else
                          return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.limeAccent[700],
                          onPrimary: Colors.black87,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        child: isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Sign Up'),
                        onPressed: user != null
                            ? null
                            : () async {
                                //setState(() => isLoading = true);
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
                        style: ElevatedButton.styleFrom(
                          primary: Colors.limeAccent[700],
                          onPrimary: Colors.black87,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
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
// child: DropdownButtonHideUnderline(
//                       child: DropdownButton<String>(
//                         value: null,
//                         items: currentResidences.map((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(value),
//                           );
//                         }).toList(),
//                       ),
//                     ),