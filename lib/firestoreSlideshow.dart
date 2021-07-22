import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreSlideshow extends StatefulWidget {
  @override
  _FirestoreSlideshowState createState() => _FirestoreSlideshowState();
}

class _FirestoreSlideshowState extends State<FirestoreSlideshow> {
  final PageController ctrl = PageController(viewportFraction: 0.8);

  final FirebaseFirestore db = FirebaseFirestore.instance;
  late Stream slides;
  late Stream genres;
  String activeTag = 'horror';
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _queryDbGenres();
    _queryDb();

    ctrl.addListener(() {
      int next = ctrl.page!.round();

      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: slides,
        initialData: [],
        builder: (context, AsyncSnapshot snap) {
          List slideList;

          if (snap.connectionState == ConnectionState.active) {
            slideList = snap.data.toList();
            // _addCard();
            return PageView.builder(
                controller: ctrl,
                itemCount: slideList.length + 1,
                itemBuilder: (context, int index) {
                  if (index == 0) {
                    return _buildTagPage();
                  } else if (slideList.length >= index) {
                    // Active page
                    bool active = index == currentPage;
                    return _buildStoryPage(slideList[index - 1], active);
                  }
                  throw '';
                });
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              ),
            );
          }
        });
  }

  _queryDbGenres() {
    Query query = db.collection('movie-categories');
    genres = query.snapshots().map((list) => list.docs);
  }

  // Query Firestore
  _queryDb({String tag = 'horror'}) {
    Query query = db.collection('movies').where('tags', arrayContains: tag);

    slides =
        query.snapshots().map((list) => list.docs.map((doc) => doc.data()));
    setState(() {
      activeTag = tag;
    });
  }

  // Builder Functions
  _buildStoryPage(Map data, bool active) {
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 100 : 200;

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(data['img']),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black87,
                blurRadius: blur,
                offset: Offset(offset, offset))
          ]),
      child: Container(
          padding: EdgeInsets.fromLTRB(0, 180, 0, 0),
          child: Center(
            child: Text(
              data['title'],
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
          )),
    );
  }

  _buildTagPage() {
    return StreamBuilder(
        stream: genres,
        initialData: [],
        builder: (context, AsyncSnapshot snap) {
          List genresList;

          if (snap.connectionState == ConnectionState.active) {
            genresList = snap.data.toList();

            return Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 250, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Stories',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    Text('FILTER',
                        style: Theme.of(context).textTheme.headline1),
                    new Expanded(
                      child: Container(
                        width: 100,
                        child: ListView.builder(
                          itemCount: genresList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _buildButton(genresList[index]['genre']);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          throw '';
        });
  }

  _buildButton(tag) {
    Color color = tag == activeTag ? Colors.purple : Colors.white;
    Color textColor = tag == activeTag ? Colors.white : Colors.black;
    return TextButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(textColor),
          backgroundColor: MaterialStateProperty.all<Color>(color),
        ),
        child: Text('#$tag'),
        onPressed: () => _queryDb(tag: tag));
  }
}
