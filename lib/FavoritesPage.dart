import 'package:flutter/material.dart';
import 'package:josequal/Global.dart';
import 'package:sizer/sizer.dart';

import 'WallpaperDetails.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return Scaffold(
            appBar: AppBar(
          backgroundColor: Colors.black,
          title: Center(
            child: Text(
                "JOSQUAL"
            ),
          ),
        ),
        body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
          childAspectRatio: 2/3,
        ),
        itemCount: favWallpapers.length,
        itemBuilder: (context, index) {
            final wallpaper = favWallpapers[index];
            return GestureDetector(
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Image.network(
                        wallpaper.src ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (builder){
                  return WallpaperDetails(wallpaper: wallpaper,);
                }));
              },
            );
        }
        ),
      );
  }
    );
  }
}
