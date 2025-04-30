abstract class DemoEvent {}

class FetchDemo extends DemoEvent {}

class FetchMoreDemo extends DemoEvent {}



class DemoApplyFilters extends DemoEvent {
  final Map<String, dynamic> filters;

  DemoApplyFilters(this.filters);
}

class SearchDemo extends DemoEvent {
  final String query;

  SearchDemo(this.query);
}