import 'package:flutter/material.dart';

class PostData {
  const PostData(
      {required this.userName,
      required this.displayName,
      required this.userImage,
      required this.postText,
      this.postImage,
      required this.date,
      required this.likes,
      required this.replies});

  final String userName;
  final String displayName;
  final AssetImage userImage;
  final String postText;
  final AssetImage? postImage;
  final DateTime date;
  final int likes;
  final int replies;
}
