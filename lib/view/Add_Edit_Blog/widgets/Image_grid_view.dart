import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

class ImageGridView extends StatefulWidget {
  final List<String> imageUrl;
  ImageGridView({Key key, this.imageUrl}) : super(key: key);

  @override
  _ImageGridViewState createState() => _ImageGridViewState();
}

class _ImageGridViewState extends State<ImageGridView> {
  @override
  Widget build(BuildContext context) {
    List<NetworkImage> networkImages = List<NetworkImage>();
    //print('image url in befor for $imageUrl}');
    if (widget.imageUrl != null) {
      for (var image in widget.imageUrl) {
        networkImages.add(
          NetworkImage(image),
        );
      }

      if (networkImages.length > 0) {
        return InkWell(
            child: SizedBox(
                height: 240.0,
                width: MediaQuery.of(context).size.width,
                child: Carousel(
                  images: networkImages,
                  dotSize: 8.0,
                  dotSpacing: 15.0,
                  dotColor: Colors.purple[800],
                  indicatorBgPadding: 5.0,
                  autoplay: false,
                  dotBgColor: Colors.white.withOpacity(0),
                  borderRadius: true,
                )));
      } else {
        return Text('error in loading');
      }
    }
  }
}
