import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {


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
                padding: const EdgeInsets.only(top: 150, bottom: 30),
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
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        child: TextField(
                            decoration: InputDecoration(
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
                          style: TextStyle(
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
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                          child: TextField(
                            decoration: InputDecoration(
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
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                            print("works");
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                return Colors.amber;
                            },
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40,vertical: 5),
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
                                      launch("https://www.youtube.com/watch?v=dQw4w9WgXcQ");
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
                                  const TextSpan(text: "Nie masz konta? "),
                                  TextSpan(
                                      text: "Zarejestruj się!",
                                      style: const TextStyle(
                                          color: Colors.amber,
                                          fontWeight: FontWeight.bold
                                      ),
                                      recognizer: TapGestureRecognizer()..onTap = () {
                                        launch("https://www.youtube.com/watch?v=dQw4w9WgXcQ");
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
