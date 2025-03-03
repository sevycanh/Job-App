import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ReusableText extends StatelessWidget {
  ReusableText({super.key, required this.text, required this.style, this.softWrap});

  final String text;
  final TextStyle style;
  bool? softWrap = false;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      // maxLines: maxLines ? 1 : null,
      softWrap: softWrap,
      textAlign: TextAlign.left,
      overflow: TextOverflow.fade,
      style: style,
    );
  }
}
