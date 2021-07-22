import 'package:flutter/material.dart';
import 'firestoreSlideshow.dart';
import 'package:firebase_core/firebase_core.dart';
import 'themes/pixely-kit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  final PageController ctrl = PageController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Slideshow',
        theme: PixelyKit.lightTheme,
        darkTheme: PixelyKit.darkTheme,
        themeMode: currentTheme.currentTheme,
        home: Scaffold(
          body: FutureBuilder(
            future: _fbApp,
            builder: (context, AsyncSnapshot snap) {
              if (snap.hasError) {
                print('ERROR: $snap.error.toString()');
                return Text('FireBase has an error!');
              } else if (snap.hasData) {
                return FirestoreSlideshow();
              } else {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ));
  }
}
