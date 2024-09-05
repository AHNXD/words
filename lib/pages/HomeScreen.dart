// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:words/services/apiService.dart';
import 'package:words/pages/settings.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String id = "/home";
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

toColor(String c) {
  var hexString = c;
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

class _HomeScreenState extends State<HomeScreen> {
  late var letters = [];
  late var teamInfo = [];
  late var category = [];
  String word = "Select Category";
  bool IpCheck() {
    return ApiService.ip == "" ? false : true;
  }

  void massege(String error, Color c) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: c,
      content: Center(child: Text(error)),
      duration: const Duration(seconds: 2),
    ));
  }

  Future<void> _retrieveIp() async {
    final prefs = await SharedPreferences.getInstance();

    // Check where the Ip is saved before or not
    if (!prefs.containsKey('ip')) {
      return;
    }

    setState(() {
      ApiService.ip = prefs.getString('ip')!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _retrieveIp();
  }

  @override
  Widget build(BuildContext context) {
    //SizeConfig().init(context);
    return Scaffold(
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(188, 63, 63, 63),
        child: Stack(children: [
          const Positioned.fill(
            //
            child: Image(
              image: AssetImage('assets/images/bg.png'),
              fit: BoxFit.fitHeight,
              color: Color.fromARGB(144, 255, 193, 7),
            ),
          ),
          ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                color: const Color.fromARGB(255, 238, 179, 4),
                child: const Center(
                    child: Text(
                  "Categories",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                )),
              ),
              const SizedBox(
                height: 5,
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    word,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                height: 50,
                width: 80,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 246, 188, 13),
                        padding: const EdgeInsets.all(10),
                        elevation: 20,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                    onPressed: () async {
                      if (IpCheck()) {
                        ApiService.nextRound();
                      } else {
                        Navigator.pop(context);
                        massege("There is no IP !", Colors.red);
                      }
                    },
                    child: const Icon(Icons.play_arrow)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    height: 50,
                    width: 80,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 2, 43, 249),
                            padding: const EdgeInsets.all(10),
                            elevation: 20,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                        onPressed: () {
                          setState(() {
                            if (IpCheck()) {
                              ApiService.textValue(-1);
                            } else {
                              massege("There is no IP !", Colors.red);
                            }
                          });
                        },
                        child: const Text(
                          "-",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    height: 60,
                    width: 80,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 57, 29, 138),
                            padding: const EdgeInsets.all(10),
                            elevation: 20,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                        onPressed: () async {
                          if (IpCheck()) {
                            try {
                              category = await ApiService.getAllCategory();
                              if (await ApiService.getWord() != "null") {
                                word = await ApiService.getWord();
                              }
                            } catch (e) {
                              Navigator.pop(context);
                              massege("Check your IP", Colors.red);
                            }
                            setState(() {});
                          } else {
                            Navigator.pop(context);
                            massege("There is no IP !", Colors.red);
                          }
                        },
                        child: const Icon(
                          Icons.refresh,
                          size: 25,
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    height: 50,
                    width: 80,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 2, 43, 249),
                            padding: const EdgeInsets.all(10),
                            elevation: 20,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                        onPressed: () {
                          if (IpCheck()) {
                            setState(() {
                              ApiService.textValue(1);
                            });
                          } else {
                            massege("There is no IP !", Colors.red);
                          }
                        },
                        child: const Text(
                          "+",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                  ),
                ],
              ),
              const Divider(color: Colors.white),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: category.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.all(5),
                      height: 80,
                      width: 80,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              side: const BorderSide(
                                  width: 5, color: Colors.black),
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              padding: const EdgeInsets.all(10),
                              elevation: 20,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)))),
                          onPressed: () async {
                            ApiService.selectCategory(index);
                            await Future.delayed(
                                const Duration(milliseconds: 200));
                            if (await ApiService.getWord() != "null") {
                              word = await ApiService.getWord();
                              letters = await ApiService.getLetters();
                            }
                            setState(() {});
                          },
                          child: Text(
                            category[index],
                            style: const TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )),
                    );
                  }),
            ],
          )
        ]),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, Settings.id);
              },
              icon: const Icon(Icons.settings))
        ],
        backgroundColor: Colors.amber,
        title: const Text(
          "Words Game",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(188, 63, 63, 63),
      body: Center(
        child: Stack(children: [
          const Positioned.fill(
            child: Image(
              image: AssetImage('assets/images/bg1.png'),
              fit: BoxFit.fill,
              color: Color.fromARGB(107, 255, 193, 7),
            ),
          ),
          SizedBox(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 10.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 245, 5, 5),
                                padding: const EdgeInsets.all(10),
                                elevation: 20,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)))),
                            onPressed: () {
                              if (IpCheck()) {
                                ApiService.check(0);
                              } else {
                                massege("There is no IP !", Colors.red);
                              }
                            },
                            child: const Text(
                              "No",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                      ),
                      Container(
                          padding: const EdgeInsets.all(5),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  padding: const EdgeInsets.all(10),
                                  elevation: 20,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15)))),
                              onPressed: () {
                                if (IpCheck()) {
                                  setState(() {
                                    ApiService.spin();
                                  });
                                } else {
                                  massege("There is no IP !", Colors.red);
                                }
                              },
                              child: const Icon(Icons.camera))),
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                padding: const EdgeInsets.all(10),
                                elevation: 20,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)))),
                            onPressed: () async {
                              if (IpCheck()) {
                                try {
                                  massege("loading...", Colors.amber);
                                  teamInfo = await ApiService.getTeams();
                                  letters = await ApiService.getLetters();
                                  massege("loaded :)", Colors.green);
                                } catch (e) {
                                  massege("Check your IP", Colors.red);
                                }

                                setState(() {});
                              } else {
                                massege("There is no IP !", Colors.red);
                              }
                            },
                            child: const Icon(
                              Icons.refresh,
                            )),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 0, 130, 9),
                                padding: const EdgeInsets.all(10),
                                elevation: 20,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)))),
                            onPressed: () async {
                              if (IpCheck()) {
                                ApiService.check(1);
                                await Future.delayed(
                                    const Duration(milliseconds: 200));
                                try {
                                  teamInfo = await ApiService.getTeams();
                                  letters = await ApiService.getLetters();
                                } catch (e) {
                                  massege("Check your IP", Colors.red);
                                }
                                await Future.delayed(
                                    const Duration(milliseconds: 200));
                                setState(() {});
                              } else {
                                massege("There is no IP !", Colors.red);
                              }
                            },
                            child: const Text(
                              "Yes",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                      )
                    ],
                  ),
                ),
                const Divider(color: Colors.white),
                SizedBox(
                  height: 20.h,
                  width: double.infinity,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: GridView.builder(
                        itemCount: teamInfo.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 2.5,
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.all(2),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  side: BorderSide(
                                      width: 5,
                                      color: toColor(teamInfo[index]["color"])),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  backgroundColor: Colors.white),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    Icons.people_alt,
                                    color: toColor(teamInfo[index]["color"]),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${teamInfo[index]["name"]}",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "(${teamInfo[index]["score"]})",
                                        style: TextStyle(
                                            color: toColor(
                                                teamInfo[index]["color"])),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              onPressed: () {
                                ApiService.sendTeamNum(index);
                              },
                            ),
                          );
                        }),
                  ),
                ),
                const Divider(
                  color: Colors.white,
                ),
                SizedBox(
                  height: 45.h,
                  width: double.infinity,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: GridView.builder(
                        itemCount: letters.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 2.25,
                          crossAxisCount: 4,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    side: const BorderSide(
                                        color: Colors.black, width: 2),
                                    backgroundColor:
                                        letters[index]["active"] == true
                                            ? Colors.white
                                            : Colors.red,
                                    elevation: 20,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)))),
                                onPressed: () async {
                                  if (letters[index]["active"] == true) {
                                    ApiService.sendLetter(
                                        letters[index]["text"]);
                                    await Future.delayed(
                                        const Duration(milliseconds: 200));
                                    letters = await ApiService.getLetters();
                                    setState(() {});
                                  }
                                },
                                child: Text(
                                  letters[index]["text"],
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      color: letters[index]["active"] == true
                                          ? Colors.red
                                          : Colors.black,
                                      fontWeight: FontWeight.bold),
                                )),
                          );
                        }),
                  ),
                ),
                const Divider(
                  color: Colors.white,
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
