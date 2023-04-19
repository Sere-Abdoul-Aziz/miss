import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:miss/commentaire.dart';
//import 'package:video_player/video_player.dart';
//import 'package:chewie/chewie.dart';
import 'package:like_button/like_button.dart';
import 'main.dart';
//import 'dart:ffi' as ffi;

class Moov extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String title;
    title = 'Actualités';
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
                  fontSize: 20,
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

// class ActuVideo extends StatefulWidget {
//   const ActuVideo({Key? key}) : super(key: key);
//   @override
//   _ActuVideoState createState() => _ActuVideoState();
// }

// class _ActuVideoState extends State<ActuVideo> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('actu_video').snapshots(),
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//         return ListView(
//           children: snapshot.data!.docs.map((DocumentSnapshot document) {
//             VideoPlayerController _videoController =
//                 VideoPlayerController.network(document['urlvideo'])
//                   ..initialize().then((_) {
//                     setState(() {});
//                   });
//             ChewieController _chewieController = ChewieController(
//               videoPlayerController: _videoController,
//               aspectRatio:
//                   _videoController.value.aspectRatio, // Ajout de l'aspectRatio
//               autoPlay: false,
//               looping: false,
//             );
//             return Container(
//               margin: EdgeInsets.only(bottom: 20),
//               decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                     color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
//                     blurRadius: 10,
//                     offset: Offset(0, 0),
//                   ),
//                 ],
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(20),
//                     child: AspectRatio(
//                       aspectRatio: _videoController
//                           .value.aspectRatio, // Utilisation de l'aspectRatio
//                       child: Chewie(
//                         controller: _chewieController,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     left: 0,
//                     right: 0,
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 20),
//                       height: 50,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.only(
//                           bottomLeft: Radius.circular(20),
//                           bottomRight: Radius.circular(20),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.favorite_border),
//                             onPressed: () {},
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.chat_bubble_outline),
//                             onPressed: () {},
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         );
//       },
//     );
//   }
// }

class ActuPhoto extends StatefulWidget {
  const ActuPhoto({Key? key}) : super(key: key);
  @override
  _ActuPhotoState createState() => _ActuPhotoState();
}

class _ActuPhotoState extends State<ActuPhoto> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('actu_photo').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return GridView.builder(
          itemCount: snapshot.data!.docs.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: (150 / 250),
          ),
          itemBuilder: (BuildContext context, int index) {
            final document = snapshot.data!.docs[index];
            int likeCount = (document['like'] is int)
                ? document['like']
                : int.tryParse(document['like'].toString()) ?? 0;
            return Container(
              width: 300,
              height: 500,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                    blurRadius: 10,
                    offset: Offset(0, 0),
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(document['act_photo']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        colors: [
                          Colors.black.withOpacity(.4),
                          Colors.black.withOpacity(.2),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Builder(builder: (context) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: LikeButton(
                                countPostion: CountPostion.bottom,
                                likeCount: document['like'],
                                onTap: (bool isLiked) async {
                                  // Update the value of 'like' on Firebase
                                  if (isLiked) {
                                    await document.reference
                                        .update({'like': document['like'] - 1});
                                  } else {
                                    await document.reference
                                        .update({'like': document['like'] + 1});
                                  }
                                  await document.reference.get();
                                  // Return the new isLiked status
                                  return !isLiked;
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                child: IconButton(
                                  icon: Icon(Icons.chat_bubble_outline),
                                  onPressed: () async {
                                    QuerySnapshot commentData =
                                        await FirebaseFirestore.instance
                                            .collection("actu_photo")
                                            .doc(document.id)
                                            .collection("commentaires")
                                            .get();
                                    List<String> commentList = [];

                                    commentData.docs.forEach((doc) {
                                      commentList.add(doc["commentaire"]);
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CommentaireWidget(
                                          photo: document['act_photo'],
                                          comment: commentList,
                                          photoId: document.id,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class ActuComment extends StatelessWidget {
  const ActuComment({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('article').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                    blurRadius: 10,
                    offset: Offset(0, 0),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  // Photo section
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          //image: NetworkImage(document['image_url']),
                          image: AssetImage('assets/images/one.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Text section
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Text(
                              document['titre'],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 80,
                              child: Text(
                                document['art_texte'].length < 300
                                    ? document['art_texte']
                                    : '${document['art_texte'].substring(0, 169)}...',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                          //SizedBox(height: 10),
                          if (document['art_texte'].length > 500)
                            TextButton(
                              onPressed: () {
                                // Do something else
                              },
                              child: Text(
                                'Lire plus',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: Builder(builder: (context) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(Icons.favorite_border),
                                        onPressed: () {},
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(Icons.share),
                                        onPressed: () {},
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: Icon(Icons.chat_bubble_outline),
                                        onPressed: () {},
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class Actualites extends StatelessWidget {
  const Actualites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //add background color
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(20.0)),
          Moov(),
          // Padding(
          //   padding: const EdgeInsets.all(20.0),
          //   child: Text(
          //     'Actualités',
          //     style: TextStyle(
          //       fontSize: 30,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue,
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                          color: Colors.blue,
                        ),

                        unselectedLabelColor:
                            Color.fromARGB(255, 255, 255, 255),
                        labelColor: Colors.orangeAccent,
                        indicatorSize: TabBarIndicatorSize.label,
                        //indicatorColor: Colors.orangeAccent,
                        tabs: [
                          Tab(
                            text: 'Photo',
                          ),
                          Tab(
                            text: 'Vidéos',
                          ),
                          Tab(
                            text: 'Articles',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Expanded(child: ActuPhoto()),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              // Expanded(child: ActuVideo()),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Expanded(child: ActuComment()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          MonBottomNavigationBar(),
        ],
      ),
    );
  }
}
