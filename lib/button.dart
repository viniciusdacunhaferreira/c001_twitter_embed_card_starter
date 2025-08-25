import 'package:flutter/material.dart';
import 'package:twitter_embed_card/mouse_status.dart';
import 'package:twitter_embed_card/svg_asset.dart';
import 'package:twitter_embed_card/vector_icon.dart';

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
  MouseStatus status = MouseStatus.out;

  @override
  Widget build(BuildContext context) {
    bool hasHoverColor = widget.hoverColor != null;
    bool hasLabelColor = widget.labelColor != null;
    bool hasIcon = widget.iconAsset != null;
    bool hasLabel = widget.label != null;
    bool hasBoxDecoration = widget.boxDecoration != null;

    EdgeInsetsGeometry? resolvedPadding;
    BoxDecoration? resolvedBoxDecoration = widget.boxDecoration;
    HitTestBehavior? resolvedHitTestBehavior;

    final List<Widget> results = [];

    if (hasIcon) {
      final vectorIcon = VectorIcon(
        height: 20,
        width: 20,
        asset: widget.iconAsset!,
      );

      final iconWidget = AnimatedContainer(
        duration: Durations.short3,
        decoration: BoxDecoration(
            color: (status.isHover && hasHoverColor)
                ? widget.hoverColor!.withValues(alpha: 0.1)
                : null,
            borderRadius: BorderRadius.circular(16)),
        width: 32,
        height: 32,
        child: Center(
          child: (status.isHover && hasHoverColor)
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

      results.add(iconWidget);
    }

    if (hasLabel) {
      Color resolvedLabelColor = const Color(0xFF536471);
      TextDecoration? resolvedTextDecoration;

      if (hasLabelColor) resolvedLabelColor = widget.labelColor!;
      if (hasHoverColor && status.isHover) {
        resolvedLabelColor = widget.hoverColor!;
      }
      if (status.isHover && hasHoverColor && !hasBoxDecoration) {
        resolvedTextDecoration = TextDecoration.underline;
      }

      final labelWidget = Container(
        margin: const EdgeInsets.only(left: 4),
        child: Text(
          widget.label!,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            decoration: resolvedTextDecoration,
            decorationColor: widget.hoverColor,
            color: resolvedLabelColor,
          ),
        ),
      );

      results.add(labelWidget);
    }

    if (hasBoxDecoration) {
      resolvedPadding = const EdgeInsetsGeometry.only(left: 15, right: 15);
      resolvedHitTestBehavior = HitTestBehavior.deferToChild;
    }

    if (hasBoxDecoration && status.isHover && hasHoverColor) {
      resolvedBoxDecoration = widget.boxDecoration!.copyWith(
        color: widget.hoverColor!.withValues(alpha: 0.1),
      );
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      hitTestBehavior: resolvedHitTestBehavior,
      onEnter: (_) => setState(() => status = MouseStatus.hover),
      onExit: (_) => setState(() => status = MouseStatus.out),
      child: AnimatedContainer(
        duration: Durations.short3,
        decoration: resolvedBoxDecoration,
        padding: resolvedPadding,
        height: 30,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [...results],
        ),
      ),
    );
  }
}
