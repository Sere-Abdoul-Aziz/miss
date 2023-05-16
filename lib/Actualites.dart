import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:miss/commentaire.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:like_button/like_button.dart';
import 'commentaireA.dart';
import 'competition.dart';
import 'home.dart';
import 'main.dart';
//import 'main.dart';

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

class ActuVideo extends StatefulWidget {
  const ActuVideo({Key? key}) : super(key: key);
  @override
  _ActuVideoState createState() => _ActuVideoState();
}

class _ActuVideoState extends State<ActuVideo> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('actu_video').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            VideoPlayerController _videoController =
                VideoPlayerController.network(document['urlvideo']);
            ChewieController _chewieController = ChewieController(
              videoPlayerController: _videoController,
              autoPlay: false,
              looping: false,
            );
            return Container(
              width: 300,
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
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Chewie(
                      controller: _chewieController,
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
                      child: Text(
                        document['titre'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
            return GestureDetector(
              onTap: () async {
                QuerySnapshot commentData = await FirebaseFirestore.instance
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
              child: Container(
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
                                  countPostion: CountPostion.left,
                                  likeCount: document['like'],
                                  onTap: (bool isLiked) async {
                                    // Update the value of 'like' on Firebase
                                    if (isLiked) {
                                      await document.reference.update(
                                          {'like': document['like'] - 1});
                                    } else {
                                      await document.reference.update(
                                          {'like': document['like'] + 1});
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
                                  child: LikeButton(
                                    likeBuilder: (bool isLiked) {
                                      return Icon(
                                        Icons.chat_bubble_outline,
                                        color:
                                            isLiked ? Colors.blue : Colors.grey,
                                        size: 30,
                                      );
                                    },
                                    likeCount: document['comment'],
                                    countPostion: CountPostion.right,
                                    onTap: (isLiked) async {
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
                                          builder: (context) =>
                                              CommentaireWidget(
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
            return GestureDetector(
                onTap: () async {
                  QuerySnapshot commentData = await FirebaseFirestore.instance
                      .collection("article")
                      .doc(document.id)
                      .collection("commentaires")
                      .get();
                  List<String> commentList = [];

                  commentData.docs.forEach((doc) {
                    commentList.add(doc["commentaire"]);
                  });
                  await Future.delayed(Duration(milliseconds: 500));

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentaireArticleWidget(
                        photo: document['artimg'],
                        comment: commentList,
                        articleId: document.id,
                        articleText: document['art_texte'],
                      ),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
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
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: NetworkImage(document['artimg']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      // Text section
                      Flexible(
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
                              // SizedBox(height: 10),
                              Flexible(
                                flex: 1,
                                child: Container(
                                  height: 80,
                                  child: Text(
                                    document['art_texte'].length < 200
                                        ? document['art_texte']
                                        : '${document['art_texte'].substring(0, 200)}...',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                              //SizedBox(height: 10),

                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
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
                                        Flexible(
                                          flex: 1,
                                          child: LikeButton(
                                            countPostion: CountPostion.left,
                                            likeCount: document['like'],
                                            onTap: (bool isLiked) async {
                                              // Handle the action of the like button (save the like to the database or remove the like from the database)
                                              // Update the value of 'like' on Firebase
                                              if (isLiked) {
                                                await document.reference
                                                    .update({
                                                  'like': document['like'] - 1
                                                });
                                              } else {
                                                await document.reference
                                                    .update({
                                                  'like': document['like'] + 1
                                                });
                                              }

                                              // Return the changed value of isLiked
                                              return !isLiked;
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: InkWell(
                                            child: LikeButton(
                                              countPostion: CountPostion.right,
                                              likeCount: document['comment'],
                                              likeBuilder: (bool isLiked) {
                                                return Icon(
                                                    Icons.chat_bubble_outline,
                                                    color: isLiked
                                                        ? Colors.pink
                                                        : Colors.grey,
                                                    size: 30.0);
                                              },
                                              onTap: (bool isLiked) async {
                                                QuerySnapshot commentData =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("article")
                                                        .doc(document.id)
                                                        .collection(
                                                            "commentaires")
                                                        .get();
                                                List<String> commentList = [];

                                                commentData.docs.forEach((doc) {
                                                  commentList
                                                      .add(doc["commentaire"]);
                                                });
                                                await Future.delayed(Duration(
                                                    milliseconds: 500));

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CommentaireArticleWidget(
                                                      photo: document['artimg'],
                                                      comment: commentList,
                                                      articleId: document.id,
                                                      articleText:
                                                          document['art_texte'],
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
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ));
          }).toList(),
        );
      },
    );
  }
}

class Actualites extends StatelessWidget {
  const Actualites({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //add background color
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
          child: Column(
            children: <Widget>[
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
                            color: Color.fromRGBO(0, 102, 178, 10)
                                .withOpacity(0.8), // Ajout de l'opacité
                          ),
                          child: TabBar(
                            indicator: BoxDecoration(
                              color: Color.fromRGBO(0, 102, 178, 10)
                                  .withOpacity(0.05), // Ajout de l'opacité
                            ),

                            unselectedLabelColor:
                                Color.fromARGB(255, 255, 255, 255),
                            labelColor: Color.fromARGB(1000, 242, 111, 33),
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
                                  Expanded(child: ActuVideo()),
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
            ],
          ),
        ));
  }
}
