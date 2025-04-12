import 'package:billing_mobile/custom_widget/custom_app_bar.dart';
import 'package:billing_mobile/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';


class ClientsScreen extends StatefulWidget {
  @override
  _ClientsScreenState createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;
  bool isClickAvatarIcon = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    // context.read<GoodsBloc>().add(FetchGoods());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    // if (_scrollController.position.pixels ==
    //         _scrollController.position.maxScrollExtent &&
    //     !(context.read<GoodsBloc>().allGoodsFetched)) {
    //   final state = context.read<GoodsBloc>().state;
    //   if (state is GoodsDataLoaded) {
    //     context.read<GoodsBloc>().add(FetchMoreGoods(state.currentPage));
    //   }
    // }
  }
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: CustomAppBar(
          title: isClickAvatarIcon ? 'Настройка' : 'Клиент',
          onClickProfileAvatar: () {
            setState(() {
              isClickAvatarIcon = !isClickAvatarIcon;
            });
          },
          clearButtonClickFiltr: (isSearching) {},
          showSearchIcon: true,
          showFilterOrderIcon: false,
          showFilterIcon: true,
          onChangedSearchInput: (input) {},
          textEditingController: _searchController,
          focusNode: _searchFocusNode,
          clearButtonClick: (isSearching) {},
        ),
      ),
      body: isClickAvatarIcon
          ? const ProfileScreen()
          : Center(child: Text("Список клиентов")), 
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // final result = await Navigator.push(
          //   context,
          //   // MaterialPageRoute(builder: (context) => GoodsAddScreen()),
          // );
          // if (result == true) {
          //   context.read<GoodsBloc>().add(FetchGoods());
          // }
        },
        backgroundColor: const Color(0xff1E2E52),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}