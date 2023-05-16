import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'Actualites.dart';
import 'competition.dart';
import 'home.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  List<Widget> _pages = [
    HomePage(),
    Actualites(),
    CompetitionPage(),
  ];
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.13,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.5),
              blurRadius: 10,
              offset: Offset(0, 0),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        margin: EdgeInsets.fromLTRB(10, 0, 10, 5), // ajout de marges
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.13,
          child: DotNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTap,
            items: [
              DotNavigationBarItem(
                icon: Icon(Icons.home),
                selectedColor: Colors.blueAccent,
                unselectedColor: Colors.grey.withOpacity(0.5),
              ),
              DotNavigationBarItem(
                //ajoute l'icone article avec le titre article

                icon: Icon(
                  Icons.article,
                ),
                selectedColor: Colors.blueAccent,
                unselectedColor: Colors.grey.withOpacity(0.5),
                //ajoute un titre a l'icone
              ),
              DotNavigationBarItem(
                icon: Icon(Icons.star),
                selectedColor: Colors.blueAccent,
                unselectedColor: Colors.grey.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
