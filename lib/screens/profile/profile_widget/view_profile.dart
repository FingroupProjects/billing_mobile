import 'package:billing_mobile/models/user.dart';
import 'package:flutter/material.dart';

class ViewProfile extends StatelessWidget {
  final User user;

  const ViewProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff4F40EC)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Профиль',
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Color(0xffF0EFFF),
              ],
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 20),
              // Аватар
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/icons/shamCRM.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Карточка с данными
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileItem(
                      icon: Icons.person,
                      label: 'Имя',
                      value: user.name ?? 'Не указано',
                    ),
                    _buildDivider(),
                    _buildProfileItem(
                      icon: Icons.phone,
                      label: 'Телефон',
                      value: user.phone ?? 'Не указано',
                    ),
                    _buildDivider(),
                    _buildProfileItem(
                      icon: Icons.login,
                      label: 'Логин',
                      value: user.login ?? 'Не указано',
                    ),
                    _buildDivider(),
                    _buildProfileItem(
                      icon: Icons.email,
                      label: 'Email',
                      value: user.email ?? 'Не указано',
                    ),
                    _buildDivider(),
                    _buildProfileItem(
                      icon: Icons.work,
                      label: 'Роль',
                      value: user.role ?? 'Не указано',
                    ),
                    if (user.address != null) ...[
                      _buildDivider(),
                      _buildProfileItem(
                        icon: Icons.location_on,
                        label: 'Адрес',
                        value: user.address!,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 Widget _buildProfileItem({
  required IconData icon,
  required String label,
  required String value,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center, // Центрируем иконку по вертикали
    children: [
      Icon(
        icon,
        color: const Color(0xff4F40EC),
        size: 24,
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // чтобы колонка не занимала всю высоту
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xff99A4BA),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}


  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(
        color: Colors.grey.withOpacity(0.2),
        height: 1,
      ),
    );
  }
}