import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentaireArticleWidget extends StatefulWidget {
  final String photo;
  final List<String> comment;
  final String articleId;
  final String articleText;
  CommentaireArticleWidget(
      {required this.photo,
      required this.comment,
      required this.articleId,
      required this.articleText});
  @override
  _CommentaireArticleWidgetState createState() =>
      _CommentaireArticleWidgetState();
}

class _CommentaireArticleWidgetState extends State<CommentaireArticleWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  late CollectionReference _commentCollection;
  List<DocumentSnapshot> _commentList = [];
  @override
  void initState() {
    super.initState();
    _commentCollection = FirebaseFirestore.instance
        .collection('article')
        .doc(widget.articleId)
        .collection('commentaires');
  }

  Stream<QuerySnapshot> _getCommentStream() {
    return _commentCollection.orderBy('date', descending: true).snapshots();
  }

  Future<void> _addComment(String newComment) async {
    DocumentReference articleRef =
        FirebaseFirestore.instance.collection('article').doc(widget.articleId);
    await _commentCollection.add({
      'commentaire': newComment,
      'date': DateTime.now(),
    });
    await articleRef.update({
      'comment': FieldValue.increment(1),
    });
    _textEditingController.clear();
  }

  Widget _buildCommentListItem(DocumentSnapshot commentSnapshot) {
    Map<String, dynamic> commentData =
        commentSnapshot.data() as Map<String, dynamic>;
    String comment = commentData['commentaire'];
    DateTime date = commentData['date'].toDate();
    String formattedDate = DateFormat('yyyy-MM-dd – H:m').format(date);
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
        title: Text('Commentaires de l\'article'),
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
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent, width: 2),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    widget.articleText,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ),
          ),
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
