import 'package:billing_mobile/api/api_service.dart';
import 'package:billing_mobile/bloc/clients/clients_bloc.dart';
import 'package:billing_mobile/bloc/clients/clients_event.dart';
import 'package:billing_mobile/bloc/clients/clients_state.dart';
import 'package:billing_mobile/custom_widget/custom_app_bar.dart';
import 'package:billing_mobile/custom_widget/custom_button.dart';
import 'package:billing_mobile/custom_widget/filter/filter_client_app_bar.dart';
import 'package:billing_mobile/screens/clients/clients_add_screen.dart';
import 'package:billing_mobile/screens/clients/clients_card.dart';
import 'package:billing_mobile/screens/clients/client_details/clients_details_screen.dart';
import 'package:billing_mobile/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  Map<String, dynamic> _currentFilters = {};
  final ApiService _apiService = ApiService(); // Добавляем ApiService

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<ClientBloc>().add(FetchClients());
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
    });
    context.read<ClientBloc>().add(SearchClients(_searchController.text));
  }

  void _onScroll() {
    final state = context.read<ClientBloc>().state;
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        (state is ClientLoaded && !state.isLoadingMore)) {
      context.read<ClientBloc>().add(FetchMoreClients());
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

  Widget _buildClientsList(ClientLoaded state) {
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
          style: TextStyle(
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
          return ClientCard(
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
              padding: EdgeInsets.all(16.0),
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
          title: isClickAvatarIcon ? 'Настройка' : 'Клиенты',
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
                builder: (context) => FilterClientScreen(
                  onFilterSelected: (filters) {
                    setState(() {
                      _currentFilters = filters;
                      print('Applied filters: $_currentFilters');
                    });
                    context.read<ClientBloc>().add(ApplyFilters(filters));
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
              context.read<ClientBloc>().add(SearchClients(''));
            }
          },
        ),
      ),
      body: isClickAvatarIcon
          ? const ProfileScreen()
          : BlocBuilder<ClientBloc, ClientState>(
              builder: (context, state) {
                if (state is ClientLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xff1E2E52)),
                  );
                } else if (state is ClientError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${state.message}'),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  buttonText: 'Обновить',
                                  buttonColor: Color(0xff4759FF),
                                  textColor: Colors.white,
                                  onPressed: () {
                                    context
                                        .read<ClientBloc>()
                                        .add(FetchClients());
                                  },
                                  child: const Text(
                                    'Повторить попытку',
                                    style: TextStyle(
                                        color: Colors.white, fontFamily: 'Gilroy'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                } else if (state is ClientLoaded) {
                  return RefreshIndicator(
                    color: const Color(0xff1E2E52),
                    backgroundColor: Colors.white,
                    onRefresh: () async {
                      context.read<ClientBloc>().add(FetchClients());
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
      context.read<ClientBloc>().add(FetchClients());
    }
  },
  backgroundColor: const Color(0xff1E2E52),
  child: const Icon(Icons.add, color: Colors.white),
),
    );
  }
}