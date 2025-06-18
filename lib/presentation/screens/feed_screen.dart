import 'package:flutter/material.dart';
import 'package:task_app/presentation/screens/log_in_screen.dart';
import 'package:task_app/presentation/screens/share_screen.dart';
import 'package:task_app/presentation/widgets/post_widget.dart';
import 'package:task_app/service/shared_preference_service.dart';
import 'package:task_app/service/supabase_auth_service.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String? name;
  String? image;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    SharedPreferenceService sharedPreferenceService = SharedPreferenceService();
    name = await sharedPreferenceService.getUserName();
    image = await sharedPreferenceService.getUserImage();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      endDrawer: _buildDrawer(),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          spacing: 16,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShareScreen()),
                    );
                  },
                  child: Container(
                    height: 60,
                    width: MediaQuery.sizeOf(context).width / 2 - 16,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FittedBox(
                      child: Row(
                        spacing: 8,
                        children: [
                          Text(
                            "Share Your Experience",
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(Icons.share, color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: MediaQuery.sizeOf(context).width / 2 - 16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: FittedBox(
                    child: Row(
                      spacing: 8,
                      children: [
                        Text(
                          "Ask A Question",
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.question_mark,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  Text(
                    "Search",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Icon(Icons.search, color: Colors.white),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset('assets/images/airline.png'),
            ),
            PostWidget(),
          ],
        ),
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: Center(
        child: ElevatedButton(
          onPressed: () async {
            await SupabaseAuthService.signOut();
            if (mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LogInScreen()),
                (_) => false,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Signed Out Successfully")),
              );
            }
          },
          style: ElevatedButton.styleFrom(minimumSize: Size(200, 52)),
          child: Text("Sign Out"),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Airline Review"),
      titleTextStyle: TextStyle(fontSize: 24, color: Colors.black),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.notifications_outlined)),
        CircleAvatar(
          backgroundImage: image == null ? null : NetworkImage(image!),
        ),
        Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: Icon(Icons.menu),
            );
          },
        ),
      ],
    );
  }
}
