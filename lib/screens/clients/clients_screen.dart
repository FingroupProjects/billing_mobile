import 'package:billing_mobile/bloc/clients/clients_bloc.dart';
import 'package:billing_mobile/bloc/clients/clients_event.dart';
import 'package:billing_mobile/bloc/clients/clients_state.dart';
import 'package:billing_mobile/custom_widget/custom_app_bar.dart';
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

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<ClientBloc>().add(FetchClients());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
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
          showFilterOrderIcon: false,
          showFilterIcon: true,
          onChangedSearchInput: (input) {
            // Фильтрация по вводу
            // context.read<ClientBloc>().add(FilterClients(input));
          },
          textEditingController: _searchController,
          focusNode: _searchFocusNode,
          clearButtonClick: (isSearching) {
            setState(() {
              _isSearching = isSearching;
              if (!isSearching) {
                _searchController.clear();
                context.read<ClientBloc>().add(FetchClients());
              }
            });
          },
        ),
      ),
      body: isClickAvatarIcon
          ? const ProfileScreen()
          : BlocBuilder<ClientBloc, ClientState>(
              builder: (context, state) {
                if (state is ClientLoading) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xff1E2E52)));
                } else if (state is ClientError) {
                  print(state.message);
                  return Center(child: Text('Ошибка: ${state.message}'));
                } else if (state is ClientLoaded) {
                  return RefreshIndicator(
                    color: const Color(0xff1E2E52),
                    backgroundColor: Colors.white,
                    onRefresh: () async {
                      context.read<ClientBloc>().add(FetchClients());
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: state.clientData.data.clients.data.length + (state.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < state.clientData.data.clients.data.length) {
                          final client = state.clientData.data.clients.data[index];
                          return ClientCard(
                            client: client,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ClientDetailsScreen(clientId: client.id)),
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
                    ),
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