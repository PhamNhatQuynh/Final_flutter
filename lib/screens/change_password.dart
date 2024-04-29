import 'package:final_quizlet_english/services/auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  var obscureOldPassword = true;
  var obscureNewPassword = true;
  var obscureConfirmPassword = true;
  TextEditingController _oldPasswordEditingController = TextEditingController();
  TextEditingController _newPasswordEditingController = TextEditingController();
  TextEditingController _confirmNewPasswordEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Change Password"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/user.png'),
                      radius: 50,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      TextFormField(
                        obscureText: obscureOldPassword,
                        controller: _oldPasswordEditingController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100)),
                            labelText: 'Old password',
                            hintText: "Enter your old password",
                            prefixIcon: Icon(Icons.password),
                            suffixIcon: Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: IconButton(
                                    icon: (obscureOldPassword)
                                        ? Icon(Icons.remove_red_eye)
                                        : Icon(Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        obscureOldPassword =
                                            !obscureOldPassword;
                                      });
                                    }))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Old password is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        obscureText: obscureNewPassword,
                        controller: _newPasswordEditingController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100)),
                            labelText: 'New password',
                            hintText: "Enter your new password",
                            prefixIcon: Icon(Icons.password),
                            suffixIcon: Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: IconButton(
                                icon: obscureNewPassword
                                    ? Icon(Icons.remove_red_eye)
                                    : Icon(Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    obscureNewPassword = !obscureNewPassword;
                                  });
                                },
                              ),
                            )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'New password is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        obscureText: obscureConfirmPassword,
                        controller: _confirmNewPasswordEditingController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100)),
                            labelText: 'Confirm new password',
                            hintText: "Enter your new password",
                            prefixIcon: Icon(Icons.password),
                            suffixIcon: Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: IconButton(
                                    icon: (obscureConfirmPassword)
                                        ? Icon(Icons.remove_red_eye)
                                        : Icon(Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        obscureConfirmPassword =
                                            !obscureConfirmPassword;
                                      });
                                    }))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirm new password is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          minimumSize: Size(200, 50),
                        ),
                        child: const Text(
                          'Change',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            //
                            AuthMethods().changePassword(_newPasswordEditingController.text);
                          }
                        },
                      ),)
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
