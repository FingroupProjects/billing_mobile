import 'package:billing_mobile/bloc/ai_clients/ai_clients_bloc.dart';
import 'package:billing_mobile/bloc/ai_clients/ai_clients_event.dart';
import 'package:billing_mobile/bloc/ai_clients/ai_clients_state.dart';
import 'package:billing_mobile/custom_widget/custom_app_bar.dart';
import 'package:billing_mobile/custom_widget/custom_button.dart';
import 'package:billing_mobile/screens/ai_clients/ai_client_card.dart';
import 'package:billing_mobile/screens/ai_clients/ai_client_details_screen.dart';
import 'package:billing_mobile/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiClientsScreen extends StatefulWidget {
  const AiClientsScreen({super.key});

  @override
  State<AiClientsScreen> createState() => _AiClientsScreenState();
}

class _AiClientsScreenState extends State<AiClientsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late ScrollController _scrollController;
  bool _isSearching = false;
  bool isClickAvatarIcon = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
    context.read<AiClientsBloc>().add(FetchAiClients());
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
    });
    context.read<AiClientsBloc>().add(SearchAiClients(_searchController.text));
  }

  void _onScroll() {
    final state = context.read<AiClientsBloc>().state;
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        state is AiClientsLoaded &&
        !state.isLoadingMore) {
      context.read<AiClientsBloc>().add(FetchMoreAiClients());
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

  Widget _buildList(AiClientsLoaded state) {
    final subscriptions = state.subscriptions.data;

    if (_isSearching && subscriptions.isEmpty) {
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
    }

    if (subscriptions.isEmpty) {
      return const Center(
        child: Text(
          'Нет ИИ-клиентов',
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
      itemCount: subscriptions.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < subscriptions.length) {
          final subscription = subscriptions[index];
          return AiClientCard(
            subscription: subscription,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AiClientDetailsScreen(subscription: subscription),
                ),
              );
            },
          );
        }

        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(color: Color(0xff1E2E52)),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: BlocBuilder<AiClientsBloc, AiClientsState>(
          builder: (context, state) {
            return CustomAppBar(
              title: isClickAvatarIcon ? 'Настройка' : 'ИИ-клиенты',
              totalCount: isClickAvatarIcon || state is! AiClientsLoaded
                  ? null
                  : state.subscriptions.total,
              onClickProfileAvatar: () {
                setState(() {
                  isClickAvatarIcon = !isClickAvatarIcon;
                });
              },
              clearButtonClickFiltr: (isSearching) {},
              showSearchIcon: true,
              showFilterIcon: false,
              onChangedSearchInput: (String value) {},
              textEditingController: _searchController,
              focusNode: _searchFocusNode,
              clearButtonClick: (value) {
                if (value == false) {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                  });
                  context.read<AiClientsBloc>().add(SearchAiClients(''));
                }
              },
            );
          },
        ),
      ),
      body: isClickAvatarIcon
          ? const ProfileScreen()
          : BlocBuilder<AiClientsBloc, AiClientsState>(
              builder: (context, state) {
                if (state is AiClientsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xff1E2E52)),
                  );
                } else if (state is AiClientsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: CustomButton(
                            buttonText: 'Обновить',
                            buttonColor: const Color(0xff4759FF),
                            textColor: Colors.white,
                            onPressed: () {
                              context.read<AiClientsBloc>().add(FetchAiClients());
                            },
                            child: const Text(
                              'Повторить попытку',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Gilroy',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is AiClientsLoaded) {
                  return RefreshIndicator(
                    color: const Color(0xff1E2E52),
                    backgroundColor: Colors.white,
                    onRefresh: () async {
                      context.read<AiClientsBloc>().add(FetchAiClients());
                    },
                    child: _buildList(state),
                  );
                }
                return const Center(child: Text('Нет данных'));
              },
            ),
    );
  }
}
