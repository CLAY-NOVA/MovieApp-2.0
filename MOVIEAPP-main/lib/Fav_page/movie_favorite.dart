// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:movieapp/local_data.dart/movie_local_data.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class FavoriteMovies extends StatefulWidget {
  const FavoriteMovies({super.key});

  @override
  _FavoriteMoviesState createState() => _FavoriteMoviesState();
}

class _FavoriteMoviesState extends State<FavoriteMovies> {
  late Future<List<Map<String, dynamic>>> favoriteMovies;

  @override
  void initState() {
    super.initState();
    favoriteMovies = DatabaseHelper.instance.queryAllRows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Movies'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: favoriteMovies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    String imdbId =
                        snapshot.data![index][DatabaseHelper.columnId];
                    String url = 'https://www.imdb.com/title/$imdbId';
                    try {
                      await launchUrl(Uri.parse(url));
                    } catch (e) {
                      print('Could not launch $url: $e');
                    }
                  },
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        // Movie poster in the background
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(snapshot.data![index]
                                  [DatabaseHelper.columnPoster]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Semi-transparent black overlay
                        Container(
                          color: Colors.black.withOpacity(0.6),
                        ),
                        // Movie title at the bottom
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            snapshot.data![index][DatabaseHelper.columnTitle],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Delete button at the top right
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.white),
                            onPressed: () async {
                              await DatabaseHelper.instance.delete(snapshot
                                  .data![index][DatabaseHelper.columnId]);
                              setState(() {
                                favoriteMovies =
                                    DatabaseHelper.instance.queryAllRows();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
