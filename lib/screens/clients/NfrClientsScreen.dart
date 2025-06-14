
import 'package:billing_mobile/bloc/clients/NfrClientBloc.dart';
import 'package:billing_mobile/bloc/clients/clients_bloc.dart';
import 'package:billing_mobile/bloc/clients/clients_event.dart';
import 'package:billing_mobile/custom_widget/custom_app_bar.dart';
import 'package:billing_mobile/custom_widget/custom_button.dart';
import 'package:billing_mobile/custom_widget/filter/filter_client_app_bar.dart';
import 'package:billing_mobile/screens/clients/client_details/clients_details_screen.dart';
import 'package:billing_mobile/screens/clients/clients_add_screen.dart';
import 'package:billing_mobile/screens/clients/clients_card.dart';
import 'package:billing_mobile/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NfrClientsScreen extends StatefulWidget {
  @override
  _NfrClientsScreenState createState() => _NfrClientsScreenState();
}

class _NfrClientsScreenState extends State<NfrClientsScreen> {
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
    context.read<NfrClientBloc>().add(FetchNfrClients());
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
    });
    context.read<NfrClientBloc>().add(SearchNfrClients(_searchController.text));
  }

  void _onScroll() {
    final state = context.read<NfrClientBloc>().state;
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        (state is NfrClientLoaded && !state.isLoadingMore)) {
      context.read<NfrClientBloc>().add(FetchMoreNfrClients());
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

  Widget _buildNfrClientsList(NfrClientLoaded state) {
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
          'Нет NFR клиентов',
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
          title: isClickAvatarIcon ? 'Настройка' : 'NFR Клиенты',
          onClickProfileAvatar: () {
            setState(() {
              isClickAvatarIcon = !isClickAvatarIcon;
            });
          },
          showSearchIcon: true,
          showFilterIcon: true,
          isFilterActive: _currentFilters.isNotEmpty,
          onFilterTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FilterClientScreen(
                  onFilterSelected: (filters) {
                    setState(() {
                      _currentFilters = filters;
                                            print('Applied filters: $_currentFilters'); // Debug: Log filters to verify country_id

                    });
                    context.read<NfrClientBloc>().add(ApplyNfrFilters(filters));
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
              context.read<NfrClientBloc>().add(SearchNfrClients(''));
            }
          }, onChangedSearchInput: (String value) {  }, clearButtonClickFiltr: (bool p1) {  },
        ),
      ),
      body: isClickAvatarIcon
          ? const ProfileScreen()
          : BlocBuilder<NfrClientBloc, NfrClientState>(
              builder: (context, state) {
                if (state is NfrClientLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xff1E2E52)),
                  );
                } else if (state is NfrClientError) {
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
                                  onPressed: () {
                                    context.read<NfrClientBloc>().add(FetchNfrClients());
                                  },
                                  child: const Text(
                                    'Повторить попытку',
                                    style: TextStyle(color: Colors.white, fontFamily: 'Gilroy'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is NfrClientLoaded) {
                  return RefreshIndicator(
                    color: const Color(0xff1E2E52),
                    backgroundColor: Colors.white,
                    onRefresh: () async {
                      context.read<NfrClientBloc>().add(FetchNfrClients());
                    },
                    child: _buildNfrClientsList(state),
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