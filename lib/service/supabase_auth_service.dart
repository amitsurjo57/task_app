import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_app/models/supabase_models.dart';
import 'package:task_app/service/shared_preference_service.dart';

import '../main.dart';

class SupabaseAuthService {
  static Future<SupabaseModel> signUp({
    required String email,
    required String password,
    required String name,
    MemoryImage? memoryImage,
    XFile? imageFile,
  }) async {
    try {
      final res = await supaBase.auth.signUp(email: email, password: password);

      final userProfile = File(imageFile?.path ?? "");

      await supaBase.storage
          .from('user-files')
          .upload(
            "${res.user?.id ?? ''}/profile picture/${imageFile?.name ?? ""}",
            userProfile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final String imageUrl = supaBase.storage
          .from('user-profiles-picture')
          .getPublicUrl(imageFile?.name ?? "");

      await supaBase.from('user_list').insert({
        'id': res.user?.id ?? " ",
        'name': name,
        'email': email,
        'password': password,
        'image_url': imageUrl,
      });

      SharedPreferenceService sharedPreferenceService =
          SharedPreferenceService();
      await sharedPreferenceService.saveUserId(res.user?.id ?? '');
      await sharedPreferenceService.saveUserName(name);
      await sharedPreferenceService.saveUserEmail(email);
      await sharedPreferenceService.saveUserImage(imageUrl);

      return SupabaseModel(
        response: res,
        isSuccessful: true,
        message: "Logged In Successfully",
      );
    } on AuthApiException catch (e) {
      debugPrint(e.toString());
      if (e.code == 'user_already_exists') {
        return SupabaseModel(
          isSuccessful: false,
          message: e.message.toString(),
        );
      } else if (e.code == "validation_failed") {
        return SupabaseModel(
          isSuccessful: false,
          message: "Please Enter a Valid Email",
        );
      }
    }
    return SupabaseModel(isSuccessful: false, message: "Something went wrong");
  }

  static Future<SupabaseModel> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse res = await supaBase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.user?.id == null) {
        return SupabaseModel(message: "User Not Found", isSuccessful: false);
      } else {
        final data = await supaBase
            .from('user_list')
            .select()
            .eq('id', res.user?.id ?? '');

        SharedPreferenceService sharedPreferenceService =
            SharedPreferenceService();
        for (var dt in data) {
          await sharedPreferenceService.saveUserId(dt['id']);
          await sharedPreferenceService.saveUserName(dt['name']);
          await sharedPreferenceService.saveUserEmail(dt['email']);
          await sharedPreferenceService.saveUserImage(dt['image_url']);
        }

        return SupabaseModel(
          message: "Logged In Successfully",
          isSuccessful: true,
        );
      }
    } on AuthApiException catch (e) {
      debugPrint(e.toString());
      if (e.code == "invalid_credentials") {
        debugPrint(e.toString());
        return SupabaseModel(message: "User Not Found", isSuccessful: false);
      } else {
        return SupabaseModel(
          message: "Something went wrong",
          isSuccessful: false,
        );
      }
    }
  }

  static Future<void> signOut() async {
    await SharedPreferenceService().clearData();
    await supaBase.auth.signOut();
  }
}
