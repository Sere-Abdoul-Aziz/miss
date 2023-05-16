import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentaireWidget extends StatefulWidget {
  final String photo;
  final List<String> comment;
  final String photoId;
  CommentaireWidget(
      {required this.photo, required this.comment, required this.photoId});
  @override
  _CommentaireWidgetState createState() => _CommentaireWidgetState();
}

class _CommentaireWidgetState extends State<CommentaireWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  late CollectionReference _commentCollection;
  late CollectionReference _actuPhotoCollection;
  List<DocumentSnapshot> _commentList = [];
  @override
  void initState() {
    super.initState();
    _commentCollection = FirebaseFirestore.instance
        .collection('actu_photo')
        .doc(widget.photoId)
        .collection('commentaires');
    _actuPhotoCollection = FirebaseFirestore.instance.collection('actu_photo');
  }

  Stream<QuerySnapshot> _getCommentStream() {
    return _commentCollection.orderBy('date', descending: true).snapshots();
  }

  Future<void> _addComment(String newComment) async {
    await _commentCollection.add({
      'commentaire': newComment,
      'date': DateTime.now(),
    });
    await _updateCommentCount();
    _textEditingController.clear();
    //_loadComments();
  }

  Future<void> _updateCommentCount() async {
    final doc = await _actuPhotoCollection.doc(widget.photoId).get();
    int currentCount = doc['comment'] ?? 0;
    await _actuPhotoCollection
        .doc(widget.photoId)
        .update({'comment': currentCount + 1});
  }

  Widget _buildCommentListItem(DocumentSnapshot commentSnapshot) {
    Map<String, dynamic> commentData =
        commentSnapshot.data() as Map<String, dynamic>;
    String comment = commentData['commentaire'];
    DateTime date = commentData['date'].toDate();
    String formattedDate = DateFormat('yyyy-MM-dd – H:m')
        .format(date); // Formater la date en chaîne de caractères

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              comment,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 12),
            Text(
              formattedDate,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Commentaires'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.photo,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
          ), // Affiche la photo à partir de l'URL
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getCommentStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erreur: ${snapshot.error}'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                _commentList = snapshot.data!.docs;
                return _commentList.isEmpty
                    ? Center(
                        child: Text('Aucun commentaire'),
                      )
                    : ListView.builder(
                        itemCount: _commentList.length,
                        itemBuilder: (context, index) {
                          return _buildCommentListItem(_commentList[index]);
                        },
                      );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Ajouter un commentaire',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (_textEditingController.text.isNotEmpty) {
                      _addComment(_textEditingController.text);
                    }
                  },
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
