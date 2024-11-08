import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    super.key,
    this.image,
    this.text,
    required this.isFromUser,
  });

  final Image? image;
  final String? text;
  final bool isFromUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
            child: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
              width: 300,
              constraints: const BoxConstraints(maxWidth: 520),
              decoration: BoxDecoration(
                color: isFromUser ? Colors.red : Colors.deepPurple,
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              margin: const EdgeInsets.only(bottom: 5),
              child: Column(children: [
                if (image != null)
                  SizedBox(
                    child: image!,
                  ),
                if (text != null) MarkdownBody(data: text!),
              ])),
        )),
      ],
    );
  }
}
