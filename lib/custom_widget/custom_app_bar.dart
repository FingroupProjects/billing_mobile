import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget {
  String title;
  Function() onClickProfileAvatar;
  FocusNode focusNode;
  TextEditingController textEditingController;
  ValueChanged<String>? onChangedSearchInput;
  Function(bool) clearButtonClick;
  Function(bool) clearButtonClickFiltr;
  final bool showSearchIcon;
  final bool showFilterIcon;
  final VoidCallback? onFilterTap;
  final bool isFilterActive; 

  CustomAppBar({
    super.key,
    required this.title,
    required this.onClickProfileAvatar,
    this.onFilterTap,
    required this.onChangedSearchInput,
    required this.textEditingController,
    required this.focusNode,
    required this.clearButtonClick,
    required this.clearButtonClickFiltr,
    this.showSearchIcon = true,
    this.showFilterIcon = false,
    this.isFilterActive = false, 
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  late TextEditingController _searchController;
  late FocusNode focusNode;
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _searchController = widget.textEditingController;
    focusNode = widget.focusNode;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _colorAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.white,
    ).animate(_animationController);

    if (widget.isFilterActive) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(CustomAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFilterActive != oldWidget.isFilterActive) {
      if (widget.isFilterActive) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.stop();
        _animationController.reset();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: kToolbarHeight,
      color: Colors.white,
      padding: EdgeInsets.zero,
      child: Row(children: [
        Container(
          width: 50,
          height: 50,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Image.asset('assets/icons/AppBar/Avatar.png'),
            onPressed: widget.onClickProfileAvatar,
          ),
        ),
        SizedBox(width: 8),
        if (!_isSearching)
          Expanded(
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
                color: Color(0xff1E2E52), 
              ),
            ),
          ),
        if (_isSearching)
          Expanded(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: _isSearching ? 200.0 : 0.0,
              child: TextField(
                controller: _searchController,
                focusNode: focusNode,
                onChanged: widget.onChangedSearchInput,
                decoration: const InputDecoration(
                  hintText: 'Поиск',
                  hintStyle: TextStyle(fontFamily: 'Gilroy', color: Color(0xff99A4BA), fontSize: 16),
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 16),
                autofocus: true,
              ),
            ),
          ),
        if (widget.showSearchIcon)
          Transform.translate(
            offset: const Offset(10, 0),
            child: Tooltip(
              message: 'Поиск',
              preferBelow: false,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              textStyle: TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: _isSearching
                    ? Icon(Icons.close)
                    : Image.asset(
                        'assets/icons/AppBar/search.png',
                        width: 24,
                        height: 24,
                      ),
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (!_isSearching) {
                      _searchController.clear();
                      FocusScope.of(context).unfocus();
                    }
                  });

                  widget.clearButtonClick(_isSearching);

                  if (_isSearching) {
                    Future.delayed(Duration(milliseconds: 100), () {
                      FocusScope.of(context).requestFocus(focusNode);
                    });
                  }
                },
              ),
            ),
          ),
        if (widget.showFilterIcon)
          IconButton(
            icon: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) {
                  return Image.asset(
                    'assets/icons/AppBar/filter.png',
                    width: 24,
                    height: 24,
                    color: widget.isFilterActive ? _colorAnimation.value : null,
                  );
                },
              ),
            ),
            onPressed: () {
              widget.onFilterTap!();
            },
          ),
      ]),
    );
  }
}