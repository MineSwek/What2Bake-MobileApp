import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:what2bake/pages/register.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'dart:async';
import 'package:what2bake/data/globalvar.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<bool> authUser() async {
    try {
      await pb.collection('users').authWithPassword(
        emailController.text,
        passwordController.text,
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> authGoogle() async {
    try {

        final result = await pb.collection('users').listAuthMethods();
        const callbackUrlScheme = 'w2b.com';
        const googleClientId = '456269539101-a3gse15pqgmfqpepp6a66cl5jds52cuh';
        const redirectUri = 'http://192.168.8.115.nip.io:8080/';

        final url = Uri.https('accounts.google.com', '/o/oauth2/auth', {
          'response_type': 'code',
          'client_id': googleClientId,
          'redirect_uri': redirectUri,
          'scope': 'email',
        });

        for (var element in result.authProviders) {
          if (element.name == "google") {
            final result = await FlutterWebAuth2.authenticate(
                url: element.authUrl + redirectUri,
                callbackUrlScheme: callbackUrlScheme
            );
            final code = Uri
                .parse(result)
                .queryParameters['code'];
            print(code);
            print("AuthURL: ${element.authUrl}");
            await pb.collection('users').authWithOAuth2(
              'google',
              code!,
              element.codeVerifier,
              "https://w2b.com",

            );
          }
        }

        print(pb.authStore.token);


      return true;
    } catch(e) {
        print(e);
        return false;
      }
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
              Padding(
                padding: const EdgeInsets.only(top: 100, bottom: 30),
                  child: SvgPicture.asset(
                      'assets/Logo.svg',
                    width: 350,
                  )
              ),
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
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF393838),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 2, 0, 2),
                        child: TextFormField(
                          controller: emailController,
                            decoration: const InputDecoration(
                              hintText: "Email",
                              hintStyle: TextStyle(
                                fontFamily: "Lato",
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF616161),
                              ),
                              suffixIcon: Icon(
                                Icons.email_outlined,
                                color: Color(0xFF616161),
                              ),
                              border: InputBorder.none,
                          ),
                          cursorColor: Colors.white,
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Color(0xFF393838),
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 2, 0, 2),
                          child: TextFormField(
                            controller: passwordController,
                            decoration: const InputDecoration(
                              hintText: "Hasło",
                              hintStyle: TextStyle(
                                fontFamily: "Lato",
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF616161),
                              ),
                              suffixIcon: Icon(
                                Icons.lock_outline,
                                color: Color(0xFF616161),
                              ),
                              border: InputBorder.none,
                            ),
                            cursorColor: Colors.white,
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500
                            ),
                            obscureText: true,
                          ),
                        ),
                      ),
                    ),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: GestureDetector(
                        onTap: () {
                          authGoogle();
                        },
                        child: SvgPicture.asset(
                            "assets/google.svg",
                        width: 60,
                        ),
                      ),
                    ),
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
                                            pageBuilder: (context, animation, secondaryAnimation) => Register(),
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
