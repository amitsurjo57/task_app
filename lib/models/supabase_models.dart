import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseModel {
  final AuthResponse? response;
  final bool isSuccessful;
  final String message;

  SupabaseModel({
    this.response,
    required this.message,
    required this.isSuccessful,
  });
}
