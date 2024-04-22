// ignore_for_file: file_names
import 'package:app_tuddo_gramado/services/auth_check.dart';
import 'package:app_tuddo_gramado/utils/ADataProvider.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:app_tuddo_gramado/utils/constant.dart';

class AWalkThroughScreen extends StatefulWidget {
  const AWalkThroughScreen({super.key});

  @override
  State<AWalkThroughScreen> createState() => _AWalkThroughScreenState();
}

class _AWalkThroughScreenState extends State<AWalkThroughScreen> {
  int initialValue = 0;
  int progressIndex = 0;

  late PageController pageController;

  @override
  void initState() {
    setStatusBarColor(Colors.transparent);
    super.initState();
    pageController = PageController(initialPage: 0);
    progressIndex = 0;
  }

  double containerWidth() {
    return (150 / modal.length) * (progressIndex + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            onPageChanged: (value) => setState(
              () {
                initialValue = value;
                progressIndex = value;
                debugPrint("$value");
              },
            ),
            children: modal.map((e) {
              return Stack(
                children: [
                  //Image
                  Image.asset(
                    e.image.toString(),
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.35),
                    colorBlendMode: BlendMode.darken,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                  // DataEntry
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).viewPadding.top + 16,
                          ),
                          initialValue < 2
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    /*Container(
                                alignment: Alignment.centerRight,
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Text(
                                  (e.heading ?? ""),
                                  style: whiteBold18,
                                ),
                              ),*/
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      margin: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: primaryColor,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const CheckUserLoggedInOrNot(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Pular',
                                          style: whiteBold18,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.title.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 45,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              e.subtitle.toString(),
                              style: whiteMedium16,
                            ),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }).toList(),
          ),
          //Determinate LinearProgressIndicator & FAB
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 150,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(45),
                      ),
                    ),
                    AnimatedContainer(
                      duration: 1.seconds,
                      width: containerWidth(),
                      height: 10,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(45),
                      ),
                    ),
                  ],
                ),
                // Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  height: 50,
                  width: 50,
                  child: InkWell(
                    onTap: () {
                      if (initialValue < 2) {
                        setState(
                          () => pageController.jumpToPage(initialValue + 1),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const CheckUserLoggedInOrNot(),
                          ),
                        );
                      }
                    },
                    child: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
