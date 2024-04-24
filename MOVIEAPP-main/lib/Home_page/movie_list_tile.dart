import 'package:flutter/material.dart';
import 'package:movieapp/Cinema_page/movie_cinema_near_me.dart';
import 'package:movieapp/Home_page/movie_home_page.dart';
import 'package:movieapp/Fav_page/movie_favorite.dart';


class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black, // Set the background color to black
        child: ListView(
          children: <Widget>[
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "SUPTECHNOLOGY\nZAKARIA LAKIM\nOUSSAMA GHAZOUANI",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white), // Set the icon color to white
              title: const Text(
                'Home',
                style: TextStyle(color: Colors.white), // Set the text color to white
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.white), // Set the icon color to white
              title: const Text(
                'Favorites',
                style: TextStyle(color: Colors.white), // Set the text color to white
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FavoriteMovies()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.white), // Set the icon color to white
              title: const Text(
                'Cinema Near Me',
                style: TextStyle(color: Colors.white), // Set the text color to white
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CinemaNearMe()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
