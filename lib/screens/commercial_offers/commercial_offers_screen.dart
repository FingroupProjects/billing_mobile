import 'package:billing_mobile/bloc/commercial_offers/commercial_offers_bloc.dart';
import 'package:billing_mobile/bloc/commercial_offers/commercial_offers_event.dart';
import 'package:billing_mobile/bloc/commercial_offers/commercial_offers_state.dart';
import 'package:billing_mobile/custom_widget/custom_app_bar.dart';
import 'package:billing_mobile/custom_widget/custom_button.dart';
import 'package:billing_mobile/custom_widget/filter/filter_commercial_offers_app_bar.dart';
import 'package:billing_mobile/screens/commercial_offers/commercial_offer_card.dart';
import 'package:billing_mobile/screens/commercial_offers/commercial_offer_details_screen.dart';
import 'package:billing_mobile/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommercialOffersScreen extends StatefulWidget {
  const CommercialOffersScreen({super.key});

  @override
  State<CommercialOffersScreen> createState() => _CommercialOffersScreenState();
}

class _CommercialOffersScreenState extends State<CommercialOffersScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late ScrollController _scrollController;
  bool _isSearching = false;
  bool isClickAvatarIcon = false;
  Map<String, dynamic> _currentFilters = {};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
    context.read<CommercialOffersBloc>().add(FetchCommercialOffers());
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
    });
    context
        .read<CommercialOffersBloc>()
        .add(SearchCommercialOffers(_searchController.text));
  }

  void _onScroll() {
    final state = context.read<CommercialOffersBloc>().state;
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        state is CommercialOffersLoaded &&
        !state.isLoadingMore) {
      context.read<CommercialOffersBloc>().add(FetchMoreCommercialOffers());
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

  Widget _buildOffersList(CommercialOffersLoaded state) {
    final offers = state.offers.data;

    if (_isSearching && offers.isEmpty) {
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
    } else if (offers.isEmpty) {
      return const Center(
        child: Text(
          'Нет подключений',
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
      itemCount: offers.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < offers.length) {
          final offer = offers[index];
          return CommercialOfferCard(
            offer: offer,
            onStatusSaved: () {
              context.read<CommercialOffersBloc>().add(FetchCommercialOffers());
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CommercialOfferDetailsScreen(offer: offer),
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
        title: BlocBuilder<CommercialOffersBloc, CommercialOffersState>(
          builder: (context, state) {
            return CustomAppBar(
              title: isClickAvatarIcon ? 'Настройка' : 'Подключение',
              totalCount: isClickAvatarIcon || state is! CommercialOffersLoaded
                  ? null
                  : state.offers.total,
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
                    builder: (context) => FilterCommercialOffersScreen(
                      onFilterSelected: (filters) {
                        setState(() {
                          _currentFilters = filters;
                        });
                        context.read<CommercialOffersBloc>().add(
                              ApplyCommercialOfferFilters(filters),
                            );
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
                  context
                      .read<CommercialOffersBloc>()
                      .add(SearchCommercialOffers(''));
                }
              },
            );
          },
        ),
      ),
      body: isClickAvatarIcon
          ? const ProfileScreen()
          : BlocBuilder<CommercialOffersBloc, CommercialOffersState>(
              builder: (context, state) {
                if (state is CommercialOffersLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xff1E2E52)),
                  );
                } else if (state is CommercialOffersError) {
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
                              context
                                  .read<CommercialOffersBloc>()
                                  .add(FetchCommercialOffers());
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
                } else if (state is CommercialOffersLoaded) {
                  return RefreshIndicator(
                    color: const Color(0xff1E2E52),
                    backgroundColor: Colors.white,
                    onRefresh: () async {
                      context
                          .read<CommercialOffersBloc>()
                          .add(FetchCommercialOffers());
                    },
                    child: _buildOffersList(state),
                  );
                }
                return const Center(child: Text('Нет данных'));
              },
            ),
    );
  }
}
