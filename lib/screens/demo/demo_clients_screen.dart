import 'package:billing_mobile/bloc/clients_demo/demo_clients_bloc.dart';
import 'package:billing_mobile/bloc/clients_demo/demo_clients_event.dart';
import 'package:billing_mobile/bloc/clients_demo/demo_clients_state.dart';
import 'package:billing_mobile/custom_widget/custom_app_bar.dart';
import 'package:billing_mobile/custom_widget/custom_button.dart';
import 'package:billing_mobile/custom_widget/filter/filter_demo_app_bar.dart';
import 'package:billing_mobile/screens/clients/clients_add_screen.dart';
import 'package:billing_mobile/screens/clients/client_details/clients_details_screen.dart';
import 'package:billing_mobile/screens/demo/demo_clients_card.dart';
import 'package:billing_mobile/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DemoClientsScreen extends StatefulWidget {
  @override
  _DemoClientsScreenState createState() => _DemoClientsScreenState();
}

class _DemoClientsScreenState extends State<DemoClientsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;
  bool isClickAvatarIcon = false;
  late ScrollController _scrollController;
  Map<String, dynamic> _currentFilters = {};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<DemoBloc>().add(FetchDemo());
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
    });
    context.read<DemoBloc>().add(SearchDemo(_searchController.text));
  }

  void _onScroll() {
    final state = context.read<DemoBloc>().state;
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        (state is DemoLoaded && !state.isLoadingMore)) {
      context.read<DemoBloc>().add(FetchMoreDemo());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Widget _buildClientsList(DemoLoaded state) {
    final clients = state.clientData.data.clients.data;
    
    if (_isSearching && clients.isEmpty) {
      return const Center(
        child: Text(
          'Ничего не найдено',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w500,
            color: Color(0xff99A4BA),
          ),
        ),
      );
    } else if (clients.isEmpty) {
      return const Center(
        child: Text(
          'Нет клиентов',
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w500,
            color: Color(0xff99A4BA),
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: clients.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < clients.length) {
          final client = clients[index];
          return DemoClientCard(
            client: client,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClientDetailsScreen(clientId: client.id),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(color: Color(0xff1E2E52)),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: CustomAppBar(
          title: isClickAvatarIcon ? 'Настройка' : 'Демо',
          onClickProfileAvatar: () {
            setState(() {
              isClickAvatarIcon = !isClickAvatarIcon;
            });
          },
          clearButtonClickFiltr: (isSearching) {},
          showSearchIcon: true,
          showFilterIcon: true,
          isFilterActive: _currentFilters.isNotEmpty, 
          onChangedSearchInput: (String value) {},
          onFilterTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FilterDemoScreen(
                  onFilterSelected: (filters) {
                    setState(() {
                      _currentFilters = filters;
                    });
                    context.read<DemoBloc>().add(DemoApplyFilters(filters));
                  },
                  initialFilters: _currentFilters,
                ),
              ),
            );
          },
          textEditingController: _searchController,
          focusNode: _searchFocusNode,
          clearButtonClick: (value) {
            if (value == false) {
              setState(() {
                _isSearching = false;
                _searchController.clear();
              });
              context.read<DemoBloc>().add(SearchDemo(''));
            }
          },
        ),
      ),
      body: isClickAvatarIcon
          ? const ProfileScreen()
          : BlocBuilder<DemoBloc, DemoState>(
              builder: (context, state) {
                if (state is DemoLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xff1E2E52)),
                  );
                } else if (state is DemoError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                  Text('${state.message}'),
                  const SizedBox(height: 16),
                  Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                            child: CustomButton(
                            buttonText: 'Обновить',
                            buttonColor: Color(0xff4759FF),
                            textColor: Colors.white,
                            onPressed: () { context.read<DemoBloc>().add(FetchDemo());},
                            child: const Text('Повторить попытку', style: TextStyle(color: Colors.white, fontFamily: 'Gilroy'),
                            ),
                                 ),
                             ),
                           ],
                         ),
                       )
                      ],
                    ),
                  );
                } else if (state is DemoLoaded) {
                  return RefreshIndicator(
                    color: const Color(0xff1E2E52),
                    backgroundColor: Colors.white,
                    onRefresh: () async {
                      context.read<DemoBloc>().add(FetchDemo());
                    },
                    child: _buildClientsList(state),
                  );
                }
                return const Center(child: Text('Нет данных'));
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ClientAddScreen()),
          );
          if (result == true) {
            context.read<DemoBloc>().add(FetchDemo());
          }
        },
        backgroundColor: const Color(0xff1E2E52),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}