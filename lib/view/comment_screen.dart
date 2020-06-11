import 'package:flutter/cupertino.dart';

class CommentsScreen extends StatefulWidget {
  CommentsScreen({Key key}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('comments screen'),
    );
  }
}
