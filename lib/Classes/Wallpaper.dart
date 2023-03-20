class Wallpaper{
  String? id;
  String? width;
  String? height;
  String? url;
  String? photographer;
  String? src;
  String? original;
  bool favorite = false;

  Wallpaper({
    this.id,
    this.width,
    this.url,
    this.height,
    this.photographer,
    this.src,
    this.original,
    required this.favorite
  });
}