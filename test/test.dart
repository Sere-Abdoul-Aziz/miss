import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Accueil'),
    Text('Actualités'),
    Text('Compétitions'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBody: true,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.pink.withOpacity(0.5),
                blurRadius: 10,
                offset: Offset(0, 0),
              ),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.white,
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.new_releases),
                label: 'Actualités',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star),
                label: 'Compétitions',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.pink,
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedFontSize: 16,
            unselectedFontSize: 14,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
    );
  }
}
// Expanded(
              //   child: GridView.count(
              //     crossAxisCount: 2,
              //     crossAxisSpacing: 10,
              //     mainAxisSpacing: 10,
              //     childAspectRatio: 2 / 3,
              //     children: _listItem
              //         .map(
              //           (item) => GestureDetector(
              //               onTap: () {
              //                 // Naviguer vers une autre vue
              //                 Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                     builder: (context) =>
              //                         Profile(imagePath: item),
              //                   ),
              //                 );
              //               },
              //               child: Card(
              //                 color: Colors.transparent,
              //                 elevation: 0,
              //                 child: Stack(
              //                   children: [
              //                     Container(
              //                       decoration: BoxDecoration(
              //                         borderRadius: BorderRadius.circular(5),
              //                         image: DecorationImage(
              //                             image: AssetImage(item),
              //                             fit: BoxFit.cover),
              //                       ),
              //                     ),
              //                     Positioned(
              //                       bottom: 10,
              //                       left: 10,
              //                       child: Container(
              //                         width: 35,
              //                         height: 35,
              //                         decoration: BoxDecoration(
              //                           shape: BoxShape.circle,
              //                           image: DecorationImage(
              //                             image: AssetImage(
              //                                 "assets/images/two.jpg"),
              //                             fit: BoxFit.cover,
              //                           ),
              //                         ),
              //                       ),
              //                     ),
              //                     Positioned(
              //                       bottom: 15,
              //                       left: 50,
              //                       child: Text(
              //                         "M21",
              //                         style: TextStyle(
              //                           color:
              //                               Color.fromARGB(255, 221, 221, 221),
              //                           fontWeight: FontWeight.bold,
              //                           fontSize: 25,
              //                         ),
              //                       ),
              //                     ),
              //                     Expanded(
              //                       child: Column(
              //                         mainAxisAlignment:
              //                             MainAxisAlignment.center,
              //                         children: [
              //                           SizedBox(
              //                             height: 30,
              //                           ),
              //                           Align(
              //                             alignment: Alignment.centerRight,
              //                             child: Container(
              //                               height: 25,
              //                               width: 110,
              //                               margin: EdgeInsets.symmetric(
              //                                   horizontal: 0),
              //                               decoration: BoxDecoration(
              //                                 borderRadius:
              //                                     BorderRadius.circular(10),
              //                                 color: Color.fromARGB(
              //                                     0, 255, 255, 255),
              //                               ),
              //                               child: ClipRRect(
              //                                 borderRadius: BorderRadius.only(
              //                                   topLeft: Radius.circular(5),
              //                                   topRight: Radius.circular(0),
              //                                   bottomLeft: Radius.circular(5),
              //                                   bottomRight: Radius.circular(0),
              //                                 ),
              //                                 child: BackdropFilter(
              //                                   filter: ImageFilter.blur(
              //                                       sigmaX: 25, sigmaY: 25),
              //                                   child: Center(
              //                                     child: Text(
              //                                       "Shop Now",
              //                                       style: TextStyle(
              //                                         color: Color.fromARGB(
              //                                             255, 221, 221, 221),
              //                                         fontWeight:
              //                                             FontWeight.bold,
              //                                       ),
              //                                     ),
              //                                   ),
              //                                 ),
              //                               ),
              //                             ),
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               )),
              //         )
              //         .toList(),
              //   ),
              // ),