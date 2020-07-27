import 'package:flutter/material.dart';

class DescriptionField extends StatefulWidget {
  final TextEditingController descriptionController;
  String myValue;
  DescriptionField({Key key, this.descriptionController, this.myValue})
      : super(key: key);

  @override
  _DescriptionFieldState createState() => _DescriptionFieldState();
}

class _DescriptionFieldState extends State<DescriptionField> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          alignment: Alignment.centerLeft,
          child: Text(
            'Description:',
            style: TextStyle(
                fontFamily: 'Paficico',
                color: Colors.purple[500],
                fontSize: 18),
            textAlign: TextAlign.left,
          ),
        ),
        new Scrollbar(
          child: SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: TextFormField(
              controller: widget.descriptionController,
              textAlign: TextAlign.left,
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              minLines: 5,
              decoration: new InputDecoration(
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: Colors.purple[300])),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.purple, width: 1.0),
                  ),
                  hintText: 'Write Something...',
                  hintStyle: TextStyle(color: Colors.purple[200])),
              validator: (value) {
                return value.isEmpty ? 'blog decription is required' : null;
              },
              onChanged: (value) {
                //  print('value saved ${value}');
                widget.myValue = value;
              },
            ),
            //     ZefyrScaffold(
            //   child: ZefyrEditor(
            //     controller: _descriptionController,
            //     focusNode: _focusNode,
            //   ),
            // )
          )),
        ),
      ],
    ));
  }
}
