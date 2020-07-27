import 'package:custom_switch_button/custom_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:mr_blogger/models/blogs.dart';
import 'package:mr_blogger/view/Add_Edit_Blog/widgets/description.dart';
import 'package:mr_blogger/view/Add_Edit_Blog/widgets/dropbox.dart';
import 'package:mr_blogger/view/Add_Edit_Blog/widgets/title.dart';
import 'package:mr_blogger/view/Loading_Page/loading_page.dart';

class EnableUpload extends StatefulWidget {
  final Function gridview;
  final Function toggleButton;
  final Function updateBlog;
  final Function addBlog;
  final Function getImage;
  final bool toggleValue;
  final String dropdownValue;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final bool isEdit;
  final Blogs blog;
  final String mytitleValue;
  final Function changeIt;
  bool isbuttondisabled = false;
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
      this.changeIt})
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

    //view after entering the blog details
    print('enable upload ${widget.dropdownValue}');
    return new Container(
      child: new Form(
        key: widget.formKey,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            InkWell(
                child: Center(
                  child: CustomSwitchButton(
                    backgroundColor: Colors.purple[300],
                    unCheckedColor: Colors.white,
                    animationDuration: Duration(milliseconds: 400),
                    checkedColor: Colors.purple[800],
                    checked: widget.toggleValue,
                  ),
                ),
                onTap: widget.toggleButton),
            DropBox(
              dropdownValue: widget.dropdownValue ?? widget.changeIt(),
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
            InkWell(
                onTap: widget.getImage,
                child: Container(
                    color: Colors.purple[50],
                    alignment: Alignment.center,
                    height: 240,
                    child: widget.gridview())),
            SizedBox(
              height: 10.0,
            ),
            DescriptionField(
              descriptionController: widget.descriptionController,
              // myValue: _myvalue,
            ),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              child: Text(
                widget.isEdit == true ? 'update blog' : 'uploade blog',
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
