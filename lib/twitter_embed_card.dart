import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twitter_embed_card/button.dart';
import 'package:twitter_embed_card/mouse_status.dart';
import 'package:twitter_embed_card/post_data.dart';
import 'package:twitter_embed_card/svg_asset.dart';
import 'package:twitter_embed_card/text_link.dart';
import 'package:twitter_embed_card/vector_icon.dart';

class TwitterEmbedCard extends StatelessWidget {
  const TwitterEmbedCard({super.key, required this.postData});

  final PostData postData;

  @override
  Widget build(BuildContext context) {
    return _EmbedCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PostHeader(
            userImage: postData.userImage,
            userName: postData.userName,
            displayName: postData.displayName,
          ),
          const SizedBox(height: 12),
          _PostText(data: postData.postText),
          const SizedBox(height: 12),
          _PostImage(postImage: postData.postImage),
          const SizedBox(height: 2),
          _PostFooter(date: postData.date),
          const Divider(color: Color(0xFFCFD9DE), height: 9),
          _PostActions(likes: postData.likes),
          const SizedBox(height: 4),
          _PostRepliesButton(replies: postData.replies),
        ],
      ),
    );
  }
}

class _EmbedCard extends StatefulWidget {
  const _EmbedCard({required this.child});

  final Widget? child;

  @override
  State<_EmbedCard> createState() => _EmbedCardState();
}

class _EmbedCardState extends State<_EmbedCard> {
  MouseStatus status = MouseStatus.out;
  Color? resolvedColor;

  @override
  Widget build(BuildContext context) {
    if (status.isOut) resolvedColor = Colors.white;
    if (status.isHover) resolvedColor = const Color(0xFFF7F7F9);
    if (status.isClicked) resolvedColor = const Color(0xB3E6ECF0);

    return MouseRegion(
      opaque: false,
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => status = MouseStatus.hover),
      onExit: (_) => setState(() => status = MouseStatus.out),
      hitTestBehavior: HitTestBehavior.deferToChild,
      child: Listener(
        onPointerDown: (_) => setState(() => status = MouseStatus.clicked),
        onPointerUp: (_) => setState(() => status = MouseStatus.hover),
        child: AnimatedContainer(
          duration: Durations.short3,
          constraints: const BoxConstraints(minWidth: 298),
          padding: const EdgeInsetsGeometry.only(
            top: 12,
            left: 16,
            right: 16,
            bottom: 16,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFCFD9DE)),
            borderRadius: BorderRadius.circular(12),
            color: resolvedColor,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class _PostHeader extends StatelessWidget {
  const _PostHeader({
    required this.userImage,
    required this.userName,
    required this.displayName,
  });

  final AssetImage userImage;
  final String userName;
  final String displayName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          _PostToolTip(
            child: ClipOval(
              child: Image(height: 48, image: userImage),
            ),
          ),
          const SizedBox(width: 4),
          _PostToolTip(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 4,
                  children: [
                    TextLink(
                      displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const VectorIcon(
                      width: 16,
                      asset: SvgAsset.heartBlue,
                    ),
                    const VectorIcon(
                      width: 16,
                      asset: SvgAsset.verified,
                    ),
                  ],
                ),
                Row(
                  spacing: 4,
                  children: [
                    TextLink(
                      '@$userName',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF536471),
                      ),
                    ),
                    const Text('·', style: TextStyle(fontSize: 16)),
                    const TextLink(
                      'Follow',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF006FD6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          const Align(
            alignment: Alignment.topRight,
            child: VectorIcon(width: 25, asset: SvgAsset.x),
          ),
        ],
      ),
    );
  }
}

class _PostText extends StatelessWidget {
  const _PostText({
    required this.data,
  });

  final String data;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      final double width = size.maxWidth;

      return SelectableText(
        data,
        style: TextStyle(
          fontSize: width >= 328 ? 20 : 14,
          height: width >= 328 ? 1.2 : 1.36,
        ),
      );
    });
  }
}

class _PostImage extends StatelessWidget {
  const _PostImage({this.postImage});

  final AssetImage? postImage;

  @override
  Widget build(BuildContext context) {
    late Widget result;

    if (postImage == null) {
      result = const SizedBox();
    } else {
      result = ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 514),
        child: ClipRRect(
          borderRadius: const BorderRadiusGeometry.all(
            Radius.circular(10),
          ),
          child: Image(
            fit: BoxFit.fitWidth,
            alignment: AlignmentGeometry.topCenter,
            width: 514,
            image: postImage!,
          ),
        ),
      );
    }

    return result;
  }
}

class _PostFooter extends StatelessWidget {
  const _PostFooter({
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final String data = DateFormat("h:mm a · MMM d, y").format(date);

    return SizedBox(
      height: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _PostToolTip(
            message: data,
            child: TextLink(
              data,
              style: const TextStyle(fontSize: 15, color: Color(0xFF536471)),
            ),
          ),
          const Button(iconAsset: SvgAsset.info, hoverColor: Color(0xFF006FD6))
        ],
      ),
    );
  }
}

class _PostActions extends StatelessWidget {
  const _PostActions({
    required this.likes,
  });

  final int likes;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Row(
        spacing: 20,
        children: [
          _PostToolTip(
            message: 'Like this post',
            child: Button(
              label: NumberFormat.compact().format(likes),
              iconAsset: SvgAsset.heartRed,
              hoverColor: const Color(0xFFF91880),
            ),
          ),
          const _PostToolTip(
            message: 'Share this post',
            child: Button(
              label: 'Copy Link',
              iconAsset: SvgAsset.link,
              hoverColor: Color(0xFF00BA7C),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostRepliesButton extends StatelessWidget {
  const _PostRepliesButton({
    required this.replies,
  });

  final int replies;

  @override
  Widget build(BuildContext context) {
    return Button(
      label: 'Read $replies replies',
      labelColor: const Color(0xFF006FD6),
      hoverColor: const Color(0xFF006FD6),
      boxDecoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCFD9DE)),
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}

class _PostToolTip extends StatelessWidget {
  const _PostToolTip({
    this.message = 'View profile on X',
    this.child,
  });

  final String message;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      waitDuration: Durations.extralong1,
      child: child,
    );
  }
}
