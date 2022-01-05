import 'package:flutter/material.dart';
import 'package:hd4kwallpaper/screens/searchpage.dart';

class CategoryTile extends StatelessWidget {
  var index;
  CategoryTile(this.index, {Key? key}) : super(key: key);

  List type = ["Nature", "HD", "Iphone", "Cool 4k", "Cars"];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () => {
        Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
          return SearchedPage(type[index]);
        }))
      },
      child: Card(
          elevation: 20,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              height: height / 20,
              width: width / 5,
              child: Center(
                child: Text(
                  type[index],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                  ),
                ),
              ))),
    );
  }
}
