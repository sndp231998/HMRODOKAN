import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String imageUrl;
  final bool validURL;

  const ImageWidget({
    Key? key,
    required this.imageUrl,
    required this.validURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return validURL
        ? Image.network(
            imageUrl,
            width: 60,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/icons/icon.png',
                width: 60,
              );
            },
          )
        : Image.asset(
            'assets/icons/icon.png',
            width: 60,
          );
  }
}
