import 'package:billing_mobile/models/ai_subscription_model.dart';

abstract class AiClientsState {}

class AiClientsInitial extends AiClientsState {}

class AiClientsLoading extends AiClientsState {}

class AiClientsLoaded extends AiClientsState {
  final AiSubscriptionListResponse subscriptions;
  final bool isLoadingMore;

  AiClientsLoaded(this.subscriptions, {this.isLoadingMore = false});
}

class AiClientsError extends AiClientsState {
  final String message;

  AiClientsError(this.message);
}
