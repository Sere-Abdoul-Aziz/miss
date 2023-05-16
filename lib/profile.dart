import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class Presentation extends StatefulWidget {
  final String nom;
  final String des;
  Presentation({required this.nom, required this.des});
  @override
  _PresentationState createState() => _PresentationState();
}

class _PresentationState extends State<Presentation> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.nom}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '${widget.des}',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class Profile extends StatefulWidget {
  final String imagePath;
  final String nom;
  final String num;
  final String pp;
  final String id;
  final String img;
  final String mess;
  final String des;

  const Profile({
    Key? key,
    required this.imagePath,
    required this.nom,
    required this.num,
    required this.pp,
    required this.id,
    required this.img,
    required this.mess,
    required this.des,
  }) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> missStream;

  //late Stream<QuerySnapshot<Map<String, dynamic>>> photosStream;

  String? num;
  String? pp;
  String? id;
  String? img;
  String? mess;
  String? des;

  //SmsQuery query = new SmsQuery();

  @override
  void initState() {
    super.initState();

    num = widget.num;
    pp = widget.pp;
    id = widget.id;
    img = widget.img;
    mess = widget.mess;
    des = widget.des;

    // Initialiser missStream avec le stream approprié
    missStream = FirebaseFirestore.instance
        .collection('miss')
        .doc(widget.nom)
        .snapshots();

    // Récupérer la sous-collection "photos" et les stocker dans la liste `imageUrlList`
    // Récupérer la sous-collection "photos" de la collection "miss"
    // photosStream = FirebaseFirestore.instance
    //     .collection('miss')
    //     .doc(widget.nom)
    //     .collection('photos')
    //     .snapshots();
  }

  Future<void> _showVoteDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Voter pour cette miss'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Voulez-vous voter pour la miss ${widget.num} ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Voter'),
              onPressed: () {
                // Envoyer un message "vote" au numéro de téléphone 1101
                Navigator.of(context).pop();
                _sendMessage("${widget.num}", "${widget.mess}");
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendMessage(String message, String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {
        'body': message,
      },
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: missStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Scaffold(
            // appBar: AppBar(
            //   backgroundColor: Color.fromARGB(232, 255, 95, 2),
            //   title: Text('Profile'),
            // ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.1,
                        left: MediaQuery.of(context).size.width * 0.1,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(widget.pp),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 60,
                        left: 110,
                        child: Text(
                          '${widget.num}',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 230,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                gradient: const LinearGradient(
                                  colors: <Color>[
                                    Color(0xFFFFDEE8),
                                    Color(0xFFFFB3C3),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.pinkAccent.withOpacity(0.8),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: MaterialButton(
                                minWidth: 100.0,
                                height: 40.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                onPressed: _showVoteDialog,
                                child: const Text(
                                  'Voter',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Presentation(
                          nom: '${widget.nom}', des: '${widget.des}'),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 10,
                          ),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                width: 10,
                                color: Colors.white,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.pink.withOpacity(0.5),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                ),
                              ],
                              image: DecorationImage(
                                image: NetworkImage(widget.img),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Container(
                  //   padding: EdgeInsets.all(8.0),
                  //   child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  //     stream: photosStream,
                  //     builder: (context, snapshot) {
                  //       if (snapshot.connectionState ==
                  //           ConnectionState.waiting) {
                  //         return Center(child: CircularProgressIndicator());
                  //       } else if (snapshot.hasData &&
                  //           snapshot.data!.docs.isNotEmpty) {
                  //         final photos = snapshot.data!.docs;
                  //         return Container(
                  //           height: MediaQuery.of(context).size.height * 0.5,
                  //           child: GridView.count(
                  //             shrinkWrap: true,
                  //             physics: NeverScrollableScrollPhysics(),
                  //             crossAxisCount: 2,
                  //             childAspectRatio: 3 / 2,
                  //             crossAxisSpacing: 10,
                  //             mainAxisSpacing: 10,
                  //             children: photos.map((photo) {
                  //               return GridTile(
                  //                 child: Image.network(
                  //                   photo['photo'],
                  //                   fit: BoxFit.cover,
                  //                 ),
                  //               );
                  //             }).toList(),
                  //           ),
                  //         );
                  //       } else if (snapshot.hasError) {
                  //         return Center(child: Text("Une erreur est survenue"));
                  //       } else {
                  //         return Center(child: Text("Aucune photo trouvée"));
                  //       }
                  //     },
                  //   ),
                  // )
                ],
              ),
            ),
          );
        });
  }
}
