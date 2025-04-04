import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:what2bake/pages/authorization/login.dart';
import 'package:what2bake/globalWidgets/textField.dart';
import 'package:what2bake/data/globalvar.dart' as globals;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  final secondPasswordController = TextEditingController();
  bool isLoading = false;

  Future<bool> registerUser() async {
    final body = <String, dynamic>{
      "username": loginController.text,
      "email": emailController.text,
      "emailVisibility": true,
      "password": passwordController.text,
      "passwordConfirm": secondPasswordController.text,
      "name": loginController.text,
      "roles": [
        "ROLE_USER"
      ]
    };
    try {
      await globals.pb.collection('users').create(body: body);
      await globals.pb.collection('users').requestVerification(emailController.text);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }

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
                    padding: EdgeInsets.only(top: 50.h, bottom: 30.h),
                    child: (!globals.theme) ? SvgPicture.asset('assets/logo/Logo.svg', width: 307.w,)
                        : SvgPicture.asset('assets/logo/lightLogo.svg', width: 307.w)
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Form(
                    key: _formKey,
                    child: Column(
                        children: [

                          //ZAREJESTRUJ SIĘ NAPIS

                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Zarejestruj się",
                                  style: Theme.of(context).textTheme.titleMedium
                                )
                            ),
                          ),

                          //LOGIN BOX

                          Padding(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: textField(
                              controller: loginController,
                              hintText: "Login",
                              icon: Icons.person_outline,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if(value == null || value.isEmpty) {
                                  return "Pole nie może być puste";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),

                          //EMAIL BOX

                          textField(
                              controller: emailController,
                              hintText: "Email",
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
                              hintText: "Hasło",
                              icon: Icons.lock_outline,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {

                                if(value == null || value.isEmpty) {
                                  return "Pole nie może być puste";
                                } else if(value.length < 6 || value.length > 72) {
                                  return "Hasło musi posiadać pomiędzy 6 a 72 znaki";
                                } else {
                                  return null;
                                }
                              },
                            )
                          ),

                          //POWTÓRZ HASŁO BOX

                          textField(
                              controller: secondPasswordController,
                              hintText: "Powtórz hasło",
                              icon: Icons.lock_outline,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if(value == null || value.isEmpty) {
                                return "Pole nie może być puste";
                              } else if(value.length < 6 || value.length > 72) {
                                return "Hasło musi posiadać pomiędzy 6 a 72 znaki";
                              } else {
                                return null;
                              }
                            },
                          ),

                          //ZAREJESTRUJ SIĘ BUTTON

                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: SizedBox(
                              width: 200.w,
                              height: 50.h,
                              child: ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  if(_formKey.currentState!.validate()) {
                                    if(!await registerUser()) {
                                      Fluttertoast.showToast(
                                          msg: 'Nieprawidłowe dane do rejestracji.',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );

                                    } else {
                                      Navigator.popUntil(context, ModalRoute.withName("/settings"));
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
                                    "Zarejestruj się",
                                    style: Theme.of(context).textTheme.displayLarge
                                  ),
                                ) : const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),

                              ),
                            ),
                          ),

                          //POLITYKA PRYWATNOŚCI

                          RichText(
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

                        ]
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: Theme.of(context).textTheme.titleSmall,
                    children: [
                      const TextSpan(text: "Masz już konto? "),
                      TextSpan(
                          text: "Zaloguj się!",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            Navigator.pop(context, PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => const Login(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              transitionDuration: const Duration(milliseconds: 400),
                            ),);

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