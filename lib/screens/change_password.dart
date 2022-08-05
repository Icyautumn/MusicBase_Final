
import 'package:chat_application/screens/login_form.dart';
import 'package:chat_application/services/auth_service.dart';
import 'package:chat_application/utils/kConstants.dart';
import 'package:flutter/material.dart';

class changePasswordScreen extends StatefulWidget {
  static String routeName = '/reset-password';

  @override
  State<changePasswordScreen> createState() => _changePasswordScreenState();
}

class _changePasswordScreenState extends State<changePasswordScreen> {
  String? email;
  var form = GlobalKey<FormState>();
  String? textHolderCurrentPassword = "current Password";
  String? textHolderNewPassword = "New Password";
  String? textHoldercfmNewPassword = "Confirm Password";

  reset() {
    bool isValid = form.currentState!.validate();

    if (isValid) {
      form.currentState!.save();

      AuthService authService = AuthService();

      return authService.forgotPassword(email).then((value) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please check your email for to reset you password!'),
        ));
        Navigator.of(context).pop();
      }).catchError((error) {
        FocusScope.of(context).unfocus();
        String message = error.toString();
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
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Text(
            "Reset Password",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
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
                                  labelText: textHolderCurrentPassword,
                                  hintText: textHolderCurrentPassword,
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
                            const SizedBox(height: 10),
                            InkWell(
                              child: SignUpContainer(st: "Reset"),
                              onTap: () {
                                reset();
                              },
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            InkWell(
                              child: RichText(
                                text: RichTextSpan(
                                    one: "Have an account ? ",
                                    two: "Login"),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginForm()));
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
  }
}
