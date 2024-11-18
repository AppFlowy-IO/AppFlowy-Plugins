import 'package:flutter/material.dart';

class CodeBlockStyle {
  const CodeBlockStyle({
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.showLineNumbers = false,
    this.wrapLines = false,
  }) : assert(
          !(wrapLines && showLineNumbers),
          'showing line numbers while wrapping isn\'t currently supported',
        );

  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool showLineNumbers;
  final bool wrapLines;
}
