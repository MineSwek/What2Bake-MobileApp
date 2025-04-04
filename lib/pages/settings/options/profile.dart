import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:what2bake/data/globalvar.dart' as globals;
import 'package:what2bake/globalWidgets/textField.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  XFile? image;

  Future getImage() async {
    var img = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      image = img;
    });
  }


  Future<bool> updateUserData() async {
    try {
      List<MultipartFile> files = [];
      final Map<String, dynamic> body = <String, dynamic>{
        "username": usernameController.text,
        "emailVisibility": true,
        "name": usernameController.text,
        "roles": [
          "ROLE_USER"
        ]
      };
      if(passwordController.text != "" && oldPasswordController.text != "") {
        body.addAll({"oldPassword": oldPasswordController.text, "password": passwordController.text, "passwordConfirm": passwordController.text,});
      }
      if(image != null) {
        files.add(await MultipartFile.fromPath('avatar', image!.path, filename: image!.path.split("/").last)) ;
      }

      await globals.pb.collection('users').update(globals.pb.authStore.model.id, body: body, files: files);

      if(passwordController.text != "" && oldPasswordController.text != "") {
        globals.pb.authStore.clear();
        const storage = FlutterSecureStorage();
        storage.delete(key: "token");
        globals.isLogged = false;
      }
      Phoenix.rebirth(context);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }



  }

  @override
  void initState() {
    usernameController.text = globals.pbUserData.data['username'];
    emailController.text = globals.pbUserData.data['email'];
    super.initState();
  }

  var isLoading = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
            Container(
              height: ScreenUtil().screenHeight,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: (!globals.theme) ? const AssetImage('assets/backgrounds/appbarBackground.png',) : const AssetImage('assets/backgrounds/lightAppbarBackground.png'),
                    fit: BoxFit.cover,
                  )
              ),
            ),
            SingleChildScrollView(
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 200.h),
                    child: Container(
                      color: Theme.of(context).colorScheme.surface,
                      width: ScreenUtil().screenWidth,
                      height: 700.h,
                    ),
                  ),
                  Column(
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

                      Align(
                        alignment: Alignment.center,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: getImage,
                                child: CircleAvatar(
                                  backgroundColor: Theme.of(context).colorScheme.onSurface,
                                  radius: 120.r,
                                  child: CircleAvatar(
                                    radius: 110.r,
                                    backgroundImage: (image == null) ? ((globals.pbUserData.data['avatar'] != '') ? NetworkImage("http://pb.what2bake.com/api/files/${globals.pbUserData.collectionId}/${globals.pbUserData.id}/${globals.pbUserData.data['avatar']}") : const AssetImage("assets/icon/userIcon.png") as ImageProvider) :
                                    Image.file(File(image!.path)).image,
                                  ),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(top: 10.h),
                                child: Text(
                                    globals.pbUserData.data['username'],
                                  style: Theme.of(context).textTheme.headlineLarge,
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
                                child: Column(
                                  children: [
                                    textField(
                                      controller: usernameController,
                                      hintText: "Nazwa użytkownika",
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
                                    Padding(
                                      padding: EdgeInsets.only(top: 20.h),
                                      child: textField(
                                          controller: emailController,
                                          hintText: "Email",
                                          icon: Icons.mail_outline,
                                          keyboardType: TextInputType.emailAddress,
                                          locked: true,
                                          validator: (value) {
                                            return null;
                                          } ,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20.h),
                                      child: textField(
                                          controller: oldPasswordController,
                                          hintText: "Wprowadź stare hasło",
                                          icon: Icons.lock_outline,
                                          keyboardType: TextInputType.visiblePassword,
                                          validator: (value) {
                                            return null;
                                          },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20.h),
                                      child: textField(
                                          controller: passwordController,
                                          hintText: "Wprowadź nowe hasło",
                                          icon: Icons.lock_outline,
                                          keyboardType: TextInputType.visiblePassword,
                                          validator: (value) {
                                            if((value != null) && (value.length < 6 || value.length > 72)) {
                                              return "Hasło musi posiadać pomiędzy 6 a 72 znaki";
                                            } else {
                                              return null;
                                            }
                                          },
                                      ),
                                    ),


                                  ]
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(bottom: 5.h),
                                child: SizedBox(
                                  width: 200.w,
                                  height: 50.h,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      if(_formKey.currentState!.validate()) {
                                        if(!await updateUserData()) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Nieprawidłowe dane',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18.sp
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ));

                                        } else {
                                          Navigator.pop(context);
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
                                          "Zatwierdź",
                                          style: Theme.of(context).textTheme.displayLarge
                                      ),
                                    ) : const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),

                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ]
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
