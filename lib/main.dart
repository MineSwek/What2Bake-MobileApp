import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:what2bake/pages/favorites/favorites.dart';
import 'package:what2bake/pages/home/home.dart';
import 'package:what2bake/pages/recipes/recipes.dart';
import 'package:what2bake/pages/ingredients/ingredients.dart';
import 'package:what2bake/pages/settings/options/profile.dart';
import 'package:what2bake/pages/authorization/login.dart';
import 'package:what2bake/pages/authorization/register.dart';
import 'package:what2bake/pages/settings/settings.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:what2bake/globalWidgets/appbar.dart';
import 'package:what2bake/data/globalvar.dart' as globals;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:what2bake/data/themes.dart';
import 'package:what2bake/pages/walktrough/walkthrough.dart';

late bool isWalkthrough;

Future<void> checkLogin() async {
  const storage = FlutterSecureStorage();
  isWalkthrough = await storage.read(key: "walkthrough") != null;
  if(await storage.read(key: "token") != null) {
    try {
      String? token = await storage.read(key: "token");
      globals.pb.authStore.save(token!, null);
      await globals.pb.collection("users").authRefresh();
      storage.write(key: "token", value: globals.pb.authStore.token);
      globals.isLogged = true;
      globals.pbUserData = await globals.pb.collection('users').getOne(globals.pb.authStore.model.id);
    } catch (e) {
      globals.isLogged = false;
      globals.pbUserData = RecordModel();
      debugPrint(e.toString());
    }
  } else {
    try {
      globals.isLogged = false;
      globals.pbUserData = RecordModel();
    } catch (e) {
      debugPrint(e.toString());
    }

  }

}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  globals.theme = (savedThemeMode == AdaptiveThemeMode.light);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await checkLogin();

  runApp(Phoenix(
      child: ScreenUtilInit(
        designSize: const Size(393, 873),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
              return AdaptiveTheme(
                light: lightTheme(),
                dark: darkTheme(),
                initial: savedThemeMode ?? AdaptiveThemeMode.dark,
                builder: (theme, darkTheme) => Portal(
                  child: MaterialApp(
                    initialRoute: "/",
                    darkTheme: darkTheme,
                    theme: theme,
                    routes: {
                      "/": (context) => const MainWindow(),
                      "/profile": (context) => const Profile(),
                      "/login": (context) => const Login(),
                      "/register": (context) => const Register(),
                      "/settings": (context) => const Settings(),
                      "/walkthrough": (context) => const Walkthrough(),
                    },
                  ),
                ),
              );
        },
      ),
  ));
  FlutterNativeSplash.remove();
}

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow>  {
  late Future recipes;
  late Future ingredients;
  ScrollController scrollController = ScrollController();
  int _selectedIndex = 0;
  final _pageController = PageController();


  late List<Widget> _pages;

  void _onPageChanged() {
    setState(() {
      _selectedIndex = _pageController.page!.round();
    });
  }

  void refreshCallback() {
    setState(() {

    });
  }

  @override
  void initState() {
    checkLogin().then((value) => setState(() {}));
    _pageController.addListener(_onPageChanged);
    _pages = [
      Home(pageViewController: _pageController,),
      Recipes(pageViewController: _pageController),
      Ingredients(pageViewController: _pageController),
      Favorites(pageViewController: _pageController,),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (isWalkthrough) ? Scaffold(
      body: Column(
        children: [
          const Appbar(searchBarState: false,), //MUST BE WITHOUT CONST
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
        selectedItemColor: Colors.amber,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/navbarIcons/house.svg", width: 28.w,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/navbarIcons/cookbook.svg", width: 28.w,),
            label: 'Przepisy',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/navbarIcons/breakfast.svg", width: 29.w,),
            label: 'Składniki',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/navbarIcons/favorite.svg", width: 28.w,),
            label: 'Ulubione',
          ),
        ],

        currentIndex: _selectedIndex,
        onTap: (int index) {
          _pageController.animateToPage(
              index, duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut);
        },
        unselectedLabelStyle: TextStyle(
            fontSize: Theme.of(context).textTheme.displaySmall?.fontSize,
            fontWeight: Theme.of(context).textTheme.displaySmall?.fontWeight,
            decorationColor: Theme.of(context).textTheme.displaySmall?.color
        ),
        selectedLabelStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: Theme.of(context).textTheme.displaySmall?.fontWeight,
            decorationColor: Theme.of(context).colorScheme.secondary
        ),

        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    ) : const Walkthrough();
  }
}



