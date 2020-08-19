import 'package:flutter/material.dart';

class TitleWidget extends StatefulWidget {
  final TextEditingController titleController;
  String mytitleValue;
  TitleWidget({Key key, this.titleController, this.mytitleValue})
      : super(key: key);

  @override
  _TitleWidgetState createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          alignment: Alignment.centerLeft,
          child: Text(
            'TITLE:',
            style: TextStyle(fontFamily: 'Paficico', color: Colors.purple[500]),
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextFormField(
            controller: widget.titleController,
            textAlign: TextAlign.left,
            maxLines: 4,
            minLines: 1,
            decoration: new InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.purple)),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.purple, width: 1.0),
                ),
                hintText: 'Enter your title',
                hintStyle: TextStyle(color: Colors.purple[200])),
            validator: (value) {
              return value.isEmpty ? 'Title for your blog is required' : null;
            },
            onChanged: (value) {
              widget.mytitleValue = value;
            },
          ),
        )
      ]),
    );
  }
}
