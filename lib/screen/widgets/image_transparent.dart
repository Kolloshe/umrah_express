import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';

class TransparentCachedNetworkImage extends StatefulWidget {
  final String imageUrl;
  final double? width;

  const TransparentCachedNetworkImage({super.key, required this.imageUrl, this.width});

  @override
  _TransparentCachedNetworkImageState createState() => _TransparentCachedNetworkImageState();
}

class _TransparentCachedNetworkImageState extends State<TransparentCachedNetworkImage> {
  Uint8List? _transparentImage;

  @override
  void initState() {
    super.initState();
    _loadAndProcessImage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadAndProcessImage() async {
    final response = await http.get(Uri.parse(widget.imageUrl));
    if (response.statusCode == 200) {
      final imageBytes = response.bodyBytes;
      final transparentImageBytes = await compute(_makeWhiteBackgroundTransparent, imageBytes);
      if (mounted) {
        setState(() {
          _transparentImage = transparentImageBytes;
        });
      }
    }
  }

  static Uint8List _makeWhiteBackgroundTransparent(Uint8List imageBytes) {
    final image = img.decodeImage(imageBytes);
    if (image != null) {
      for (int y = 0; y < image.height; y++) {
        for (int x = 0; x < image.width; x++) {
          final pixel = image.getPixel(x, y);
          final r = img.getRed(pixel);
          final g = img.getGreen(pixel);
          final b = img.getBlue(pixel);
          if (r > 240 && g > 240 && b > 240) {
            image.setPixel(x, y, img.getColor(r, g, b, 0));
          }
        }
      }
      return Uint8List.fromList(img.encodePng(image));
    }
    return imageBytes;
  }

  @override
  Widget build(BuildContext context) {
    return _transparentImage == null
        ? const CircularProgressIndicator()
        : Image.memory(
            _transparentImage!,
          );
  }
}
