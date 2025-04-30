abstract class InActiveEvent {}

class FetchInActive extends InActiveEvent {}

class FetchMoreInActive extends InActiveEvent {}

class InActiveApplyFilters extends InActiveEvent {
  final Map<String, dynamic> filters;

  InActiveApplyFilters(this.filters);
}

class SearchInActive extends InActiveEvent {
  final String query;

  SearchInActive(this.query);
}