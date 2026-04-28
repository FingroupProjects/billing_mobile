import 'package:billing_mobile/models/commercial_offer_model.dart';

abstract class CommercialOffersState {}

class CommercialOffersInitial extends CommercialOffersState {}

class CommercialOffersLoading extends CommercialOffersState {}

class CommercialOffersLoaded extends CommercialOffersState {
  final CommercialOfferListResponse offers;
  final bool isLoadingMore;

  CommercialOffersLoaded(this.offers, {this.isLoadingMore = false});
}

class CommercialOfferStatusesLoading extends CommercialOffersState {}

class CommercialOfferStatusesLoaded extends CommercialOffersState {
  final List<CommercialOfferStatus> statuses;

  CommercialOfferStatusesLoaded(this.statuses);
}

class CommercialOffersError extends CommercialOffersState {
  final String message;

  CommercialOffersError(this.message);
}
