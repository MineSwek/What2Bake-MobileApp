import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:what2bake/pages/authorization/register.dart';
import 'dart:async';
import 'package:what2bake/data/globalvar.dart' as globals;
import 'package:what2bake/globalWidgets/textField.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<bool> authUser() async {
    const storage = FlutterSecureStorage();
    try {
      await globals.pb.collection('users').authWithPassword(
        emailController.text,
        passwordController.text,
      );
      await storage.write(key: "token", value: globals.pb.authStore.token);


      debugPrint(globals.pb.toString());
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: (!globals.theme) ? const AssetImage('assets/backgrounds/appbarBackground.png',) : const AssetImage('assets/backgrounds/lightAppbarBackground.png'),
              fit: BoxFit.cover,
            )
          ),
        ),
        Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10.w, 50.h, 0, 0),
                      child: Icon(Icons.arrow_back_rounded,size: 35.r,),
                    ),
                  ),
                ),
                //LOGO
                Padding(
                  padding: EdgeInsets.only(top: 50.h, bottom: 20.h),
                    child: (!globals.theme) ? SvgPicture.asset('assets/logo/Logo.svg', width: 307.w,)
                        : SvgPicture.asset('assets/logo/lightLogo.svg', width: 307.w)
                ),

                //ZALOGUJ SIĘ NAPIS
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Align(
                            alignment: Alignment.topLeft,
                              child: Text(
                                  "Zaloguj się",
                                style: Theme.of(context).textTheme.titleMedium
                              )
                          ),
                        ),

                        //EMAIL BOX

                        textField(
                          controller: emailController,
                          hintText: 'Email',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            const pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
                            final regex = RegExp(pattern);
                            if(value == null || value.isEmpty) {
                              return "Pole nie może być puste";
                            }
                            if(regex.hasMatch(value)) {
                              return null;
                            } else {
                              return "Proszę wpisać poprawne dane";
                            }

                          },
                        ),

                        //HASŁO BOX

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: textField(
                                controller: passwordController,
                                hintText: 'Hasło',
                                icon: Icons.lock_outline,
                                obscureText: true,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if(value == null || value.isEmpty) {
                                    return "Pole nie może być puste";
                                  } else {
                                    return null;
                                  }
                                },
                              )
                        ),

                        //ZALOGUJ SIĘ BUTTON

                        SizedBox(
                          width: 160.w,
                          height: 50.h,
                          child: ElevatedButton(
                              onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  if(_formKey.currentState!.validate()) {
                                    if(!await authUser()) {
                                      Fluttertoast.showToast(
                                          msg: 'Nieprawidłowy email lub hasło',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );

                                    } else {
                                      globals.isLogged = true;
                                      globals.pbUserData = await globals.pb.collection('users').getOne(globals.pb.authStore.model.id);
                                      Phoenix.rebirth(context);
                                    }

                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                                      (Set<WidgetState> states) {
                                      return Colors.amber;
                                  },
                                ),
                              ),
                              child: (!isLoading)
                              ? Center(
                                child: Text(
                                  "Zaloguj się",
                                  style: Theme.of(context).textTheme.displayLarge
                                ),
                              ) : const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),

                          ),
                        ),

                        //POLITYKA PRYWATNOŚCI

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: RichText(
                            textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.titleSmall?.color
                                ),
                                  children: [
                                    const TextSpan(text: "Poprzez zalogowanie się akceptujesz \nnaszą "),
                                    TextSpan(
                                        text: "Politykę prywatności",
                                        style: TextStyle(
                                            color: Theme.of(context).colorScheme.secondary,
                                            fontWeight: FontWeight.bold
                                        ),
                                        recognizer: TapGestureRecognizer()..onTap = () {
                                          launchUrl(Uri.parse("https://what2bake.com/privacy/"), mode: LaunchMode.externalApplication);
                                        }
                                    ),
                                  ]
                              )
                          ),
                        ),

                        //GOOGLE LOGIN

                        /*Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          child: GestureDetector(
                            onTap: () async {
                              await launchUrl(Uri.parse(""), mode: LaunchMode.externalApplication);
                            },
                            child: SvgPicture.asset(
                                "assets/google.svg",
                            width: 60.w,
                            ),
                          ),
                        ),*/
                      ]
                    ),
                  ),
                ),


              ],
            ),
          ),
          bottomNavigationBar: Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: Theme.of(context).textTheme.titleSmall,
                      children: [
                        const TextSpan(text: "Nie masz konta? "),
                        TextSpan(
                            text: "Zarejestruj się!",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => const Register(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                  transitionDuration: const Duration(milliseconds: 400),
                                ),
                              );
                            }
                        ),
                      ]
                  )
              ),
            ),
        ),
      ],
    );
  }
}