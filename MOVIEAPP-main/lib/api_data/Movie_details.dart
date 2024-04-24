// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movieapp/api_data/movie_model_details.dart';

class MovieApi {
  final String _baseUrl = 'http://www.omdbapi.com/';
  final String _apiKey = 'bdb197b6';
  // final String imdbID = ;

  Future<MovieDetails> fetchMovieDetails(String imdbID) async {
    final response =
        await http.get(Uri.parse('$_baseUrl?i=$imdbID&apikey=$_apiKey'));

    if (response.statusCode == 200) {
      final movieDetails = MovieDetails.fromJson(jsonDecode(response.body));
      // If the server returns a 200 OK response, parse the JSON.

      return movieDetails;
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load movie details');
    }
  }
}
