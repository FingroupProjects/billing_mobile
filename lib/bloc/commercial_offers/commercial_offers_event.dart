abstract class CommercialOffersEvent {}

class FetchCommercialOffers extends CommercialOffersEvent {}

class FetchMoreCommercialOffers extends CommercialOffersEvent {}

class SearchCommercialOffers extends CommercialOffersEvent {
  final String query;

  SearchCommercialOffers(this.query);
}

class FetchCommercialOfferStatuses extends CommercialOffersEvent {
  final int offerId;

  FetchCommercialOfferStatuses(this.offerId);
}
