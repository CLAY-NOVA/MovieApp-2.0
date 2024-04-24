import "package:movieapp/api_data/movie_model.dart";
import 'package:movieapp/api_data/movie_results.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getMovies();
}

class OmdbApiClient extends MovieRemoteDataSource {
  final String _apiKey = 'bdb197b6';
  @override
  Future<List<MovieModel>> getMovies({String query = 'movie'}) async {
    final response = await http
        .get(Uri.parse('https://www.omdbapi.com/?s=$query&apikey=$_apiKey'));

    if (response.statusCode == 200) {
      final responsebody = json.decode(response.body);

      if (responsebody['Search'] != null) {
        final movies = MoviesResults.fromJson(responsebody).search;

        return movies;
      } else {
        throw Exception('Search is null');
      }
    } else {
      throw Exception('Failed to load movie');
    }
  }

  Future<List<MovieModel>> getMoreMovies(int pageNumber,
      {String query = 'movie'}) async {
    final response = await http.get(Uri.parse(
        'https://www.omdbapi.com/?s=$query&page=$pageNumber&apikey=$_apiKey'));

    if (response.statusCode == 200) {
      final responsebody = json.decode(response.body);

      if (responsebody['Search'] != null) {
        final movies = MoviesResults.fromJson(responsebody).search;

        return movies;
      } else {
        throw Exception('Search is null');
      }
    } else {
      throw Exception('Failed to load movie');
    }
  }
}
