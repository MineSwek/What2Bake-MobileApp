import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:what2bake/pages/walktrough/widgets/pageMiddle.dart';
import 'package:what2bake/pages/walktrough/widgets/pageTopEnd.dart';

class Walkthrough extends StatefulWidget {
  const Walkthrough({super.key});

  @override
  State<Walkthrough> createState() => _WalkthroughState();
}

class _WalkthroughState extends State<Walkthrough> {

  PageController controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        onPageChanged: (index) {

          setState(() => isLastPage = index == 4);
        },
        children: const [
          WalkthroughPageTopEnd(
              topString: "Witaj w",
              pageNumber: "1",
              bottomString: "Upiecz coś z nami!"
          ),
          WalkthroughPageMiddle(
              topString: "Wybierz składniki które aktualnie posiadasz!",
              pageNumber: "2"
          ),
          WalkthroughPageMiddle(
              topString: "Na ich podstawie przejrzyj wszystkie przepisy posortowane i przefiltrowane, tak jak lubisz!",
              pageNumber: "3"
          ),
          WalkthroughPageMiddle(
              topString: "Jeżeli szukasz inspiracji, możesz poszukać przepisów posortowanych po twoich ulubionych kategoriach",
              pageNumber: "4"
          ),
          WalkthroughPageTopEnd(
              topString: "",
              pageNumber: "5",
              bottomString: "To jak?\nUpieczemy coś razem?"
          ),
        ],
      ),
      bottomSheet: (isLastPage) ?
          TextButton(
              onPressed: () async {
                const storage = FlutterSecureStorage();
                storage.write(key: "walkthrough", value: "true");
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const Center(
                          child: CircularProgressIndicator(color: Colors.white,)
                      );
                    },
                );
                await Future.delayed(const Duration(seconds: 1));
                Phoenix.rebirth(context);
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.amber,
                minimumSize: const Size.fromHeight(80)
              ),
              child: Text(
                  "Zaczynamy?",
                  style: TextStyle(
                      fontSize: 25.sp,
                      fontFamily: "Lato",
                      color: Colors.black
                  )
              )
          )
          : SizedBox(
            height: 80.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      controller.animateToPage(
                          5,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn
                      );
                    },
                    child: Text(
                        "SKIP",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: "Lato",
                          color: Colors.red
                        )
                    )
                ),
                Center(
                  child: SmoothPageIndicator(
                    controller: controller,
                    count: 5,
                    effect: WormEffect(
                      dotWidth: 11.w,
                      dotHeight: 11.h,
                      radius: 11.sp,
                      activeDotColor: Colors.amber
                    ),
                    onDotClicked: (index) => controller.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {},
                    child: GestureDetector(
                      onTap: () => controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.amber,
                          radius: 20.sp,
                          child: Icon(Icons.arrow_forward, size: 25.sp,)
                      )
                    )
                ),
              ],
            ),
          ),
    );
  }
}
