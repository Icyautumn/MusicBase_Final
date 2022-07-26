import 'package:flutter/material.dart';

class SingleMessage extends StatelessWidget {
  final String message;
  final bool isMe;
  SingleMessage({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    // return Row(
    //   mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
    //   children: [
    //     Container(
    //         padding: EdgeInsets.all(16),
    //         margin: EdgeInsets.all(16),
    //         constraints: BoxConstraints(maxWidth: 200),
    //         decoration: BoxDecoration(
    //             color: isMe ? Colors.blue : Colors.green.shade300,
    //             borderRadius: BorderRadius.all(Radius.circular(12))),
    //         child: Text(
    //           message,
    //           style: TextStyle(
    //             color: Colors.white,
    //           ),
    //         )),
    //   ],
    // );
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
