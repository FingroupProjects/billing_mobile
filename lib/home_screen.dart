import 'package:billing_mobile/MyNavBar.dart';
import 'package:billing_mobile/screens/demo/demo_clients_screen.dart';
import 'package:billing_mobile/screens/inActive/inactive_clients_screen.dart';
import 'package:billing_mobile/screens/profile/profile_screen.dart';
import 'package:billing_mobile/screens/clients/clients_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  List<Widget> _widgetOptions = [];
  List<String> _titleKeys = [];
  List<String> _navBarTitleKeys = [];
  List<String> _activeIcons = [];
  List<String> _inactiveIcons = [];

  @override
  void initState() {
    super.initState();

    initializeScreensWithPermissions();
  }

  Future<void> initializeScreensWithPermissions() async {
  List<Widget> widgets = [];
  List<String> titleKeys = [];
  List<String> navBarTitleKeys = [];
  List<String> activeIcons = [];
  List<String> inactiveIcons = [];

    widgets.add(ClientsScreen());
    titleKeys.add('Аппбар клиент');
    navBarTitleKeys.add('Клиенты');
    activeIcons.add('assets/icons/MyNavBar/clients_ON.png');
    inactiveIcons.add('assets/icons/MyNavBar/clients_OFF.png');

    widgets.add(DemoClientsScreen());
    titleKeys.add('Аппбар демо');
    navBarTitleKeys.add('Демо');
    activeIcons.add('assets/icons/MyNavBar/demo_ON.png');
    inactiveIcons.add('assets/icons/MyNavBar/demo_OFF.png');
    
    widgets.add(InActiveClientsScreen());
    titleKeys.add('Аппбар Неактивный');
    navBarTitleKeys.add('Неактивный');
    activeIcons.add('assets/icons/MyNavBar/inactive_ON.png');
    inactiveIcons.add('assets/icons/MyNavBar/inactive_OFF.png');


  if (mounted) {
    setState(() {
      _widgetOptions = widgets;
      _titleKeys = titleKeys;
      _navBarTitleKeys = navBarTitleKeys;
      _activeIcons = activeIcons;
      _inactiveIcons = inactiveIcons;
    });
  }
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: _selectedIndex == -1 
        ? ProfileScreen()
        : (_widgetOptions.isNotEmpty &&
                _selectedIndex >= 0 &&
                _selectedIndex < _widgetOptions.length
            ? _widgetOptions[_selectedIndex]
            : const Center(
                child: Text('Нет доступных экранов'),
              )),
    backgroundColor: Colors.white,
    bottomNavigationBar: _widgetOptions.isNotEmpty
        ? MyNavBar(
            currentIndex: _selectedIndex,
            onItemSelected: (index) {
              setState(() {
                _selectedIndex = index;
                _isSearching = false;
              });
            },
            navBarTitles: _navBarTitleKeys
                .map((key) => (key))
                .toList(), 
            activeIcons: _activeIcons,
            inactiveIcons: _inactiveIcons,
          )
        : null,
  );
}
}