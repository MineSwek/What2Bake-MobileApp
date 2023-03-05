import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:what2bake/pages/autorization/login.dart';
import 'package:what2bake/pages/autorization/widgets/AutTextField.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final secondPasswordController = TextEditingController();

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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                    children: [

                      //ZAREJESTRUJ SIĘ NAPIS

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Zarejestruj się",
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
                          hintText: "Email",
                          icon: Icons.email_outlined,
                      ),

                      //HASŁO BOX

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: AutTextField(
                          controller: passwordController,
                          hintText: "Hasło",
                          icon: Icons.lock_outline,
                          obscureText: true,
                        )
                      ),

                      //POWTÓRZ HASŁO BOX

                      AutTextField(
                          controller: secondPasswordController,
                          hintText: "Powtórz hasło",
                          icon: Icons.lock_outline,
                          obscureText: true,
                      ),

                      //ZAREJESTRUJ SIĘ BUTTON

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: TextButton(
                          onPressed: () {
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
                              "Zarejestruj się",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Color(0xFF232323),
                                  fontFamily: "Lato",
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),

                        ),
                      ),

                      //POLITYKA PRYWATNOŚCI

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
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
                        padding: const EdgeInsets.only(top: 120),
                        child: Align(
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  style: const TextStyle(
                                      fontSize: 18
                                  ),
                                  children: [
                                    const TextSpan(text: "Masz już konto? "),
                                    TextSpan(
                                        text: "Zaloguj się!",
                                        style: const TextStyle(
                                            color: Colors.amber,
                                            fontWeight: FontWeight.bold
                                        ),
                                        recognizer: TapGestureRecognizer()..onTap = () {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation, secondaryAnimation) => const Login(),
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
