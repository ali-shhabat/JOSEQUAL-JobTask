
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:josequal/WallpaperDetails.dart';
import 'package:sizer/sizer.dart';

import 'Classes/Wallpaper.dart';
import 'FavoritesPage.dart';
import 'Global.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
//6H2AC7BtAR07VLUZdURXoWOHpLiN4zm4vDZlT9CjNZvBdQcDJAhzL0t6

class _MyHomePageState extends State<MyHomePage> {
  ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  List<Wallpaper> _wallpapers = [];
  int _page = 1;
  bool _isLoading = false;

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!_isLoading && _scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadWallpapers();
    }
  }

  Future<void> _loadWallpapers() async {
    setState(() {
      _isLoading = true;
    });
    var wallpapers = await getWallpapers(_page);
    setState(() {
      _wallpapers.addAll(wallpapers);
      _page++;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadWallpapers();
  }

  List<dynamic> wallpapers=[];
  List<Wallpaper> wallpaperList=[];
  var response;
  bool isSearching = false;
  String? query;

  Future<List<Wallpaper>> getWallpapers(int page) async{
    if(isSearching) {
      response = await http.get(
          Uri.parse("https://api.pexels.com/v1/search?query=$query&per_page=20"),
          headers: {
            "Authorization": apiKey,
          });
      print(response.body);
    }else{
      response = await http.get(
          Uri.parse("https://api.pexels.com/v1/curated?page=$page&per_page=20"),
          headers: {
            "Authorization": apiKey,
          });
    }
    if(response.statusCode == 200){
      wallpapers = jsonDecode(response.body)['photos'];
      wallpaperList = wallpapers.map((wallpaper) => Wallpaper(
        id: wallpaper['id'].toString(),
        width: wallpaper['width'].toString(),
        height: wallpaper['height'].toString(),
        url: wallpaper['url'],
        photographer: wallpaper['photographer'],
        src: wallpaper['src']['large'],
        original: wallpaper['src']['original'],
        favorite: false,
      )).toList();
    }
    return wallpaperList;
  }
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
           body: Stack(
             children: [
               Column(
               children: [
                 Container(
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       Container(
                         width: 85.w,
                         padding: EdgeInsets.symmetric(horizontal: 4.w),
                         margin: EdgeInsets.symmetric(vertical: 1.h),
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(25),
                           border: Border.all(color: Colors.black87)
                         ),
                         child: TextField(
                           controller: searchController,
                           decoration: InputDecoration(
                             hintText: 'Search wallpapers..',
                             border: InputBorder.none,
                           ),
                           onChanged: (value){
                             if(value.isEmpty){
                               _wallpapers.clear();
                               isSearching = false;
                               _page=1;
                               _loadWallpapers();
                               setState(() {

                               });
                             }
                           },
                         ),
                       ),
                       CircleAvatar(
                         backgroundColor: Colors.black87,
                         child: IconButton(
                             onPressed:() async {
                               if(searchController.text.isNotEmpty) {
                                 _wallpapers.clear();
                                 isSearching = true;
                                 query = searchController.text;
                                 _wallpapers = await getWallpapers(_page);
                               }else{
                                 _wallpapers.clear();
                                 isSearching = false;
                                 _page=1;
                                 _loadWallpapers();
                               }
                               setState(() {
                               });
                         },
                             icon: Icon(Icons.search, color: Colors.white,)),
                       )
                     ],
                   ),
                 ),
                 Expanded(
                   child: FutureBuilder<List<Wallpaper>>(
                     future: getWallpapers(_page),
                     builder: (context, snapshot) {
                       if (snapshot.hasData) {
                         return GridView.builder(
                           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                             crossAxisCount: 2,
                             childAspectRatio: 2/3,
                           ),
                           itemCount: _wallpapers.length + (_isLoading ? 1 : 0),
                           controller: _scrollController,
                           itemBuilder: (context, index) {
                             if (index == _wallpapers.length){
                               return Center(child: CircularProgressIndicator());
                             } else {
                               final wallpaper = _wallpapers[index];
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
                           },
                         );
                       } else {
                         return Center(
                             child: CircularProgressIndicator(color: Colors.black,),
                         );
                       }
                     },
                   ),
                 ),
               ],
             ),
               Positioned(
                 bottom: 5.h,
                   left: 2.w,
                   child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                       fixedSize: Size(30.w, 7.h),
                       backgroundColor: Colors.redAccent,
                       shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(30)),
                     ),
                       child: Text("Favorites", style: TextStyle(fontSize: 15.sp),),
                     onPressed: (){
                       favWallpapers = _wallpapers.where((element){
                         return element.favorite==true;
                       }).toList();
                       Navigator.push(context, MaterialPageRoute(builder: (builder){
                         return FavoritePage();
                       }));
                     },
                   ),
               ),
             ],
           ),
         );
       },
   );
  }
}