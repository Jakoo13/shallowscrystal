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
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final residenceController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final AuthService _auth = AuthService();
  String dropdownValue = 'Residence';

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
                child: SingleChildScrollView(
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
                            'assets/LakeFlags.png',
                            width: 400,
                          ),
                        ),
                      ),
                      //////////////First Name/////////
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 90,
                        ),
                        child: TextFormField(
                          controller: firstNameController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Empty';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: "First Name",
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
                      //////////////Last Name/////////
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 90,
                        ),
                        child: TextFormField(
                          controller: lastNameController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Empty';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: "Last Name",
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
                      /////////////Residence Input/////////
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 90),
                        child: DropdownButtonFormField<String>(
                          value: dropdownValue,
                          icon: const Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                          ),
                          iconSize: 24,
                          elevation: 20,
                          validator: (value) => value == 'Residence'
                              ? 'Please select a residence'
                              : null,
                          isExpanded: true,
                          dropdownColor: Colors.black87,
                          style: const TextStyle(color: Colors.white),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                            print(dropdownValue);
                          },
                          items: <String>[
                            'Residence',
                            'Black',
                            'C & C',
                            'Doran',
                            'Earnhardt',
                            'Eaton',
                            'Gilker',
                            'Gregg',
                            'Hilderbrand',
                            'Holmes',
                            'Korniek',
                            'Kubaki',
                            'McNabb',
                            'Miller',
                            'Ogden',
                            'Perkins',
                            'Pisio',
                            'Young'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 17),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      //////////////Email/////////
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
                      //////////////Password/////////
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
                      //////////////ConfirmPassword/////////
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
                                          firstNameController.text,
                                          lastNameController.text,
                                          dropdownValue.toString(),
                                          passwordController.text,
                                        );

                                        if (result == null) {
                                          print('error registering');
                                        } else {
                                          print('registered');
                                          print(result.uid);
                                        }
                                        Navigator.pop(context);
                                      } on FirebaseAuthException catch (error) {
                                        print(error.message);
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

// String? validateResidence(String? formResidence) {
//   if (formResidence == null || formResidence.isEmpty)
//     return 'Residence is required.';
//   List<String> residences = [
//     'Gilker',
//     'Miller',
//     'Walston',
//     'Cheney',
//     'Earnhardt',
//     'Abney',
//     'Tilton',
//     'McNabb',
//     'Perkins',
//     'Johnson',
//     'Holmes'
//   ];
//   if (residences.contains(formResidence)) {
//     return null;
//   } else {
//     return 'Residence does not exist';
//   }
// }

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
