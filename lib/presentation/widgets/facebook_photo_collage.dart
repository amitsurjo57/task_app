import 'package:flutter/material.dart';

class FacebookPhotoCollage extends StatelessWidget {
  final List<String> imageUrls;

  const FacebookPhotoCollage({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return SizedBox();
    }

    if (imageUrls.length == 1) {
      return _buildSingleImage(imageUrls[0]);
    } else if (imageUrls.length == 2) {
      return _buildTwoImages(imageUrls);
    } else if (imageUrls.length == 3) {
      return _buildThreeImages(imageUrls);
    } else if (imageUrls.length == 4) {
      return _buildFourImages(imageUrls);
    } else {
      return _buildFivePlusImages(imageUrls);
    }
  }

  // Modified _buildImage to use CachedNetworkImage
  Widget _buildImage(
    String imageUrl, {
    double? width,
    double? height,
    BoxFit? fit,
    Widget? overlay,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200], // Placeholder background
        borderRadius: BorderRadius.circular(8.0), // Optional rounded corners
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              imageUrl,
              fit: fit ?? BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
          if (overlay != null) overlay,
        ],
      ),
    );
  }

  Widget _buildSingleImage(String imageUrl) {
    return AspectRatio(
      aspectRatio: 16 / 9, // Common aspect ratio for a single image
      child: _buildImage(imageUrl, fit: BoxFit.cover),
    );
  }

  Widget _buildTwoImages(List<String> imageUrls) {
    return Row(
      children: [
        Expanded(
          child: AspectRatio(aspectRatio: 1, child: _buildImage(imageUrls[0])),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: AspectRatio(aspectRatio: 1, child: _buildImage(imageUrls[1])),
        ),
      ],
    );
  }

  Widget _buildThreeImages(List<String> imageUrls) {
    return Column(
      children: [
        AspectRatio(aspectRatio: 16 / 9, child: _buildImage(imageUrls[0])),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: _buildImage(imageUrls[1]),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: _buildImage(imageUrls[2]),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFourImages(List<String> imageUrls) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: _buildImage(imageUrls[0]),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: _buildImage(imageUrls[1]),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: _buildImage(imageUrls[2]),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: _buildImage(imageUrls[3]),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFivePlusImages(List<String> imageUrls) {
    final int remainingImages = imageUrls.length - 4;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: _buildImage(imageUrls[0]),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: _buildImage(imageUrls[1]),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: _buildImage(imageUrls[2]),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: _buildImage(
                  imageUrls[3],
                  overlay: Container(
                    color: Colors.grey,
                    child: Center(
                      child: Text(
                        '+$remainingImages',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
