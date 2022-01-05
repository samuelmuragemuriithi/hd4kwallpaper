import 'package:flutter/material.dart';
import 'package:hd4kwallpaper/screens/searchpage.dart';
import 'package:hd4kwallpaper/widgets/categorytile.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  TextEditingController t = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.centerLeft,
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/Images/splash_background.png'))),
        child: Padding(
          padding: EdgeInsets.all(width / 18),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  Welcome header
                const Text("Dope !",
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),

                Row(
                  children: const [
                    Text("Wallpapers",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 33, fontWeight: FontWeight.bold)),
                    Text("4K",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 33,
                            color: Colors.red,
                            fontWeight: FontWeight.bold))
                  ],
                ),

                const SizedBox(
                  height: 30,
                ),

                // TextField

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Card(
                      color: Colors.white,
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      child: TextField(
                          controller: t,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              hintText: 'Search wallpaper type etc..',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Colors.black87,
                              )),
                          onSubmitted: (t1) => {
                                Navigator.of(context).push(
                                    MaterialPageRoute<void>(builder: (context) {
                                  return SearchedPage(t.text);
                                }))
                              }),
                    ))
                  ],
                ),

                const SizedBox(
                  height: 25,
                ),

                // CategoryTiles

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CategoryTile(0),
                    CategoryTile(1),
                    CategoryTile(2),
                  ],
                ),

                const SizedBox(
                  height: 25,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CategoryTile(3),
                    CategoryTile(4),
                    SizedBox(width: width / 4.5)
                  ],
                )
              ]),
        ),
      ),
    );
  }
}
