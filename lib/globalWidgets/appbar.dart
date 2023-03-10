import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:what2bake/data/globalvar.dart';

class Appbar extends StatefulWidget {
  final bool searchBarState;
  final bool isSettingsPage;
  const Appbar({this.searchBarState = true, this.isSettingsPage = false});

  static const List<String> _kOptions = <String>[
    'jeden',
    'dwa',
    'trzy',
    'cztery',
    'pięć',
    'sześć',
    'siedem',
    'osiem',
    'dziewięć',
    'dziesięć'
  ];

  @override
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  String avatImg = "https://cdn.cloudflare.steamstatic.com/steamcommunity/public/images/items/728880/77c1d34497f69650959e1e48184f228a9f5f8b10.gif";

  void checkAvat() async {
    if(pb.authStore.isValid) {
      final record = await pb.collection('users').getOne(pb.authStore.model.id);
      if(record.data['avatar'] != "") {
        avatImg = "http://pb.what2bake.com/api/files/${record.collectionId}/${record.id}/${record.data['avatar']}";
      }
    } else {
      avatImg = "https://cdn.cloudflare.steamstatic.com/steamcommunity/public/images/items/728880/77c1d34497f69650959e1e48184f228a9f5f8b10.gif";
    }
    setState(() {});
  }

  @override
  void initState() {
    pb.authStore.onChange.listen((event) {
      print("changed");
      setState(() {

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkAvat();
    final topPart = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset('assets/Logo.svg'),
        GestureDetector(
          onTap: () {
            if(!widget.isSettingsPage) {
              Navigator.pushNamed(context, "/settings");
            }
          },
          child: CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFF414141),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(avatImg),
            ),
          ),
        ),
      ],
    );

    final children = (widget.searchBarState) ? [
      topPart,
      Container(
        height: 47,
        decoration: BoxDecoration(
          color: const Color(0xFF383838),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const SearchBar(Appbar._kOptions),
      ),
    ] : [
      topPart
    ];


    return AppBar(
      title: Column(
        children: children
      ),
      toolbarHeight: 156,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/appbarBackground.png',),
            fit: BoxFit.cover,
          ),
         ),
      ),
      automaticallyImplyLeading: false,
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar(this._kOptions, {super.key});

  final List<String> _kOptions;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue == '') {
            return const Iterable<String>.empty();
          }
          return _kOptions.where((String option) {
            return option.contains(textEditingValue.text.toLowerCase());
          });
        },
        fieldViewBuilder: ( //Style obszaru wpisywania
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted
        ) {
          return Row(
            children: [
              const Expanded(
                flex: 1,
                child: Icon(
                  Icons.search,
                  size: 38,
                ),
              ),
              Expanded(
                flex: 6,
                child: TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Wprowadź odpowiednie argumenty',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Color(0xFF959595),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
         );
        },
        onSelected: (String selection) {
          debugPrint(selection);
        },
        optionsViewBuilder: (
            BuildContext context,
            AutocompleteOnSelected<String> onSelected,
            Iterable<String> options
        ) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFC393838),
                  ),
                  height: min(options.length * 45, 255),
                  width: MediaQuery.of(context).size.width - 32,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);

                      return GestureDetector(
                        onTap: () {
                          onSelected(option);
                        },
                        child: SizedBox(
                          height: 40,
                          child: ListTile(
                            title: Text(
                                '● $option',
                                style: const TextStyle(color: Colors.white)
                            )
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ),
          );
          },
      ),
    );
  }
}
