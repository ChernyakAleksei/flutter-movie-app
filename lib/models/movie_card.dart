class MovieCard extends Object {
  MovieCard(this.id, this.voteAverage, this.title, this.posterPath, this.overview, this.releaseDate);

  MovieCard.fromJSON(Map<String, dynamic> json)
    : id = json['id'],
      voteAverage = json['vote_average'],
      title = json['title'],
      posterPath = json['poster_path'],
      releaseDate = json['release_date'],
      overview = json['overview'];

  final int id;
  final dynamic voteAverage;
  final String title;
  final String posterPath;
  final String overview;
  final String releaseDate;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vote_average': voteAverage,
      'title': title,
      'poster_path': posterPath,
      'overview': overview,
      'release_date': releaseDate,
    };
  }
}