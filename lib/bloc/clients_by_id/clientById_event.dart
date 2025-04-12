// clientbyid_event.dart
abstract class ClientByIdEvent {}

class FetchClientByIdEvent extends ClientByIdEvent {
  final String clientId;
  FetchClientByIdEvent({required this.clientId});
}