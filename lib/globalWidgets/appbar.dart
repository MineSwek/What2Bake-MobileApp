import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:what2bake/data/globalvar.dart' as globals;

class Appbar extends StatefulWidget {
  final bool searchBarState;
  final bool isSettingsPage;
  const Appbar({super.key, this.searchBarState = true, this.isSettingsPage = false});

  @override
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  String avatImg = "";
  void checkAvat() async {
    setState(() {

    });
    try {
      if(globals.isLogged && globals.pbUserData.data['avatar'] != "null" && globals.pbUserData.data['avatar'] != '') {
        avatImg = "https://w2b.poneciak.com/pb/api/files/${globals.pbUserData.collectionId}/${globals.pbUserData.id}/${globals.pbUserData.data['avatar']}";
      }
      if(mounted) setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    checkAvat();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: (!globals.theme) ? const AssetImage('assets/backgrounds/appbarBackground.png',) : const AssetImage('assets/backgrounds/lightAppbarBackground.png'),
          fit: BoxFit.cover
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 45.h, 12.w, 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (!globals.theme) ? SvgPicture.asset('assets/logo/Logo.svg', width: 200.w,) : SvgPicture.asset('assets/logo/lightLogo.svg', width: 200.w) ,
            GestureDetector(
              onTap: () {
                if(!widget.isSettingsPage) {
                  Navigator.pushNamed(context, "/settings");
                }
              },
              child: Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    CircleAvatar(
                      radius: 30.r,
                      backgroundColor: Theme.of(context).colorScheme.onSurface,
                      child: CircleAvatar(
                        radius: 25.r,
                        backgroundImage: (avatImg != "") ? NetworkImage(avatImg) : const AssetImage("assets/icon/userIcon.png") as ImageProvider,
                        backgroundColor: const Color(0xFF161c52),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.onSurface,
                        radius: 8.r,
                        child: Icon(
                          Icons.settings,
                          size: 15.r,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ),
                  ]
              ),
            ),
          ],
        )
      ),
    );
    
  }
}