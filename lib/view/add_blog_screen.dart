import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mr_blogger/blocs/blogs_bloc/blogs_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_event.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_state.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/service/blog_service.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/home_screen.dart';
import 'package:mr_blogger/view/loading_page.dart';

class AddBlogScreen extends StatefulWidget {
  final bool isEdit;
  final Blogs blog;
  const AddBlogScreen({Key key, @required this.isEdit, @required this.blog})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _AddBlogScreenPage();
  }
}

class _AddBlogScreenPage extends State<AddBlogScreen> {
  File sampleImage;
  final formKey = new GlobalKey<FormState>();
  String _mytitlevalue;
  String category;
  String likes;
  String imageUrl;
  bool isbuttondisabled = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  //instance of blog Service and User Service
  var userService = UserService();
  static BlogsService _blogsServcie = BlogsService();
  var _blog = BlogsBloc(blogsService: _blogsServcie);

  bool get isEdit => widget.isEdit;
  static String _myvalue;

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlogsBloc, BlogsState>(
        bloc: _blog,
        listener: (context, state) {
          if (state is BlogsLoaded) {
            navigateToHomePage();
          }
        },
        child: new WillPopScope(
          onWillPop: _onWillPop,
          child: new Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.purple[800],
              title: isEdit
                  ? Text(
                      'Edit blog',
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'Paficico'),
                    )
                  : Text(
                      'Add blog',
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'Paficico'),
                    ),
            ),
            body: SingleChildScrollView(
              child: new Center(
                child: sampleImage == null ? beforeUpload() : enableUplaod(),
              ),
            ),
          ),
        ));
  }

  @override
  void initState() {
    _titleController.text = widget.isEdit == true ? widget.blog.title : '';
    _descriptionController.text =
        widget.isEdit == true ? widget.blog.description : '';
    return super.initState();
  }

//Navigate back confirmation dialog box
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            content: new Text(
              'Are you sure you want to go back?',
              style:
                  TextStyle(color: Colors.purple[500], fontFamily: 'Paficico'),
            ),
            actions: <Widget>[
              Container(
                  child: new OutlineButton(
                    color: Colors.white,
                    onPressed: () => Navigator.of(context).pop(false),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(0.0)),
                    child: new Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.purple[500], fontFamily: 'Paficico'),
                    ),
                  ),
                  width: 80),
              Container(
                child: new RaisedButton(
                  color: Colors.purple[500],
                  onPressed: () => Navigator.of(context).pop(true),
                  child: new Text('Yes',
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'Paficico')),
                ),
                width: 80,
              ),
            ],
          ),
        )) ??
        false;
  }

//fetch image from the gallery
  Future getImage() async {
    print('selecting and image');
    final _picker = ImagePicker();
    //   var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    final pickedFile =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 85);
    final File file = File(pickedFile.path);
    print('selected a image');
    setState(() {
      sampleImage = file;
    });
    var url = await _blogsServcie.uploadImage(sampleImage: sampleImage);
    setState(() {
      imageUrl = url;
    });
  }

  // bool validateandSave() {
  //   final form = formKey.currentState;
  //   if (form.validate()) {
  //     form.save();
  //     return true;
  //   }
  // }

//calls Upload Image event to add blog
  void addBlog() {
    //   validateandSave();
    _blog.add(
      UploadBlog(
        url: imageUrl,
        image: sampleImage,
        title: _titleController.text,
        description: _descriptionController.text,
        category: category,
      ),
    );
  }

  void updateBlog() {
    _blog.add(
      UpdateBlog(
          image: imageUrl,
          //  image: sampleImage,
          title: _titleController.text,
          description: _descriptionController.text,
          category: 'play',
          timeStamp: widget.blog.timeStamp),
    );
  }

//Navigate to homepage
  void navigateToLoadingPage() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return new LoadingPage();
      },
    ));
  }

  void navigateToHomePage() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return Homepage();
      },
    ));
  }

//view after entering the blog details
  Widget enableUplaod() {
    return new Container(
      child: new Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            dropbox(),
            title(),
            SizedBox(
              height: 20,
            ),
            InkWell(
              child: Image.file(
                sampleImage,
                height: 255.0,
                width: 340,
              ),
              onTap: getImage,
            ),
            SizedBox(
              height: 10.0,
            ),
            descriptionfield(),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              child: Text(
                widget.isEdit == true ? 'update blog' : 'uploade blog',
                style: TextStyle(color: Colors.white, fontFamily: 'Paficico'),
              ),
              color: Colors.purple[800],
              onPressed: isbuttondisabled
                  ? null
                  : () {
                      setState(() => isbuttondisabled = !isbuttondisabled);
                      widget.isEdit == true ? updateBlog() : addBlog();
                      navigateToLoadingPage();
                    },
            )
          ],
        ),
      ),
    );
  }

//view before entering the blog details
  beforeUpload() {
    return new Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          dropbox(),
          title(),
          SizedBox(
            height: 20,
          ),
          isEdit
              ? InkWell(
                  child: Image.network(widget.blog.image),
                  onTap: getImage,
                )
              : InkWell(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 20, 20, 10),
                    color: Colors.purple[300],
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
                          onPressed: getImage,
                        ),
                        Text(
                          'Add Photo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.purple, fontFamily: 'Paficico'),
                        )
                      ],
                    ),
                    width: 340,
                  ),
                  onTap: getImage,
                ),
          SizedBox(
            height: 10,
          ),
          descriptionfield(),
          RaisedButton(
            child: Text(
              widget.isEdit == true ? 'update blog' : 'upload blog',
              style: TextStyle(color: Colors.white, fontFamily: 'Paficico'),
            ),
            color: Colors.purple[800],
            onPressed: isbuttondisabled
                ? null
                : () {
                    setState(() => isbuttondisabled = !isbuttondisabled);

                    widget.isEdit == true ? updateBlog() : addBlog();

                    navigateToLoadingPage();
                  },
          )
        ],
      ),
    );
  }

  dropbox() {
    String dropdownValue;
    return Container(
      width: 340,
      padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
      decoration: BoxDecoration(border: Border.all(color: Colors.purple[400])),
      alignment: Alignment.bottomLeft,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            "Select category",
            style: TextStyle(color: Colors.purple[200]),
          ),
          isDense: true,
          value: dropdownValue,
          icon: Icon(FontAwesomeIcons.sortDown),
          iconSize: 30,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: <String>['Pets', 'Travel', 'Books', 'Lifestyle', 'Movies']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  descriptionfield() {
    //print('inside description ${widget.blog.description} ${isEdit}');
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
              controller: _descriptionController,
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
                _myvalue = value;
              },
            ),
          )),
        ),
      ],
    ));
  }

  title() {
    return Container(
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
            controller: _titleController,
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
              _mytitlevalue = value;
            },
          ),
        )
      ]),
    );
  }
}
