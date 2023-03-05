import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:what2bake/pages/autorization/register.dart';
import 'dart:async';
import 'package:what2bake/data/globalvar.dart';
import 'package:what2bake/pages/autorization/widgets/AutTextField.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Uri? _initialURI;
  Uri? _currentURI;
  Object? _err;

  StreamSubscription? _streamSubscription;

  Future<void> initURIHandler() async {
    if (!initialURILinkHandled) {
      initialURILinkHandled = true;
      print("Invoked _initURIHandler");
      try {
        final initialURI = await getInitialUri();
        if (initialURI != null) {
          if (!mounted) {
            return;
          }
          print("Initial URI received $initialURI");
          setState(() {
            _initialURI = initialURI;
          });
        } else {
          print("Null Initial URI received");
        }
      } catch(e) {
        print(e.toString());
      }
    }
  }

  void incomingLinkHandler() {
    if (!kIsWeb) {
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }
        print('Received URI: $uri');
        setState(() {
          _currentURI = uri;
          _err = null;
        });
      }, onError: (Object err) {
        if (!mounted) {
          return;
        }
        print('Error occurred: $err');
        setState(() {
          _currentURI = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }

  Future<bool> authUser() async {
    try {
      await pb.collection('users').authWithPassword(
        emailController.text,
        passwordController.text,
      );
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  void initState() {
    initURIHandler();
    incomingLinkHandler();
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/appbarBackground.png',),
              fit: BoxFit.cover,
            )
          ),
          child: Column(
            children: [
              //LOGO
              Padding(
                padding: const EdgeInsets.only(top: 100, bottom: 30),
                  child: SvgPicture.asset(
                      'assets/Logo.svg',
                    width: 350,
                  )
              ),

              //ZALOGUJ SIĘ NAPIS

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                          child: Text(
                              "Zaloguj się",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontFamily: "Lato",
                              fontWeight: FontWeight.bold
                            ),
                          )
                      ),
                    ),

                    //EMAIL BOX

                    AutTextField(
                      controller: emailController,
                      hintText: 'Email',
                      icon: Icons.email_outlined,
                    ),

                    //HASŁO BOX

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: AutTextField(
                            controller: passwordController,
                            hintText: 'Hasło',
                            icon: Icons.lock_outline,
                            obscureText: true,
                          )
                    ),

                    //ZALOGUJ SIĘ BUTTON

                    TextButton(
                        onPressed: () async {
                            if(!await authUser()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Nieprawidłowy email lub hasło',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ));

                            } else {
                              Navigator.popUntil(context, ModalRoute.withName("/settings"));
                            }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                return Colors.amber;
                            },
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30,vertical: 2),
                          child: Text(
                            "Zaloguj się",
                            style: TextStyle(
                                fontSize: 24,
                                color: Color(0xFF232323),
                                fontFamily: "Lato",
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),

                    ),

                    //POLITYKA PRYWATNOŚCI

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: RichText(
                        textAlign: TextAlign.center,
                          text: TextSpan(
                              children: [
                                const TextSpan(text: "Poprzez zalogowanie się akceptujesz \nnaszą "),
                                TextSpan(
                                    text: "Politykę prywatności",
                                    style: const TextStyle(
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = () {
                                      launchUrl(Uri(path: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"));
                                    }
                                ),
                              ]
                          )
                      ),
                    ),

                    //GOOGLE LOGIN

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: GestureDetector(
                        onTap: () async {
                          await launch("http://what2bake.com?code=siema");
                        },
                        child: SvgPicture.asset(
                            "assets/google.svg",
                        width: 60,
                        ),
                      ),
                    ),

                    //REGISTER SUGGESTION

                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Align(
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 18
                              ),
                                children: [
                                  const TextSpan(text: "Nie masz konta? "),
                                  TextSpan(
                                      text: "Zarejestruj się!",
                                      style: const TextStyle(
                                          color: Colors.amber,
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
                  ]
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
