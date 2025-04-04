import 'dart:math';
import 'package:unorm_dart/unorm_dart.dart' as unorm;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:what2bake/services/model.dart';

class OptionProduct {
  final String name;
  final int id;
  OptionProduct(this.name,  this.id);
}

class SearchBarWidget extends StatefulWidget {
  Function callback;
  SearchBarWidget({super.key, required this.allProductsData, required this.pressedProducts, required this.callback});

  final List<Product> allProductsData;
  final List<int> pressedProducts;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final List<OptionProduct> optionProducts = [];

  @override
  void initState() {
    super.initState();
    for(var x in widget.allProductsData) {
      if(widget.pressedProducts.contains(x.id)) {
        OptionProduct temp = OptionProduct(x.name, x.id);
        optionProducts.add(temp);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          return optionProducts.map((product) => product.name).toList().where((String option) {
            return option.contains(unorm.nfkd(textEditingValue.text.toLowerCase()));
          });
        },
        fieldViewBuilder: ( //Style obszaru wpisywania
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted
            ) {
          return Container(
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(15.sp),
               color: Theme.of(context).colorScheme.surface,
             ),
             child: Row(
               children: [
                 Expanded(
                   flex: 1,
                     child: Icon(
                       Icons.search,
                       color: Theme.of(context).disabledColor,
                       size: 28.w,
                     ),
                 ),
                 Expanded(
                   flex: 6,
                   child: TextField(
                     controller: textEditingController,
                     focusNode: focusNode,
                     style: TextStyle(
                       color: Theme.of(context).textTheme.titleSmall?.color,
                       fontSize: 15.sp,
                     ),
                     decoration: InputDecoration(
                       hintText: 'Wprowadź odpowiednie argumenty',
                       border: InputBorder.none,
                       hintStyle: Theme.of(context).textTheme.displaySmall
                     ),
                   ),
                 ),
               ],
             ),
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
            child: Padding(
              padding: EdgeInsets.all(1.h),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  height: min(options.length * 55.h, 180.h),
                  width: 300.w,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          onSelected(option);
                        },
                        child: SizedBox(
                          height: 60.h,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(24.w, 0, 0, 0),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                    onTap: () {
                                      widget.callback(optionProducts.firstWhere((element) => element.name == option).id, option);
                                      Focus.of(context).unfocus();
                                    },
                                    minVerticalPadding: 0,
                                    title: Text(
                                        '${option[0].toUpperCase()}${option.substring(1)}',
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 16.sp),
                                    )
                                ),
                              ),
                              Divider(height: 0, thickness: 2.sp,)
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}