import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Actualites.dart';
import 'home.dart';
import 'main.dart';

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(
    Uri.parse(url),
  )) {
    throw Exception('Could not launch $url');
  }
}

class Moov extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String title;
    title = 'Compétitions';
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: AssetImage('assets/images/moov01.png'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                    blurRadius: 10.0,
                    spreadRadius: 5.0,
                  ),
                ],
              ),
            ),
          ),
          // SizedBox(
          //   width: 50,
          // ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  //image: NetworkImage(document['image_url']),
                  image: AssetImage('assets/images/moov02.png'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
                    blurRadius: 10.0,
                    spreadRadius: 5.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Compet {
  final String title;
  final String image;
  final String url;
  Compet({required this.title, required this.image, required this.url});
}

class CompetitionPage extends StatelessWidget {
  final firestoreInstance = FirebaseFirestore.instance;
  final Key? key;

  CompetitionPage({this.key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
            child: Column(children: [
          Padding(padding: const EdgeInsets.all(20.0)),
          Moov(),
          Expanded(
            child: StreamBuilder(
              stream: firestoreInstance.collection('competition').snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot competition = snapshot.data.docs[index];
                    Compet compet = Compet(
                        title: competition['titre'],
                        image: competition['image'],
                        url: competition['url']); // Change to 'image' field
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(
                          vertical: 40.0, horizontal: 30.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                            blurRadius: 10,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _launchUrl(compet.url);
                            },
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 50.0,
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(0, 102, 178, 10),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                        ),
                                      ),
                                      child: Text(
                                        compet.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0),
                                      ),
                                      child: Image.network(
                                        compet.image,
                                        width: double.infinity,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _launchUrl(compet.url);
                            },
                            child: Text(
                              'Visiter le site de Moov Africa',
                              style: TextStyle(
                                color: Color.fromARGB(1000, 242, 111, 33),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          )
        ])));
  }
}
