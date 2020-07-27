import 'dart:async';
import 'dart:io';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_bloc.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_event.dart';
import 'package:mr_blogger/blocs/blogs_bloc/blogs_state.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/service/blog_service.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/Add_Edit_Blog/widgets/before_upload.dart';
import 'package:mr_blogger/view/Add_Edit_Blog/widgets/enable_upload.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

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
  List<String> imageUrl;
  bool isbuttondisabled = false;
  List<Asset> images = List<Asset>();
  List<String> imageUrlList = List<String>();
  String _error = 'No Error Dectected';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool imageLoading = false;
  bool toggleValue = false;
  //instance of blog Service and User Service
  var userService = UserService();
  static BlogsService _blogsServcie = BlogsService();
  var _blog = BlogsBloc(blogsService: _blogsServcie);
  // ZefyrController _descriptionController;
  FocusNode _focusNode;
  bool get isEdit => widget.isEdit;
  static String _myvalue;

  @override
  Widget build(BuildContext context) {
    print('dropdown ${widget.blog.title}');
    return BlocListener<BlogsBloc, BlogsState>(
        bloc: _blog,
        listener: (context, state) {
          if (state is BlogsLoaded) {
            return navigateToHomePage();
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
                child: imageUrl == null
                    ? BeforeUpload(
                        blog: widget.blog,
                        imageUrlList: imageUrlList,
                        isEdit: widget.isEdit,
                        toggleValue: toggleValue,
                        toggleButton: () {
                          toggleButton();
                        },
                        imageLoading: imageLoading,
                        titleController: _titleController,
                        mytitlevalue: _mytitlevalue,
                        myValue: _myvalue,
                        dropdownValue:
                            widget.isEdit == true ? widget.blog.category : '',
                        descriptionController: _descriptionController,
                        getImage: () {
                          getImage();
                        })
                    : EnableUpload(
                        gridview: buildGridView,
                        toggleButton: toggleButton(),
                        toggleValue: toggleValue,
                        dropdownValue:
                            widget.isEdit == true ? widget.blog.category : '',
                        titleController: _titleController,
                        descriptionController: _descriptionController,
                        isEdit: widget.isEdit,
                        blog: widget.blog,
                        formKey: formKey,
                        updateBlog: () {
                          updateBlog();
                        },
                        addBlog: () {
                          addBlog();
                        },
                        getImage: () {
                          getImage();
                        },
                        mytitleValue: _mytitlevalue),
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
    super.initState();
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
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Mr.Blogger",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      images = resultList;
      _error = error;
      imageLoading = true;
      imageUrl = null;
    });
    List<String> urlList = List<String>();
    for (var image in resultList) {
      var url = await _blogsServcie.uploadImage(sampleImage: image);
      urlList.add(url);
    }

    setState(() {
      imageUrl = urlList;
      imageLoading = false;
    });
  }

  Widget buildGridView() {
    print('networkImages $imageUrl');
    List<NetworkImage> networkImages = List<NetworkImage>();
    //print('image url in befor for $imageUrl}');
    if (imageUrl != null) {
      for (var image in imageUrl) {
        networkImages.add(
          NetworkImage(image),
        );
      }

      if (networkImages.length > 0) {
        return InkWell(
            child: SizedBox(
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
                )));
      } else {
        return Text('error in loading');
      }
    }
  }

//calls Upload Image event to add blog
  void addBlog() {
    _blog.add(
      UploadBlog(
        url: imageUrl,
        image: sampleImage,
        title: _titleController.text,
        description: _descriptionController.text,
        category: widget.isEdit == true ? widget.blog.category : '',
        blogPrivacy: toggleValue,
      ),
    );
  }

  void updateBlog() {
    print('update');
    _blog.add(
      UpdateBlog(
          image: imageUrl,
          title: _titleController.text,
          description: _descriptionController.text,
          category: widget.isEdit == true ? widget.blog.category : '',
          timeStamp: widget.blog.timeStamp,
          blogPrivacy: widget.blog.blogPrivacy),
    );
  }

  void navigateToHomePage() {
    //int count = 0;
    print('navigation back to home');
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  toggleButton() {
    setState(() {
      toggleValue = !toggleValue;
    });
  }
}
