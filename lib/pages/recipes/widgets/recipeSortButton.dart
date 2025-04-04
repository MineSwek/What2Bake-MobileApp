import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecipeSortButton extends StatefulWidget {
  bool isMenuOpen;
  final Function _refresh;
  final Function _changeSort;
  RecipeSortButton(this.isMenuOpen, this._refresh, this._changeSort, {super.key});

  @override
  State<RecipeSortButton> createState() => _RecipeSortButtonState();
}

class _RecipeSortButtonState extends State<RecipeSortButton> {

  final listTileFontSize = 14.sp;
  final List<int> sortStates = [0, 0, 0, 0];
  final sortNames = ["Opinie", "Liczba produktów", "Liczba posiadanych produktów", "Liczba brakujących produktów"];
  final sortApiNames = ["RATING", "PRODUCTS_ALL", "PRODUCTS_HAS", "PRODUCTS_HASNOT"];

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
        visible: widget.isMenuOpen,
        anchor: Aligned(
            follower: Alignment.topLeft,
            target: Alignment.bottomLeft,
          offset: Offset(10.w, 0),
        ),
        portalFollower: GestureDetector(
          onTap: () {
            widget._refresh(false);
          },
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.all(Radius.circular(10.sp)),
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for(var i = 0; i < 4; i++)
                  ListTile(
                    tileColor: (sortStates[i] == 0)  ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.sp)
                    ),
                    style: ListTileStyle.list,
                    horizontalTitleGap: 0,

                    leading: (sortStates[i] == 1) ?  Icon(Icons.arrow_upward, size: 20.sp, color: Theme.of(context).colorScheme.inversePrimary,) : Icon(Icons.arrow_downward, size: 20.sp,  color: Theme.of(context).colorScheme.inversePrimary,),
                      title: Text(
                          sortNames[i],
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: listTileFontSize),
                          overflow: TextOverflow.fade,
                      ),
                    onTap: () {
                        for(var j = 0; j < sortStates.length; j++) {
                          if(sortStates[j] != 0 && i != j) {
                            setState(() {
                              sortStates[j] = 0;
                            });
                          }
                        }

                        sortStates[i]++;

                        if(sortStates[i] == 3) {
                          sortStates[i] = 0;
                          widget._changeSort("PRODUCTS_PROGRESS_DESC, PRODUCTS_HAS_DESC");

                        } else {
                          widget._changeSort(sortApiNames[i] + ((sortStates[i] == 1) ? "_DESC" : "_ASC"));
                        }
                        setState(() {

                        });

                    },
                  ),

                ],
              ),
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.w, 5.h, 0, 0),
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.onSurface),
                  padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 8.w))
              ),
              onPressed: () {
                setState(() {
                  widget._refresh(true);
                });
              },
              child: Row(
                children: [
                  Icon(
                    Icons.sort, size: 30.w, color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  SizedBox(width: 5.w,),
                  Text(
                    "Sortuj",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 22.sp, fontWeight: FontWeight.w500),
                  )
                ],
              )
          ),
        )
    );
  }
}
