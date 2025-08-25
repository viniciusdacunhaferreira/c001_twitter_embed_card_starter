import 'package:flutter/material.dart';

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
