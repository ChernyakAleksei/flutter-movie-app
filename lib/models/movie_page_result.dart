import 'package:achernyak_app/models/movie_card.dart';

class MoviePageResult {
  MoviePageResult.fromJSON(Map<String, dynamic> parsedJson) {
      pageIndex = parsedJson['page'];
      totalResults = parsedJson['total_results'];
      totalPages = parsedJson['total_pages'];
      final List<MovieCard> temp = <MovieCard>[];
      final List<dynamic> list = parsedJson['results'];

      if (list != null) {
        for (dynamic item in list) {
          final MovieCard result = MovieCard.fromJSON(item);
          temp.add(result);
        }
      }
    
    movies = temp;
  }

  int pageIndex;
  int totalResults;
  int totalPages;
  List<MovieCard> movies;
}