import 'package:carousel_pro/carousel_pro.dart';
import 'package:custom_switch_button/custom_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/view/Add_Edit_Blog/widgets/description.dart';
import 'package:mr_blogger/view/Add_Edit_Blog/widgets/dropbox.dart';
import 'package:mr_blogger/view/Add_Edit_Blog/widgets/title.dart';
import 'package:mr_blogger/view/Loading_Page/loading_page.dart';
import 'package:zefyr/zefyr.dart';

class EnableUpload extends StatefulWidget {
  final Function gridview;
  final Function toggleButton;
  final Function updateBlog;
  final Function addBlog;
  final Function getImage;
  final bool toggleValue;
  final String dropdownValue;
  final List<String> imageUrlList;
  final TextEditingController titleController;
  //final ZefyrController descriptionController;
  final TextEditingController descriptionController;
  final bool isEdit;
  final Blogs blog;
  final String mytitleValue;
  final Function changeIt;
  final focusNode;
  bool isbuttondisabled;
  final bool imageLoading;
  final formKey;
  EnableUpload(
      {Key key,
      this.gridview,
      this.toggleButton,
      this.toggleValue,
      this.dropdownValue,
      this.titleController,
      this.descriptionController,
      this.isEdit,
      this.blog,
      this.updateBlog,
      this.addBlog,
      this.mytitleValue,
      this.formKey,
      this.getImage,
      this.changeIt,
      this.focusNode,
      Function(String newdropdownValue),
      this.isbuttondisabled,
      this.imageUrlList,
      this.imageLoading})
      : super(key: key);

  @override
  _EnableUploadState createState() => _EnableUploadState();
}

class _EnableUploadState extends State<EnableUpload> {
  @override
  Widget build(BuildContext context) {
    //Navigate to homepage
    void navigateToLoadingPage() {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return new LoadingPage();
        },
      ));
    }

    print('widget imageurl ${widget.imageUrlList}');
    List<NetworkImage> networkImages = List<NetworkImage>();
    if (widget.imageUrlList != null) {
      for (var image in widget.imageUrlList) {
        //widget.imageUrlList.add(image);
        networkImages.add(
          NetworkImage(image),
        );
      }
    }
    print('isbuttondisabled ${networkImages}');
    //view after entering the blog details
    return new Container(
      child: new Form(
        key: widget.formKey,
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
            DropBox(
              changeIt: (newValue) {
                widget.changeIt(newValue);
              },
              dropdownValue: widget.dropdownValue,
              blog: widget.blog,
              isEdit: widget.isEdit,
            ),
            TitleWidget(
              titleController: widget.titleController,
              mytitleValue: widget.mytitleValue,
            ),
            SizedBox(
              height: 20,
            ),
            widget.imageLoading
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
                  ),
            // InkWell(
            //     onTap: widget.getImage,
            //     child: Container(
            //         color: Colors.purple[50],
            //         alignment: Alignment.center,
            //         height: 240,
            //         child: widget.gridview())),
            SizedBox(
              height: 10.0,
            ),
            DescriptionField(
              descriptionController: widget.descriptionController,
              //focusNode: widget.focusNode,
              // myValue: _myvalue,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text('Note: You need upload iamge to enable update blog button'),
            RaisedButton(
              child: Text(
                widget.isEdit == true ? 'update blog' : 'upload blog',
                style: TextStyle(color: Colors.white, fontFamily: 'Paficico'),
              ),
              color: Colors.purple[800],
              onPressed: widget.isbuttondisabled
                  ? null
                  : () {
                      setState(() =>
                          {widget.isbuttondisabled = !widget.isbuttondisabled});
                      widget.isEdit == true
                          ? widget.updateBlog()
                          : widget.addBlog();
                      navigateToLoadingPage();
                    },
            )
          ],
        ),
      ),
    );
  }
}
