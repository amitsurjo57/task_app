import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  final String _id = "id";
  final String _name = "name";
  final String _email = "email";
  final String _image = "image";

  Future<void> saveUserId(String id) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    sharedPreferences.setString(_id, id);
  }

  Future<void> saveUserName(String name) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    sharedPreferences.setString(_name, name);
  }

  Future<void> saveUserEmail(String email) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    sharedPreferences.setString(_email, email);
  }

  Future<void> saveUserImage(String image) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    sharedPreferences.setString(_image, image);
  }

  Future<String?> getUserId() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    return sharedPreferences.getString(_id);
  }

  Future<String?> getUserName() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    return sharedPreferences.getString(_name);
  }

  Future<String?> getUserEmail() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    return sharedPreferences.getString(_email);
  }

  Future<String?> getUserImage() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    return sharedPreferences.getString(_image);
  }

  Future<void> clearData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    await sharedPreferences.clear();
  }
}
