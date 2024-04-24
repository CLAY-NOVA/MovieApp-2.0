import 'package:movieapp/api_data/movie_model.dart';

class MoviesResults {
  List<MovieModel> search;

  MoviesResults({required this.search});

  factory MoviesResults.fromJson(Map<String, dynamic> json) {
    var search = List<MovieModel>.empty(growable: true);
    if (json['Search'] != null) {
      json['Search'].forEach((v) {
        final movieModel = MovieModel.fromJson(v);
        search.add(movieModel);
      });
    }
    return MoviesResults(search: search);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data;
  }
}
