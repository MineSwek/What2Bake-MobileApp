import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:what2bake/globalWidgets/appbar.dart';
import 'package:what2bake/pages/settings/widgets/settingsTile.dart';
import 'package:what2bake/data/globalvar.dart' as globals;
import 'package:device_info_plus/device_info_plus.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
    final divider = Container(
      margin: EdgeInsets.fromLTRB(63.w, 0, 20.w, 0),
      child: const Divider(
        color: Color(0xFF303030),
        thickness: 3.0,
      ),
    );

    void navigateToPage(String localisation) {
      if(localisation == "/") {
        globals.pb.authStore.clear();
        const storage = FlutterSecureStorage();
        storage.delete(key: "token");
        globals.isLogged = false;
        Phoenix.rebirth(context);
      }
      Navigator.pushNamed(context, localisation);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          const Appbar(
            searchBarState: false,
            isSettingsPage: true,
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(15.w, 0, 0, 15.h),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);

                          },
                          child: Icon(Icons.arrow_back_rounded, size: 30.sp,),
                        ),
                        Text(
                          " Ustawienia",
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.inversePrimary
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                (!globals.isLogged)
                    ? SettingsTile(
                  callback: navigateToPage,
                  argument: "/login",
                  icon: Icons.login_outlined,
                  title: "Zaloguj się",
                )
                    : SettingsTile(
                      callback: navigateToPage,
                      argument: "/",
                      icon: Icons.login_outlined,
                      title: "Wyloguj się",
                    ),
                divider,
                if (globals.isLogged) SettingsTile(
                    callback: navigateToPage,
                    argument: "/profile",
                    icon: Icons.account_box_outlined,
                    title: "Profil"),
                if(globals.isLogged) divider,
                /*const SettingsTile(
                  localisation: "/notifications",
                  icon: Icons.notifications_none_outlined,
                  title: "Powiadomienia",
                ),
                divider,
                const SettingsTile(
                  localisation: "/tips",
                  icon: Icons.coffee_outlined,
                  title: "Doceń naszą pracę",
                ),
                divider,*/
                SettingsTile(
                  callback: () {},
                  icon: Icons.remove_red_eye_outlined,
                  title: "Zmień motyw",
                  trailing: SizedBox(
                    width: 110.w,
                    child: Row(
                      children: [
                        Icon(Icons.dark_mode_outlined, size: 25.sp, color: Theme.of(context).colorScheme.inversePrimary,),
                        SizedBox(
                          width: 50.w,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Switch(
                                value: globals.theme,
                                inactiveThumbColor: Theme.of(context).colorScheme.inversePrimary,
                                thumbColor: WidgetStateProperty. resolveWith<Color>((Set<WidgetState> states) {
                                  return Theme.of(context).colorScheme.inversePrimary;
                                }),
                                trackOutlineColor: WidgetStateProperty.resolveWith<Color>((states) {

                                  return Theme.of(context).colorScheme.inversePrimary; // Domyślny kolor obramowania
                                }),
                                onChanged: (a) {
                                  if(a == false) {
                                    AdaptiveTheme.of(context).setDark();
                                  } else {
                                    AdaptiveTheme.of(context).setLight();
                                  }

                                  setState(() {
                                    globals.theme = a;
                                  });
                                },

                            ),
                          ),
                        ),
                        Icon(Icons.light_mode_outlined, size: 25.sp, color: Theme.of(context).colorScheme.inversePrimary,)
                      ],
                    ),
                  ),
                ),
                divider,
                SettingsTile(
                  callback: navigateToPage,
                  argument: "/walkthrough",
                  icon: Icons.help_outline,
                  title: "Pomoc",
                ),
                divider,
                SettingsTile(
                  callback: () async {
                    await launchUrl(Uri.parse("https://github.com/MineSwek/What2Bake-MobileApp"), mode: LaunchMode.externalApplication);
                  },
                  icon: Icons.info_outline_rounded,
                  title: "O nas",
                ),
                divider,

                SettingsTile(
                  callback: () async {
                    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                    String email = Uri.encodeComponent("what2bake.inc@gmail.com");
                    String subject = Uri.encodeComponent("Problem techniczny");
                    String body = Uri.encodeComponent("Dane Telefonu: ${androidInfo.manufacturer} ${androidInfo.brand} ${androidInfo.model} \n\nOpis problemu technicznego:\n");
                    Uri url = Uri.parse("mailto:$email?subject=$subject&body=$body");
                    await launchUrl(url)  ;
                  },
                  icon: Icons.bug_report_outlined,
                  title: "Zgłoś problem techniczny",
                ),
                divider,
                SettingsTile(
                  callback: () async {
                    await launchUrl(Uri.parse("https://w2b.poneciak.com/privacy/index.pdf"), mode: LaunchMode.externalApplication);
                  },
                  icon: Icons.privacy_tip_outlined,
                  title: "Polityka Prywatności",
                ),
                divider
              ],
            ),
          ),
        ],
      ),
    );
  }
}