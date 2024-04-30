import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
class PhotoViewScreen extends StatefulWidget {
  final String img;
  const PhotoViewScreen({super.key, required this.img});

  @override
  State<PhotoViewScreen> createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: PhotoView(imageProvider:NetworkImage(widget.img)),
      ),
    );
  }
}
