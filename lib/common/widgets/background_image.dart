import 'package:flutter/material.dart';
import 'package:roadside_assistance/common/app_images/app_images.dart';

class BackgroundImage extends StatefulWidget {
  final List<Widget> children;

  const BackgroundImage({Key? key, required this.children}): super(key: key);

  @override
  State<BackgroundImage> createState() => _BackgroundImageState();
}

class _BackgroundImageState extends State<BackgroundImage> {
bool _isImageLoaded=false;

  Future<void> _preloadImage() async {
    await precacheImage(AssetImage( AppImage.backgroundImg), context);
    setState(() {
      _isImageLoaded = true;
    });
  }
@override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((__)async{
      await _preloadImage();
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
     if(!_isImageLoaded){
       return const Center(child: CircularProgressIndicator());
     }
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            AppImage.backgroundImg,
            fit: BoxFit.fill,
          ),
        ),
        SafeArea(
          child: Stack(
            children: widget.children,
          ),
        )
      ],
    );
  }
}
