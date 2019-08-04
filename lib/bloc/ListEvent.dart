
class ListEvent {
  final int page;
  final int perPage;
  final String query;

  ListEvent({int page = 1, int perPage = 10, String query = ""}) :
      this.page = page > 0 ? page : 1,
      this.perPage = perPage > 0 ? perPage : 10,
      this.query = query ?? "";
}