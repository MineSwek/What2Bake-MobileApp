import 'package:flutter/material.dart';
import 'package:what2bake/pages/favorites/favorites.dart';
import 'package:what2bake/pages/home/home.dart';
import 'package:what2bake/pages/recipes/recipes.dart';
import 'package:what2bake/pages/ingredients/ingredients.dart';
import 'package:what2bake/pages/profile/profile.dart';
import 'package:what2bake/pages/autorization/login.dart';
import 'package:what2bake/pages/autorization/register.dart';
import 'package:what2bake/pages/settings/settings.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:what2bake/globalWidgets/appbar.dart';

void main() async {
  runApp(MaterialApp(
    initialRoute: "/",
    routes: {
      "/": (context) => const MainWindow(),
      "/profile": (context) => const Profile(),
      "/login": (context) => const Login(),
      "/register": (context) => const Register(),
      "/settings": (context) => const Settings(),
    },
    theme: ThemeData.dark(),
  ));
}

class MainWindow extends StatefulWidget {
  const MainWindow({Key? key}) : super(key: key);

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> with SingleTickerProviderStateMixin {
  late Future recipes;
  late Future ingredients;
  bool _showFirst = true;
  ScrollController scrollController = ScrollController();
  int _selectedIndex = 0;
  final _pageController = PageController();

  late List<Widget> _pages;

  void _onPageChanged() {
    setState(() {
      _selectedIndex = _pageController.page!.round();
    });
  }
  @override
  void initState() {
    _pageController.addListener(_onPageChanged);

    _pages = [
      const Home(),
      const Recipes(),
      const Ingredients(),
      const Favorites(),
    ];

    super.initState();

  }
  bool iconstate = true;
  bool buttonvis = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children:  [
            GestureDetector(
              onVerticalDragEnd: (details) {
                if(details.velocity.pixelsPerSecond.distance > 50 && details.velocity.pixelsPerSecond.direction < -1) {
                  setState(() {
                    _showFirst = !_showFirst;
                    Future.delayed(const Duration(seconds: 1));
                    buttonvis = !buttonvis;
                  });
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                height: _showFirst ? 203 : 30,
                width: double.infinity,
                child: _showFirst ? const SizedBox(height: 203, child: Appbar()) : const SizedBox(height: 203, child: Appbar()),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              height: buttonvis ? 45 : 0,
              width: double.infinity,
              child: buttonvis ? Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/appbarBackground.png',),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                    color: const Color(0xFF232323),
                    width: 0
                  )
                ),
                child: SizedBox(
                  height: 40,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _showFirst = !_showFirst;
                        buttonvis = !buttonvis;
                      });
                    },
                    icon: const Icon(Icons.arrow_downward, color: Colors.white,),
                  ),
                ),
              ) : Container(
                    width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/appbarBackground.png',),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: const Color(0xFF232323),
                          width: 0
                        )
                      ),
                ),
            ),
            Flexible(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: PageView(
                  controller: _pageController,
                  children: _pages,
                ),
              ),
            ),
          ],
        ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/house.svg"),
              label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/cookbook.svg"),
              label: 'Przepisy',
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/breakfast.svg"),
              label: 'Składniki',
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/favorite.svg"),
              label: 'Ulubione',
          ),
        ],

        currentIndex: _selectedIndex,
        onTap: (int index) {
          _pageController.animateToPage(index, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF272727),
        selectedLabelStyle: GoogleFonts.montserrat(
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          )
        ),
        showUnselectedLabels: false,
        selectedItemColor: Colors.amber,
        unselectedItemColor: const Color(0xFFBBBBBB),
      ),
    );

  }
}




