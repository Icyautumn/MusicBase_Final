import 'package:chat_application/screens/login_form.dart';
import 'package:chat_application/services/auth_service.dart';
import 'package:chat_application/utils/kConstants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class changePasswordScreen extends StatefulWidget {
  @override
  State<changePasswordScreen> createState() => _changePasswordScreenState();
}

class _changePasswordScreenState extends State<changePasswordScreen> {
  String? currentPassword;
  String? newPassword;
  String? cfmnewPassword;
  var form = GlobalKey<FormState>();
  String? textHolderCurrentPassword = "current Password";
  String? textHolderNewPassword = "New Password";
  String? textHoldercfmNewPassword = "Confirm Password";

  changePassword() async {
    bool isValid = form.currentState!.validate();

    if (isValid) {
      final currentUser = await FirebaseAuth.instance.currentUser;

      AuthService authService = AuthService();

      if (cfmnewPassword == newPassword) {
        try {
          await currentUser!.updatePassword(newPassword!);
          FocusScope.of(context).unfocus();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('password changed'),
          ));
          Navigator.of(context).pop();
        } catch (error) {
          FocusScope.of(context).unfocus();
          String message = error.toString();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(message),
          ));
        }
      } else{
        showDialog(
          context: context, 
          builder: (context) {
            // let user know to input image
            return AlertDialog(
              title: Text('password'),
              content: Text("Password does not match"),
              actions: [
                TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text('ok'))
              ],
            );
        });
      }

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
            "change Password",
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
                                  return "Please input your current password";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                currentPassword = value;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: textHolderNewPassword,
                                  hintText: textHolderNewPassword,
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
                                  return "Please input your new password";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                newPassword = value;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: textHoldercfmNewPassword,
                                  hintText: textHoldercfmNewPassword,
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
                                  return "Please confirm you new password";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                cfmnewPassword = value;
                              },
                            ),
                            const SizedBox(height: 10),
                            InkWell(
                              child: SignUpContainer(st: "Change Password"),
                              onTap: () {
                                changePassword();
                              },
                            ),
                            const SizedBox(
                              height: 50,
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
