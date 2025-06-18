import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_app/presentation/screens/feed_screen.dart';

import '../../service/supabase_auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _pickImageController = TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  MemoryImage? _memoryImage;
  XFile? _imageFile;

  bool _isObscure = true;
  bool _inProgress = false;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _pickImageController.dispose();
  }

  Future<void> _onTapPickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      _memoryImage = MemoryImage(await image.readAsBytes());
      _imageFile = image;
    }

    setState(() {});
  }

  Future<void> _onTapSignUp() async {
    if (!_globalKey.currentState!.validate()) {
      return;
    }

    if (_imageFile == null || _memoryImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("You should upload your photo")));
      return;
    }

    _inProgress = true;
    setState(() {});
    final supabaseModel = await SupabaseAuthService.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      name: _nameController.text,
      memoryImage: _memoryImage,
      imageFile: _imageFile,
    );
    _inProgress = false;
    setState(() {});

    if (supabaseModel.isSuccessful) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(supabaseModel.message)));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => FeedScreen()),
          (_) => false,
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(supabaseModel.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _globalKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  _header(),
                  _pickImage(),
                  _nameTextFormField(),
                  _emailTextFormField(),
                  _passwordTextFormField(),
                  _signUpButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return Visibility(
      visible: !_inProgress,
      replacement: Center(child: CircularProgressIndicator()),
      child: ElevatedButton(onPressed: _onTapSignUp, child: Text("Sign Up")),
    );
  }

  TextFormField _passwordTextFormField() {
    return TextFormField(
      controller: _passwordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: Colors.black,
      obscureText: _isObscure,
      decoration: InputDecoration(
        hintText: "Enter Password",
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
          child: Icon(
            _isObscure ? Icons.visibility : Icons.visibility_off,
            size: 28,
            color: Colors.black,
          ),
        ),
        prefixIcon: Icon(Icons.lock, size: 32, color: Colors.black),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Password Can't be Empty";
        } else if (value.length < 6) {
          return "Password's length should be at least 6";
        }
        return null;
      },
    );
  }

  TextFormField _nameTextFormField() {
    return TextFormField(
      controller: _nameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        hintText: "Enter Your Name",
        prefixIcon: Icon(Icons.person, size: 32, color: Colors.black),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter Your Name";
        }

        return null;
      },
    );
  }

  TextFormField _emailTextFormField() {
    return TextFormField(
      controller: _emailController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        hintText: "Enter Your Email",
        prefixIcon: Icon(Icons.person, size: 32, color: Colors.black),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter Your Email";
        }

        return null;
      },
    );
  }

  Text _header() {
    return Text(
      "Sign Up",
      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
    );
  }

  Widget _pickImage() {
    return GestureDetector(
      onTap: _onTapPickImage,
      child: Column(
        children: [
          CircleAvatar(
            radius: 44,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: _memoryImage,
            child: _memoryImage == null
                ? Icon(Icons.person, color: Colors.black, size: 60)
                : null,
          ),
          Text(
            "Pick Your Image",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
