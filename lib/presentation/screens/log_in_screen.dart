import 'package:flutter/material.dart';
import 'package:task_app/models/supabase_models.dart';
import 'package:task_app/presentation/screens/feed_screen.dart';
import 'package:task_app/presentation/screens/sign_up_screen.dart';
import 'package:task_app/service/supabase_auth_service.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  bool _isObscure = true;
  bool _inProgress = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<void> _onTapLogIn() async {
    if (!_globalKey.currentState!.validate()) {
      return;
    }

    _inProgress = true;
    setState(() {});
    final SupabaseModel supabaseModel = await SupabaseAuthService.logIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
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
      debugPrint("Message: ${supabaseModel.message}");
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                _header(),
                _emailTextFormField(),
                _passwordTextFormField(),
                _logInButton(),
                _navigateToSignUp(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logInButton() {
    return Visibility(
      visible: !_inProgress,
      replacement: Center(child: CircularProgressIndicator()),
      child: ElevatedButton(
        onPressed: _onTapLogIn,
        child: Text("Log In"),
      ),
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
      "Log In",
      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
    );
  }

  Widget _navigateToSignUp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't Have an Account?", style: TextStyle(fontSize: 20)),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          child: Text(
            "Sign Up",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
