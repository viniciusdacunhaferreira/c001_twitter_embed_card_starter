import 'package:flutter/material.dart';
import 'package:twitter_embed_card/svg_asset.dart';
import 'package:twitter_embed_card/vector_icon.dart';

class TweetData {
  const TweetData({
    required this.displayName,
    required this.username,
    required this.body,
    required this.image,
    required this.time,
    required this.date,
    required this.likesCount,
    required this.repliesCount,
  });
  final String displayName;
  final String username;
  final String body;
  final String image;
  final String time;
  final String date;
  final int likesCount;
  final int repliesCount;
}

const tweetData = TweetData(
  displayName: 'Andrea Bizzotto',
  username: '@biz84',
  body: '''
Did you know?

When you call `MediaQuery.of(context)` inside a build method, the widget will rebuild when *any* of the MediaQuery properties change.

But there's a better way that lets you depend only on the properties you care about (and minimize unnecessary rebuilds). 👇
''',
  image: 'assets/media-query-banner.jpg',
  time: '10:21 AM',
  date: 'Jun 20, 2023',
  likesCount: 997,
  repliesCount: 12,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.0),
          // Use Center as layout has unconstrained width (loose constraints),
          // together with SizedBox to specify the max width (tight constraints)
          // See this thread for more info:
          // https://twitter.com/biz84/status/1445400059894542337
          child: Center(
            child: SizedBox(
              width: 600, // max allowed width
              child: TwitterEmbedCard(
                data: tweetData,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TwitterEmbedCard extends StatelessWidget {
  const TwitterEmbedCard({super.key, required this.data});
  final TweetData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TweetHeader(displayName: data.displayName, username: data.username),
        const SizedBox(height: 12.0),
        TweetText(text: data.body),
        TweetImage(imageName: data.image),
        const SizedBox(height: 8.0),
        TweetMetadata(time: data.time, date: data.date),
        const SizedBox(height: 8.0),
        const Divider(height: 0.5),
        const SizedBox(height: 8.0),
        TweetActions(likesCount: data.likesCount),
        const SizedBox(height: 8.0),
        TweetReadRepliesButton(repliesCount: data.repliesCount),
      ],
    );
  }
}

class TweetHeader extends StatelessWidget {
  const TweetHeader(
      {super.key, required this.displayName, required this.username});
  final String displayName;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Clip the image into a circle
        // https://stackoverflow.com/a/60628441/436422
        ClipOval(
          child: Image.asset('assets/andrea-avatar.png', width: 48, height: 48),
        ),
        const SizedBox(width: 4.0),
        // Needed to prevent this error:
        // RenderFlex children have non-zero flex but incoming width constraints are unbounded.
        // Learn more: https://cloud.typingmind.com/share/811d3778-f989-4cc3-9d00-6fe216f696ef
        // https://docs.flutter.dev/testing/common-errors#vertical-viewport-was-given-unbounded-height
        Expanded(
          child: Column(
            children: [
              // top row
              Row(
                children: [
                  Text(
                    displayName,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 4.0),
                  const VectorIcon(asset: SvgAsset.heartBlue, height: 18),
                  const SizedBox(width: 4.0),
                  const VectorIcon(asset: SvgAsset.verified, height: 18),
                  const Spacer(),
                  const VectorIcon(asset: SvgAsset.x, height: 22),
                ],
              ),
              const SizedBox(height: 2.0),
              Row(
                children: [
                  Text(
                    username,
                    style: const TextStyle(color: Color(0xFF566370)),
                  ),
                  const SizedBox(width: 3.0),
                  const Text(
                    '·',
                    style: TextStyle(color: Color(0xFF566370)),
                  ),
                  const SizedBox(width: 3.0),
                  const Text(
                    'Follow',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: Color(0xFF2E6ECF)),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

class TweetText extends StatelessWidget {
  const TweetText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      text,
      style: const TextStyle(
        fontSize: 18,
        height: 1.25,
      ),
    );
  }
}

class TweetImage extends StatelessWidget {
  const TweetImage({super.key, required this.imageName});
  final String imageName;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      child: Image.asset(imageName),
    );
  }
}

class TweetMetadata extends StatelessWidget {
  const TweetMetadata({super.key, required this.time, required this.date});
  // * In a real app, pass a DateTime instead and format it
  final String time;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          time,
          style: const TextStyle(color: Color(0xFF566370)),
        ),
        const SizedBox(width: 3.0),
        const Text(
          '·',
          style: TextStyle(color: Color(0xFF566370)),
        ),
        const SizedBox(width: 3.0),
        Text(
          date,
          style: const TextStyle(color: Color(0xFF566370)),
        ),
        const Spacer(),
        const VectorIcon(asset: SvgAsset.info, height: 20),
      ],
    );
  }
}

class TweetActions extends StatelessWidget {
  const TweetActions({super.key, required this.likesCount});
  final int likesCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TweetAction(asset: SvgAsset.heartRed, text: likesCount.toString()),
        const SizedBox(width: 24.0),
        const TweetAction(asset: SvgAsset.comment, text: 'Reply'),
        const SizedBox(width: 24.0),
        const TweetAction(asset: SvgAsset.link, text: 'Copy link'),
      ],
    );
  }
}

class TweetAction extends StatelessWidget {
  const TweetAction({super.key, required this.asset, required this.text});
  final SvgAsset asset;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        VectorIcon(asset: asset, height: 20),
        const SizedBox(width: 8.0),
        Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.w700, color: Color(0xFF566370)),
        ),
      ],
    );
  }
}

class TweetReadRepliesButton extends StatelessWidget {
  const TweetReadRepliesButton({super.key, required this.repliesCount});
  final int repliesCount;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      child: Text(
        'Read $repliesCount replies',
        style: const TextStyle(
            fontWeight: FontWeight.w700, color: Color(0xFF2E6ECF)),
      ),
    );
  }
}
