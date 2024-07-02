import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {required this.dWidth,
      required this.message,
      required this.userName,
      required this.isMe,
      super.key,
      this.userImage});
  final String userName;
  final double dWidth;
  final String message;
  final bool isMe;
  final String? userImage;
  @override
  Widget build(BuildContext context) {



//walking the tree is expensive!!!!!!!!!!!!!!!!!!!!!!!

    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
                width: 120,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                decoration: BoxDecoration(
                    color: isMe
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.only(
                        bottomLeft: isMe ? Radius.circular(10) : Radius.zero,
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                        bottomRight: isMe ? Radius.zero : Radius.circular(10))),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(userName,
                        style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context)
                                .primaryTextTheme
                                .titleMedium!
                                .color)),
                    Text(message,
                        style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context)
                                .primaryTextTheme
                                .titleMedium!
                                .color)),
                  ],
                ))
          ],
        ),
        Positioned(
          right: isMe ? null : dWidth * 0.60,
          left: isMe ? dWidth*0.60 : null,
          child: CircleAvatar(
           backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(
              
              userImage!,
            ),
          ),
        )
      ],
    );
  }
}
