import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quotopia/utils/allData.dart';
import 'package:share_extend/share_extend.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<String> fontFamilies = GoogleFonts.asMap().keys.toList();

  bool tap = true;
  double fontSize = 16;
  double dx = 0;
  double dy = 0;
  double slide = 1;
  FontWeight fontWid = FontWeight.w100;
  bool tap2 = false;
  Color choseColor = Colors.grey.shade400;
  Color choseFontColor = Colors.black;
  String? img;
  late String font;
  GlobalKey repaintKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    font = fontFamilies[0];
  }

  GlobalKey<FormState> savInfo = GlobalKey<FormState>();
  TextEditingController sav = TextEditingController();

  Future<void> shareImage() async {
    RenderRepaintBoundary renderRepaintBoundary =
        repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    var image = await renderRepaintBoundary.toImage(pixelRatio: 5);

    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);

    Uint8List fetchImage = byteData!.buffer.asUint8List();

    Directory directory = await getApplicationCacheDirectory();

    String path = directory.path;

    File file = File('$path.png');

    file.writeAsBytes(fetchImage);

    ShareExtend.share(file.path, "Image");
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> festival =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "${festival['festivals']}",
        ),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    img = null;
                    slide = 1;
                    dx = 0;
                    dy = 0;
                    fontSize = 16;
                    choseColor = Colors.grey.shade400;
                    choseFontColor = Colors.black;
                    font = fontFamilies[0];
                    AllFestivals.fas = "Press + to Enter the Festival name ";
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.refresh_rounded),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () async {
                      await shareImage();
                    },
                    child: const Icon(Icons.share),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Form(
                key: savInfo,
                child: Column(
                  children: [
                    AlertDialog(
                      title: const Text("Enter the Festival Name"),
                      content: TextFormField(
                        controller: sav,
                        onSaved: (val) {
                          setState(() {
                            AllFestivals.fas = val!;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter the Name",
                        ),
                      ),
                      actions: [
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    sav.clear();
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: Icon(Icons.close)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                                onTap: () {
                                  savInfo.currentState!.save();
                                  sav.clear();
                                  Navigator.of(context).pop();
                                },
                                child: const Icon(Icons.check)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        elevation: 3,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: RepaintBoundary(
                key: repaintKey,
                child: Container(
                  alignment: Alignment(dx, dy),
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: (img == null) ? choseColor : null,
                    image: (img != null)
                        ? DecorationImage(
                            fit: BoxFit.contain,
                            image: NetworkImage(img!),
                          )
                        : null,
                  ),
                  child: Text(
                    AllFestivals.fas,
                    style: GoogleFonts.getFont(
                      font,
                      fontSize: fontSize,
                      color: choseFontColor,
                      fontWeight: fontWid,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        tap = true;
                        tap2 = false;
                      });
                    },
                    child: Text(
                      "Editing",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        decorationColor: Colors.white,
                        decoration: (tap)
                            ? TextDecoration.underline
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        tap2 = true;
                        tap = false;
                      });
                    },
                    child: Text(
                      "Adjustment",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          decorationColor: Colors.white,
                          decoration: (tap2)
                              ? TextDecoration.underline
                              : TextDecoration.none),
                    ),
                  ),
                ],
              ),
            ),
            (tap)
                ? Expanded(
                    child: ListView(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Chose BackGround",
                            style: TextStyle(fontSize: 20),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children: [
                              ...festival['images'].map((e) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      img = e;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      top: 12,
                                      right: 8,
                                    ),
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(e),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            width: 2, color: Colors.grey)),
                                  ),
                                );
                              })
                            ]),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Font Color",
                            style: TextStyle(fontSize: 20),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: Colors.accents
                                  .map((e) => GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            choseFontColor = e;
                                          });
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            top: 12,
                                            right: 8,
                                          ),
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: e,
                                              border: Border.all(
                                                  width: 2,
                                                  color: Colors.grey)),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "BackGround Color",
                            style: TextStyle(fontSize: 20),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: Colors.primaries
                                  .map((e) => GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            img = null;
                                            choseColor = e;
                                          });
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            top: 12,
                                            right: 8,
                                          ),
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: e,
                                              border: Border.all(
                                                  width: 2,
                                                  color: Colors.grey)),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Font Style",
                            style: TextStyle(fontSize: 20),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: fontFamilies
                                  .map(
                                    (e) => (fontFamilies.indexOf(e) <= 30)
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                font = e;
                                              });
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.only(
                                                top: 12,
                                                right: 8,
                                              ),
                                              height: 80,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    width: 2,
                                                    color: Colors.grey),
                                              ),
                                              child: Text(
                                                "Aa",
                                                style: GoogleFonts.getFont(
                                                  e,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  )
                : Expanded(
                    child: ListView(children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Change Font Size"),
                            Slider(
                              value: fontSize,
                              min: 16,
                              max: 22,
                              divisions: 9,
                              onChanged: (val) {
                                setState(() {
                                  fontSize = val;
                                });
                              },
                            ),
                            const Text("Change Font Weight "),
                            Slider(
                              value: slide,
                              max: 10,
                              min: 1,
                              divisions: 9,
                              onChanged: (val) {
                                setState(() {
                                  if (val == 1) {
                                    slide = val;
                                    fontWid = FontWeight.w100;
                                  } else if (val <= 2) {
                                    slide = val;
                                    fontWid = FontWeight.w200;
                                  } else if (val <= 3) {
                                    slide = val;
                                    fontWid = FontWeight.w300;
                                  } else if (val <= 4) {
                                    slide = val;
                                    fontWid = FontWeight.w400;
                                  } else if (val <= 5) {
                                    slide = val;
                                    fontWid = FontWeight.w500;
                                  } else if (val <= 6) {
                                    slide = val;
                                    fontWid = FontWeight.w600;
                                  } else if (val <= 7) {
                                    slide = val;
                                    fontWid = FontWeight.w700;
                                  } else if (val <= 8) {
                                    slide = val;
                                    fontWid = FontWeight.w800;
                                  } else if (val == 9) {
                                    slide = val;
                                    fontWid = FontWeight.w900;
                                  } else if (val == 10) {
                                    slide = val;
                                    fontWid = FontWeight.bold;
                                  }
                                });
                              },
                            ),
                            const Text("Align Font Location(dx)"),
                            Slider(
                              value: dx,
                              max: 1,
                              min: -1,
                              divisions: 9,
                              onChanged: (val) {
                                setState(() {
                                  dx = val;
                                });
                              },
                            ),
                            const Text("Align Font Location(dy)"),
                            Slider(
                              value: dy,
                              max: 1.05,
                              min: -1,
                              divisions: 9,
                              onChanged: (val) {
                                setState(() {
                                  dy = val;
                                });
                              },
                            ),
                          ]),
                    ]),
                  )
          ],
        ),
      ),
    );
  }
}
