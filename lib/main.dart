import 'package:flutter/material.dart';
import 'package:twitter_embed_card/post_data.dart';
import 'package:twitter_embed_card/twitter_embed_card.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

final postData = PostData(
  userName: 'biz84',
  displayName: 'Andrea Bizzotto',
  userImage: const AssetImage('assets/andrea-avatar.png'),
  postText:
      'Did you know?\n\nWhen you call `MediaQuery.of(context)` inside a build method, the widget will rebuild when *any* of the MediaQuery properties change.\n\nBut there\'s a better way that lets you depend only on the properties you care about (and minimize unnecessary rebuilds). 👇',
  postImage: const AssetImage('assets/media-query-banner.jpg'),
  date: DateTime(2023, 6, 20, 6, 21),
  likes: 1000,
  replies: 12,
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          // Use Center as layout has unconstrained width (loose constraints),
          // together with SizedBox to specify the max width (tight constraints)
          // See this thread for more info:
          // https://twitter.com/biz84/status/1445400059894542337
          child: Center(
            child: SizedBox(
              width: 550, // max allowed width
              child: TwitterEmbedCard(postData: postData),
            ),
          ),
        ),
      ),
    );
  }
}
