import 'package:flutter/material.dart';

class SingleMessage extends StatelessWidget {
  final String message;
  final bool isMe;
  SingleMessage({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isMe ? 64.0 : 16.0,
        4,
        isMe ? 16.0 : 64.0,
        4,
      ),
      child:Align(
        // align the child within the container
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: DecoratedBox(
          // chat bubble decoration
          decoration: BoxDecoration(
            color: isMe ? Colors.blue : Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: isMe ? Colors.white : Colors.black87),
            ),
          ),
        ),
      ),
    );
    
  }
}
