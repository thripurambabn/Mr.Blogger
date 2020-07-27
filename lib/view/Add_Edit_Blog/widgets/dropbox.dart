import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mr_blogger/models/blogs.dart';

class DropBox extends StatefulWidget {
  String dropdownValue;
  final bool isEdit;
  final Blogs blog;
  final Function(String) changeIt;
  DropBox({Key key, this.dropdownValue, this.isEdit, this.blog, this.changeIt})
      : super(key: key);

  @override
  _DropBoxState createState() => _DropBoxState();
}

class _DropBoxState extends State<DropBox> {
  onchanged() {}
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
      decoration: BoxDecoration(border: Border.all(color: Colors.purple[400])),
      alignment: Alignment.bottomLeft,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: widget.isEdit == true
              ? Text(widget.dropdownValue)
              : Text(
                  "Select category",
                  style: TextStyle(color: Colors.purple[200]),
                ),
          isDense: true,
          value: widget.dropdownValue == ''
              ? "select category"
              : widget.dropdownValue,
          icon: Icon(FontAwesomeIcons.sortDown),
          iconSize: 30,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          items: <String>[
            'select category',
            'Pets',
            'Travel',
            'Books',
            'Lifestyle',
            'Movies'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String newValue) {
            setState(() {
              widget.dropdownValue = newValue;
              widget.changeIt(newValue);
            });
          },
        ),
      ),
    );
  }
}
