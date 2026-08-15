abstract class AiClientsEvent {}

class FetchAiClients extends AiClientsEvent {}

class FetchMoreAiClients extends AiClientsEvent {}

class SearchAiClients extends AiClientsEvent {
  final String query;

  SearchAiClients(this.query);
}
