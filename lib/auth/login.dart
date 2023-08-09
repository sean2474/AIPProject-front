import 'package:flutter/material.dart';
import 'package:front/auth/login_loader_dialog.dart';
import 'package:front/data/data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:front/api_service/authenication.dart';
import 'package:front/data/user_.dart';
import 'package:front/widgets/uploading_snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  late ColorScheme colorScheme;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<State> _loaderDialog = GlobalKey<State>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
    UploadingSnackbar uploadingSnackbar = UploadingSnackbar(context, _scaffoldMessengerKey, "logging in", icon: Icons.login);

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(200),
          child: Stack(
            children: [
              AppBar(
                elevation: 0,
                backgroundColor: colorScheme.secondaryContainer,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(100),
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.background,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                  )
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 60),
                  width: 150,
                  height: 150,
                  child: Image.asset(
                    'assets/school_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: colorScheme.background,
                padding: const EdgeInsets.only(left: 30,),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: colorScheme.secondaryContainer,
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: colorScheme.secondaryContainer,
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ),
                      // log in by account
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            LoginLoaderDialog.show(context, _loaderDialog, colorScheme);
                            User_? user = await Data.apiService.login(_emailController.text, _passwordController.text);
                            Navigator.pop(context);
                            if (user == null) {
                              uploadingSnackbar.showUploadingResult(false);
                            } else {
                              Data.user = user;
                              debugPrint("login success");
                              debugPrint("$user");
                              Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
                            }
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 55,
                          margin: const EdgeInsets.only(left: 40, right: 40, top: 40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colorScheme.secondaryContainer,
                            border: Border.all(
                              color: colorScheme.secondary,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'LOGIN',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colorScheme.secondary,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // sign in with google button
                      GestureDetector(
                        onTap: () async {
                          Future.delayed(Duration(seconds: 2)).then((value) => LoginLoaderDialog.show(context, _loaderDialog, colorScheme));
                          await Authentication.signInWithGoogle(context: context);
                          Navigator.pop(context);
                          FirebaseAuth.instance.authStateChanges().listen((User? user) {
                            if (user != null) {
                              Data.user = User_(id: 0, uid: user.uid, userType: UserType.student, name: '', password: '', email: user.email ?? '');
                              debugPrint("google login success");
                              Navigator.pop(context);
                            } else {
                              uploadingSnackbar.showUploadingResult(false);
                            }
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          height: 55,
                          margin: const EdgeInsets.only(left: 40, right: 40, top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: colorScheme.secondary
                            ),
                            color: colorScheme.secondaryContainer, // change the background color to white
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Spacer(),
                                Image.asset(
                                  'assets/google_login_icon/g-logo.png',
                                  width: 36,
                                ),
                                Spacer(),
                                Text(
                                  'SIGN IN WITH GOOGLE',
                                  style: TextStyle(
                                    color: colorScheme.secondary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Spacer()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
