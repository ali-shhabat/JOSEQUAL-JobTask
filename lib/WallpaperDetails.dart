import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:josequal/Classes/Wallpaper.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'Global.dart';

class WallpaperDetails extends StatefulWidget {
  Wallpaper? wallpaper;
  WallpaperDetails({this.wallpaper});
  @override
  State<WallpaperDetails> createState() => _WallpaperDetailsState();
}

class _WallpaperDetailsState extends State<WallpaperDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
              "JOSQUAL"
          ),
        ),
      ),
      body: Stack(
        children:[
          Container(
            height: 100.h,
            child: Image.network(
              widget.wallpaper!.src ?? '',
              fit: BoxFit.cover,
          ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 7.h,
              width: 100.w,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white10,
                      Colors.white38,
                      Colors.white54,
                      Colors.white70,
                    ],
                  ),
                  // borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  widget.wallpaper!.favorite?
                  IconButton(onPressed: (){
                    widget.wallpaper!.favorite = false;
                    setState(() {

                    });
                  }, icon: Icon(Icons.favorite, size: 30.sp,)):
                  IconButton(onPressed: (){
                    widget.wallpaper!.favorite = true;
                    setState(() {

                    });
                  }, icon: Icon(Icons.favorite_border, size: 30.sp)),
                  IconButton(
                      icon: Icon(Icons.download, size: 30.sp),
                    onPressed: () async{
                        await ImageDownloader.downloadImage(widget.wallpaper!.original!);
                      }
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
