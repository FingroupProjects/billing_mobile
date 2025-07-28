import 'package:billing_mobile/models/user.dart';
import 'package:billing_mobile/screens/profile/profile_widget/profile_button.dart';
import 'package:billing_mobile/screens/profile/profile_widget/profile_logout.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final User user; // Добавляем поле для объекта User
  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileEdit(user: widget.user),
                            LogoutButtonWidget(),

            ],
          ),
        ),
      ),
    );
  }
}
