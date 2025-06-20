import 'package:flutter/material.dart';

class PhotoScreen extends StatelessWidget {
  final List<String> imageUrls;
  const PhotoScreen({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemCount: imageUrls.length,
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemBuilder: (context, index) => Image.network(imageUrls[index], loadingBuilder: (context, child, loadingProgress) {
          if(loadingProgress == null){
            return child;
          }
          return Center(child: CircularProgressIndicator());
        },),
      ),
    );
  }
}
