import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const double _kNavBarHeight = 60;
const String _kNavBarOrderKey = 'billing_navbar_order_v1';

class MyNavBar extends StatefulWidget {
  final Function(int) onItemSelected;
  final List<String> navBarTitles;
  final List<String> activeIcons;
  final List<String> inactiveIcons;
  final int currentIndex;

  const MyNavBar({
    super.key,
    required this.onItemSelected,
    required this.navBarTitles,
    required this.activeIcons,
    required this.inactiveIcons,
    this.currentIndex = 0,
  });

  @override
  State<MyNavBar> createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> {
  final ScrollController _scrollController = ScrollController();
  List<_NavBarItemData> _orderedItems = [];
  bool _isReordering = false;

  @override
  void initState() {
    super.initState();
    _orderedItems = _getDefaultItems();
    _restoreOrder();
  }

  List<_NavBarItemData> _getDefaultItems() {
    final items = <_NavBarItemData>[];
    final count = widget.navBarTitles.length;
    if (count != widget.activeIcons.length ||
        count != widget.inactiveIcons.length) {
      return items;
    }

    for (var i = 0; i < count; i++) {
      items.add(_NavBarItemData(
        title: widget.navBarTitles[i],
        activeIcon: widget.activeIcons[i],
        inactiveIcon: widget.inactiveIcons[i],
        itemIndex: i,
        isActive: widget.currentIndex == i,
      ));
    }
    return items;
  }

  Future<void> _restoreOrder() async {
    final defaultItems = _getDefaultItems();
    if (defaultItems.isEmpty) return;

    final savedTitles = await _loadOrder();
    final ordered = <_NavBarItemData>[];

    if (savedTitles != null && savedTitles.isNotEmpty) {
      for (final title in savedTitles) {
        final match = defaultItems.where((item) => item.title == title);
        if (match.isEmpty) continue;
        ordered.add(match.first);
      }
    }

    for (final item in defaultItems) {
      final exists = ordered.any((saved) => saved.title == item.title);
      if (!exists) {
        ordered.add(item);
      }
    }

    if (!mounted) return;
    setState(() {
      _orderedItems = ordered;
    });
  }

  Future<List<String>?> _loadOrder() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final orderJson = prefs.getString(_kNavBarOrderKey);
      if (orderJson == null || orderJson.isEmpty) return null;
      final decoded = json.decode(orderJson);
      if (decoded is! List) return null;
      return decoded.map((item) => item.toString()).toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveOrder(List<_NavBarItemData> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _kNavBarOrderKey,
        json.encode(items.map((item) => item.title).toList()),
      );
    } catch (_) {}
  }

  @override
  void didUpdateWidget(MyNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    final currentCount = widget.navBarTitles.length;
    final oldCount = oldWidget.navBarTitles.length;

    if (currentCount != oldCount || _orderedItems.isEmpty) {
      _restoreOrder();
      return;
    }

    final latestItems = _getDefaultItems();
    final updatedItems = <_NavBarItemData>[];

    for (final orderedItem in _orderedItems) {
      final latest = latestItems.where(
        (item) => item.itemIndex == orderedItem.itemIndex,
      );
      if (latest.isEmpty) continue;
      updatedItems.add(latest.first);
    }

    for (final item in latestItems) {
      final exists = updatedItems.any(
        (saved) => saved.itemIndex == item.itemIndex,
      );
      if (!exists) {
        updatedItems.add(item);
      }
    }

    setState(() {
      _orderedItems = updatedItems;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToActiveItem();
    });
  }

  void _scrollToActiveItem() {
    if (!_scrollController.hasClients || _orderedItems.isEmpty) return;

    final activeIndex = _orderedItems.indexWhere((item) => item.isActive);
    if (activeIndex == -1) return;

    const itemWidth = 120.0;
    final targetOffset = (activeIndex * itemWidth) -
        (MediaQuery.of(context).size.width / 2) +
        (itemWidth / 2);

    _scrollController.animateTo(
      targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final navBarContent = Container(
      height: _kNavBarHeight,
      decoration: BoxDecoration(
        color: const Color(0xffF4F7FD),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: _orderedItems.isEmpty
          ? const SizedBox.shrink()
          : ReorderableListView.builder(
              scrollController: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              itemCount: _orderedItems.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final item = _orderedItems.removeAt(oldIndex);
                  _orderedItems.insert(newIndex, item);
                  _isReordering = false;
                });
                _saveOrder(_orderedItems);
              },
              onReorderStart: (index) {
                HapticFeedback.mediumImpact();
                setState(() {
                  _isReordering = true;
                });
              },
              onReorderEnd: (index) {
                setState(() {
                  _isReordering = false;
                });
              },
              proxyDecorator: (child, index, animation) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, _) {
                    final item = _orderedItems[index];
                    return Transform.scale(
                      scale: 1.0 + (animation.value * 0.1),
                      child: Opacity(
                        opacity: 0.9,
                        child: _NavBarItem(
                          key: ValueKey('proxy_${item.itemIndex}'),
                          data: item,
                          isReordering: true,
                          onTap: () {},
                        ),
                      ),
                    );
                  },
                );
              },
              itemBuilder: (context, index) {
                final item = _orderedItems[index];
                return _NavBarItem(
                  key: ValueKey('nav_${item.itemIndex}'),
                  data: item,
                  isReordering: _isReordering,
                  onTap: () {
                    if (_isReordering) return;
                    widget.onItemSelected(item.itemIndex);
                  },
                );
              },
            ),
    );

    if (Platform.isIOS) {
      return SafeArea(
        top: false,
        bottom: true,
        child: navBarContent,
      );
    }

    return SafeArea(
      top: false,
      child: navBarContent,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class _NavBarItemData {
  final String title;
  final String activeIcon;
  final String inactiveIcon;
  final int itemIndex;
  final bool isActive;

  const _NavBarItemData({
    required this.title,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.itemIndex,
    required this.isActive,
  });
}

class _NavBarItem extends StatelessWidget {
  final _NavBarItemData data;
  final VoidCallback onTap;
  final bool isReordering;

  static const double _iconSize = 22;

  const _NavBarItem({
    required Key key,
    required this.data,
    required this.onTap,
    this.isReordering = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: data.isActive
              ? const Color(0xff1E2E52)
              : const Color(0xffF4F7FD),
          border: Border.all(
            color: const Color(0xff1E2E52).withValues(alpha: 0.5),
            width: data.isActive ? 0 : 0.5,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: data.isActive
              ? [
                  BoxShadow(
                    color: const Color(0xff1E2E52).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : const [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isReordering)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Icon(
                  Icons.drag_indicator,
                  size: 18,
                  color: data.isActive
                      ? const Color(0xffF4F7FD)
                      : const Color(0xff1E2E52).withValues(alpha: 0.5),
                ),
              ),
            _NavBarIcon(
              path: data.isActive ? data.activeIcon : data.inactiveIcon,
              isActive: data.isActive,
              size: _iconSize,
            ),
            const SizedBox(width: 8),
            Text(
              data.title,
              style: TextStyle(
                color: data.isActive
                    ? const Color(0xffF4F7FD)
                    : const Color(0xff1E2E52),
                fontFamily: 'Golos',
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarIcon extends StatelessWidget {
  final String path;
  final bool isActive;
  final double size;

  const _NavBarIcon({
    required this.path,
    required this.isActive,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xffF4F7FD) : const Color(0xff1E2E52);

    if (path.startsWith('material:')) {
      return Icon(
        _materialIcon(path.substring('material:'.length)),
        size: size,
        color: color,
      );
    }

    return Image.asset(
      path,
      width: size,
      height: size,
      color: color,
    );
  }

  IconData _materialIcon(String name) {
    switch (name) {
      case 'smart_toy':
        return Icons.smart_toy_outlined;
      case 'receipt_long':
        return Icons.receipt_long;
      default:
        return Icons.circle_outlined;
    }
  }
}
