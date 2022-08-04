import 'package:chat_application/main.dart';
import 'package:chat_application/screens/Register_normal_email.dart';
import 'package:chat_application/screens/reset_password.dart';
import 'package:chat_application/services/auth_service.dart';
import 'package:chat_application/utils/kConstants.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String? email;
  String? password;
  String? textHolderEmail = "Email";
  String? textHolderPassword = "Password";

  // need to add if user put a user that is not in the database

  var form = GlobalKey<FormState>();

  login() {
    bool isValid = form.currentState!.validate();

    if (isValid) {
      form.currentState!.save();
      AuthService authService = AuthService();
      print(email);
      return authService.login(email, password).then((value) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login successfully!'),
        ));
        Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
                (route) => false);
      }).catchError((error) {
        FocusScope.of(context).unfocus();
        String message = error.message.toString();
        print(message);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 13),
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Login",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Image.asset("assets/musicBase_logo.png"),
                    const SizedBox(
                      height: 10,
                    ),
                    Form(
                        key: form,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: textHolderEmail,
                                  hintText: textHolderEmail,
                                  hintStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                    width: 5,
                                    color: AppColors.kDarkblack,
                                    style: BorderStyle.solid,
                                  ))),
                              autofocus: true,
                              keyboardType: TextInputType.multiline,
                              validator: (value) {
                                if (value == null) {
                                  return "Please input an email address";
                                } else if (!value.contains('@')) {
                                  return "please input a valid email address";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                email = value;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: textHolderPassword,
                                  hintText: textHolderPassword,
                                  hintStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                    width: 5,
                                    color: AppColors.kDarkblack,
                                    style: BorderStyle.solid,
                                  ))),
                              autofocus: true,
                              keyboardType: TextInputType.multiline,
                              validator: (value) {
                                if (value == null)
                                  return 'Please provide a password.';
                                else if (value.length < 6)
                                  return 'Password must be at least 6 characters.';
                                else
                                  return null;
                              },
                              onSaved: (value) {
                                password = value;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ResetPasswordScreen())),
                              child: Text(
                                "Forgot password?",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            InkWell(
                              child: SignUpContainer(st: "Login"),
                              onTap: () {
                                login();
                              },
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            InkWell(
                              child: RichText(
                                text: RichTextSpan(
                                    one: "Don’t have an account ? ",
                                    two: "Sign Up"),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => RegisterNormalEmail()));
                              },
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // return Scaffold(
    //   body: Form(
    //       key: form,
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.stretch,
    //         children: [
    //           TextFormField(
    //             decoration: InputDecoration(label: Text('Email')),
    //             keyboardType: TextInputType.emailAddress,
    //             validator: (value) {
    //               if (value == null) {
    //                 return "Please input an email address";
    //               } else if (!value.contains('@')) {
    //                 return "please input a valid email address";
    //               } else {
    //                 return null;
    //               }
    //             },
    //             onSaved: (value) {
    //               email = value;
    //             },
    //           ),
    //           TextFormField(
    //             decoration: InputDecoration(label: Text('Password')),
    //             obscureText: true,
    //             validator: (value) {
    //               if (value == null)
    //                 return 'Please provide a password.';
    //               else if (value.length < 6)
    //                 return 'Password must be at least 6 characters.';
    //               else
    //                 return null;
    //             },
    //             onSaved: (value) {
    //               password = value;
    //             },
    //           ),
    //           SizedBox(height: 20),
    //           ElevatedButton(
    //               onPressed: () {
    //                 login();
    //               },
    //               child: Text('Login')),
    //         ],
    //       )),
    // );
  }
}
