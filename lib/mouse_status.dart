enum MouseStatus {
  out,
  hover,
  clicked;

  bool get isOut => this == out;
  bool get isHover => this == hover;
  bool get isClicked => this == clicked;
}
