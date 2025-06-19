import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_app/models/supabase_models.dart';
import 'package:task_app/service/shared_preference_service.dart';

import '../main.dart';

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
          final avatarFile = File(img?.path ?? '');

          final String? userId = await SharedPreferenceService().getUserId();

          await supaBase.storage
              .from('user-files')
              .upload(
                "${userId ?? ''}/files/${img?.name ?? ''}",
                avatarFile,
              );

          final String publicUrl = supaBase.storage
              .from('post-files')
              .getPublicUrl(img?.name ?? '');

          imageUrlList.add(publicUrl);
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
}
