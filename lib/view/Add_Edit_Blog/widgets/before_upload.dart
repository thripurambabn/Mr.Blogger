import 'package:carousel_pro/carousel_pro.dart';
import 'package:custom_switch_button/custom_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/view/Add_Edit_Blog/widgets/description.dart';
import 'package:mr_blogger/view/Add_Edit_Blog/widgets/dropbox.dart';
import 'package:mr_blogger/view/Add_Edit_Blog/widgets/title.dart';
import 'package:zefyr/zefyr.dart';

class BeforeUpload extends StatefulWidget {
  final Blogs blog;
  final List<String> imageUrlList;
  final bool isEdit;
  final bool toggleValue;
  final VoidCallback toggleButton;
  final Function getImage;
  final bool imageLoading;
  final TextEditingController titleController;
  final String mytitlevalue;
  final String myValue;
  String dropdownValue;
  // final focusNode;
  final Function(String) changeIt;
  //final ZefyrController descriptionController;
  final TextEditingController descriptionController;
  BeforeUpload({
    Key key,
    this.blog,
    this.imageUrlList,
    this.isEdit,
    this.toggleValue,
    this.toggleButton,
    this.imageLoading,
    this.titleController,
    this.mytitlevalue,
    this.myValue,
    this.dropdownValue,
    this.descriptionController,
    this.getImage,
    this.changeIt,
    // this.focusNode
  }) : super(key: key);

  @override
  _BeforeUploadState createState() => _BeforeUploadState();
}

class _BeforeUploadState extends State<BeforeUpload> {
  @override
  Widget build(BuildContext context) {
//view before entering the blog details
    List<NetworkImage> networkImages = List<NetworkImage>();
    if (widget.blog != null) {
      for (var image in widget.blog.image) {
        widget.imageUrlList.add(image);
        networkImages.add(
          NetworkImage(image),
        );
      }
    }
    return new Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                child: Text(
                  'Privacy:',
                  style: TextStyle(
                      fontFamily: 'Paficico', color: Colors.purple[500]),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                child: InkWell(
                    child: Center(
                      child: CustomSwitchButton(
                          backgroundColor: Colors.purple[300],
                          unCheckedColor: Colors.white,
                          animationDuration: Duration(milliseconds: 400),
                          checkedColor: Colors.purple[800],
                          checked: widget.isEdit == true
                              ? widget.blog.blogPrivacy
                              : widget.toggleValue),
                    ),
                    onTap: widget.toggleButton),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          DropBox(
            dropdownValue: widget.dropdownValue,
            blog: widget.blog,
            isEdit: widget.isEdit,
            changeIt: (newValue) {
              widget.changeIt(newValue);
            },
          ),
          TitleWidget(
            titleController: widget.titleController,
            mytitleValue: widget.mytitlevalue,
          ),
          SizedBox(
            height: 20,
          ),
          widget.isEdit
              ? InkWell(
                  child: Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      height: 240.0,
                      width: MediaQuery.of(context).size.width,
                      child: Carousel(
                        images: networkImages,
                        dotSize: 8.0,
                        dotSpacing: 15.0,
                        dotColor: Colors.purple[800],
                        indicatorBgPadding: 5.0,
                        autoplay: false,
                        dotBgColor: Colors.white.withOpacity(0),
                        borderRadius: true,
                      )),
                  onTap: widget.getImage,
                )
              : widget.imageLoading
                  ? Container(
                      color: Colors.purple[100],
                      height: 240,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                          child: Text('Loading your images...',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.purple,
                                  fontFamily: 'Paficico'))))
                  : InkWell(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        color: Colors.purple[200],
                        alignment: Alignment.center,
                        height: 240,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                FontAwesomeIcons.solidImages,
                              ),
                              tooltip: 'Add photo',
                              iconSize: 50,
                              color: Colors.white,
                              splashColor: Colors.purple,
                              onPressed: widget.getImage,
                            ),
                            Text(
                              'Add Photo',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.purple, fontFamily: 'Paficico'),
                            )
                          ],
                        ),
                        //   width: 340,
                      ),
                      onTap: widget.getImage,
                    ),
          SizedBox(
            height: 10,
          ),
          DescriptionField(
            descriptionController: widget.descriptionController,
            //focusNode: widget.focusNode,
            // myValue: _myvalue,
          ),
          RaisedButton(
            child: Text(
              widget.isEdit == true ? 'update blog' : 'upload blog',
              style: TextStyle(color: Colors.white, fontFamily: 'Paficico'),
            ),
            color: Colors.purple[800],
            onPressed: null,
          )
        ],
      ),
    );
  }
}
