import 'package:flutter/material.dart';

import '../utils/allData.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Festify",
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
          ),
        ),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ...AllFestivals.festivals.map(
                (e) => GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.of(context)
                          .pushNamed('DetailPage', arguments: e);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, bottom: 8, top: 8),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadiusDirectional.all(
                            Radius.circular(20),
                          ),
                          image: DecorationImage(
                            colorFilter: const ColorFilter.mode(
                                Colors.white10, BlendMode.colorDodge),
                            fit: BoxFit.cover,
                            image: NetworkImage("${e['thumbnail']}"),
                          ),
                          border: Border.all(color: Colors.grey.shade300)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
