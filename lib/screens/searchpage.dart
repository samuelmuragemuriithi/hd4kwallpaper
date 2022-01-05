import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hd4kwallpaper/screens/fullscreen.dart';

class SearchedPage extends StatefulWidget {
  var genre;
  SearchedPage(this.genre);

  @override
  _SearchedPageState createState() => new _SearchedPageState();
}

class _SearchedPageState extends State<SearchedPage> {
  _getId(var link) {
    var wallID = 'https://drive.google.com/uc?export=download&id=';
    var c = 0;
    for (int i = 0; i < link.length; i++) {
      if (link[i] == '/') {
        c++;
        continue;
      }
      if (c > 4 && c < 6) wallID += link[i];
    }
    return wallID;
  }

  _getGenre(var text) {
    List type = ["nature", "hD", "iphone", "cool 4k", "cars"];

    List keyWords = [
      'nature',
      'forest',
      'jungle',
      'earth',
      'wild',
      'green',
      'hd',
      '4k',
      'hd wallpapers',
      'ultrahd',
      '4k wallpapers',
      'best',
      'street',
      'road',
      'path',
      'highway',
      'footpath',
      'walk',
      'cars',
      'bugaati',
      'audi',
      'supercars',
      'car',
      'mustang',
      'code',
      'computer',
      'coding',
      'hacking',
      'programmer',
      'hacker',
      'anime',
      'animes',
      'naruto',
      'otaku',
      'shinigami',
      'kira',
      'dark',
      'black',
      'amoled',
      'darker',
      'grey',
      'matte',
      'marvel',
      'spiderman',
      'ironman',
      'thor',
      'hulk',
      'superhero'
    ];

    text = text.toLowerCase();
    var c = 0;
    for (int i = 0; i < keyWords.length; i++) {
      if (keyWords[i] == text) {
        c = i ~/ 6;
        break;
      }
    }

    return type[c];
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[350],
          elevation: 10,
          title:
              Text(widget.genre, style: const TextStyle(color: Colors.black)),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(_getGenre(widget.genre))
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                    child: Text(
                  "Failed to load Wallpaper..",
                ));
              }

              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());

                default:
                  return GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, i) {
                        var higher = snapshot.data!.docs[i]['higher'];
                        var lower = snapshot.data!.docs[i]['lower'];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              // Navigate it to the full screen page
                              Navigator.of(context).push(
                                  MaterialPageRoute<void>(builder: (context) {
                                return FullScreen(_getId(higher));
                              }));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                  imageUrl: lower, fit: BoxFit.cover),
                            ),
                          ),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: (width / 2.5) / (height / 2.5)));
              }
            }));
  }
}
