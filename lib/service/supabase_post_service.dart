import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_app/models/supabase_models.dart';
import 'package:task_app/presentation/widgets/post_widget.dart';
import 'package:task_app/service/shared_preference_service.dart';
import '../main.dart';
import '../models/post_model.dart';

class SupabasePostService {
  static Future<SupabaseModel> post({
    required String captions,
    required String departureAirport,
    required String arrivalAirport,
    required String airline,
    required String classAirline,
    required String travelDate,
    required int ratings,
    required List<XFile?> images,
  }) async {
    try {
      List<String> imageUrlList = [];

      if (images.isNotEmpty) {
        for (var img in images) {
          try {
            final avatarFile = File(img?.path ?? '');

            final String? userId = await SharedPreferenceService().getUserId();

            await supaBase.storage
                .from('user-files')
                .upload(
                  "${userId ?? ''}/files/${img?.name ?? ''}",
                  avatarFile,
                  fileOptions: FileOptions(upsert: true),
                );

            final String publicUrl = supaBase.storage
                .from('user-files')
                .getPublicUrl("${userId ?? ''}/files/${img?.name ?? ''}");

            imageUrlList.add(publicUrl);
          } catch (e) {
            debugPrint(e.toString());
            continue;
          }
        }
      }

      String? userId = await SharedPreferenceService().getUserId();

      await supaBase.from('posts').insert({
        'caption': captions,
        'images': imageUrlList,
        'user_id': userId,
        'comments': [],
        'ratings': ratings,
        'upload_time': travelDate,
        'departure_airport': departureAirport,
        'arrival_airport': arrivalAirport,
        'airline': airline,
        'class': classAirline,
        'travel_date': travelDate,
        'likes': [],
      });

      return SupabaseModel(
        message: "Your Post is Uploaded successfully",
        isSuccessful: true,
      );
    } catch (e) {
      debugPrint(e.toString());
      return SupabaseModel(
        message: "Your Post couldn't upload",
        isSuccessful: true,
      );
    }
  }

  static Future<List<PostWidget>> getAllPost({
    required List<PostWidget> listOfPostWidget,
  }) async {
    listOfPostWidget.clear();

    final List<Map<String, dynamic>> data = await supaBase
        .from('posts')
        .select();

    for (Map<String, dynamic> post in data) {
      listOfPostWidget.add(
        PostWidget(
          postModel: PostModel(
            id: post['id'] ?? '',
            likes: List<String>.from(post['likes'] ?? []),
            images: List<String>.from(post['images'] ?? []),
            userId: post['userId'] ?? '',
            ratings: post['ratings'] ?? '',
            airline: post['airline'] ?? '',
            captions: post['caption'] ?? '',
            comments: List<String>.from(post['comments'] ?? []),
            classAirline: post['class'] ?? '',
            travelDate: post['travel_date'] ?? '',
            uploadTime: post['upload_time'] ?? '',
            arrivalAirport: post['arrival_airport'] ?? '',
            departureAirport: post['departure_airport'] ?? '',
          ),
        ),
      );
    }

    return listOfPostWidget;
  }
}
