import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twitter_embed_card/svg_asset.dart';
import 'package:twitter_embed_card/vector_icon.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

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
              child: TwitterEmbedCard(
                userName: 'biz84',
                displayName: 'Andrea Bizzotto',
                userImage: const AssetImage('assets/andrea-avatar.png'),
                postText:
                    'Did you know?\n\nWhen you call `MediaQuery.of(context)` inside a build method, the widget will rebuild when *any* of the MediaQuery properties change.\n\nBut there\'s a better way that lets you depend only on the properties you care about (and minimize unnecessary rebuilds). 👇',
                postImage: const AssetImage('assets/media-query-banner.jpg'),
                date: DateTime(2023, 6, 20, 6, 21),
                likes: 1000,
                replies: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TwitterEmbedCard extends StatelessWidget {
  const TwitterEmbedCard(
      {super.key,
      required this.userName,
      required this.displayName,
      required this.userImage,
      required this.postText,
      this.postImage,
      required this.date,
      required this.likes,
      required this.replies});

  final String userName;
  final String displayName;
  final AssetImage userImage;
  final String postText;
  final AssetImage? postImage;
  final DateTime date;
  final int likes;
  final int replies;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // User info
          SizedBox(
            height: 48,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadiusGeometry.all(
                        Radius.circular(24),
                      ),
                      child: Image(
                        height: 48,
                        image: userImage,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
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
                                decoration: false,
                              ),
                              const Text(
                                '·',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
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
                  ],
                ),
                const SizedBox(
                  child: Align(
                    alignment: AlignmentGeometry.topRight,
                    child: VectorIcon(
                      width: 25,
                      asset: SvgAsset.x,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Post text
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SelectableText(
              postText,
              style: const TextStyle(
                fontSize: 20,
                height: 1.2,
              ),
            ),
          ),
          // Post image
          postImage == null
              ? const SizedBox()
              : ConstrainedBox(
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
                ),
          // Post footer
          Container(
            margin: const EdgeInsets.only(top: 2),
            height: 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextLink(
                  DateFormat("h:mm a · MMM d, y").format(date),
                  style:
                      const TextStyle(fontSize: 15, color: Color(0xFF536471)),
                ),
                const Button(
                  iconAsset: SvgAsset.info,
                  hoverColor: Color(0xFF006FD6),
                )
              ],
            ),
          ),
          // Interaction buttons
          Container(
            padding: const EdgeInsets.only(top: 4),
            margin: const EdgeInsets.only(top: 6),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFFCFD9DE),
                ),
              ),
            ),
            child: SizedBox(
              height: 32,
              child: Row(
                spacing: 20,
                children: [
                  Button(
                    label: NumberFormat.compact().format(likes),
                    iconAsset: SvgAsset.heartRed,
                    hoverColor: const Color(0xFFF91880),
                  ),
                  const Button(
                    label: 'Copy Link',
                    iconAsset: SvgAsset.link,
                    hoverColor: Color(0xFF00BA7C),
                  ),
                ],
              ),
            ),
          ),
          // Comments button
          Container(
            padding: const EdgeInsets.only(top: 4),
            child: Button(
              label: 'Read $replies replies',
              labelColor: const Color(0xFF006FD6),
              hoverColor: const Color(0xFF006FD6),
              boxDecoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFCFD9DE)),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Button extends StatefulWidget {
  const Button({
    super.key,
    this.label,
    this.iconAsset,
    this.hoverColor,
    this.labelColor,
    this.boxDecoration,
  });

  final String? label;
  final SvgAsset? iconAsset;
  final Color? hoverColor;
  final Color? labelColor;
  final BoxDecoration? boxDecoration;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    bool hasHoverColor = widget.hoverColor != null;
    bool hasLabelColor = widget.labelColor != null;
    bool hasIcon = widget.iconAsset != null;
    bool hasLabel = widget.label != null;
    bool hasBoxDecoration = widget.boxDecoration != null;

    EdgeInsetsGeometry? padding;
    BoxDecoration? resolvedBoxDecoration = widget.boxDecoration;

    final List<Widget> buttonWidgets = [];

    if (hasIcon) {
      final vectorIcon = VectorIcon(
        height: 20,
        width: 20,
        asset: widget.iconAsset!,
      );

      final iconWidget = Container(
        decoration: BoxDecoration(
            color: (isHover && hasHoverColor)
                ? widget.hoverColor!.withValues(alpha: 0.1)
                : null,
            borderRadius: BorderRadius.circular(16)),
        width: 32,
        height: 32,
        child: Center(
          child: (isHover && hasHoverColor)
              ? ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    widget.hoverColor!,
                    BlendMode.srcIn,
                  ),
                  child: vectorIcon,
                )
              : vectorIcon,
        ),
      );

      buttonWidgets.add(
        iconWidget,
      );
    }

    if (hasLabel) {
      Color resolvedLabelColor = const Color(0xFF536471);

      if (hasLabelColor) resolvedLabelColor = widget.labelColor!;
      if (hasHoverColor && isHover) resolvedLabelColor = widget.hoverColor!;

      final labelWidget = Container(
        margin: const EdgeInsets.only(left: 4),
        child: Text(
          widget.label!,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            decoration: (isHover && hasHoverColor && !hasBoxDecoration)
                ? TextDecoration.underline
                : null,
            decorationColor: widget.hoverColor,
            color: resolvedLabelColor,
          ),
        ),
      );

      buttonWidgets.add(labelWidget);
    }

    if (hasBoxDecoration) {
      padding = const EdgeInsetsGeometry.only(left: 15, right: 15);

      if (isHover && hasHoverColor) {
        resolvedBoxDecoration = widget.boxDecoration!.copyWith(
          color: widget.hoverColor!.withValues(alpha: 0.1),
        );
      }
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) {
        setState(() {
          isHover = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHover = false;
        });
      },
      child: Container(
        decoration: resolvedBoxDecoration,
        padding: padding,
        height: 30,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [...buttonWidgets],
        ),
      ),
    );
  }
}

class TextLink extends StatefulWidget {
  const TextLink(
    this.data, {
    super.key,
    this.style,
    this.decoration = true,
  });

  final String data;
  final TextStyle? style;
  final bool decoration;

  @override
  State<TextLink> createState() => _TextLinkState();
}

class _TextLinkState extends State<TextLink> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    TextDecoration? resolvedDecoration;
    TextStyle? resolvedTextStyle;

    if (widget.decoration && isHover) {
      resolvedDecoration = TextDecoration.underline;
    }
    if (widget.style == null) {
      resolvedTextStyle = TextStyle(
        decoration: resolvedDecoration,
      );
    } else {
      resolvedTextStyle = widget.style?.copyWith(
        decoration: resolvedDecoration,
        decorationColor: widget.style?.color,
      );
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) {
        setState(() {
          isHover = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHover = false;
        });
      },
      child: Text(
        widget.data,
        style: resolvedTextStyle,
      ),
    );
  }
}
