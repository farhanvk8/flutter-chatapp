import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, futureSnap) {
          if (futureSnap.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
            stream: Firestore.instance
                .collection('chat')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatSnapshot = snapshot.data.documents;

              return ListView.builder(
                reverse: true,
                itemBuilder: (ctx, i) => MessageBubble(
                  chatSnapshot[i]['text'],
                  chatSnapshot[i]['username'],
                  chatSnapshot[i]['userImage'],
                  chatSnapshot[i]['userId'] == futureSnap.data.uid,
                  key: ValueKey(chatSnapshot[i].documentID),
                ),
                itemCount: chatSnapshot.length,
              );
            },
          );
        });
  }
}
