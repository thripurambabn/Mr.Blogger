import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:mr_blogger/blocs/reg_bloc/reg_bloc.dart';
import 'package:mr_blogger/service/user_service.dart';
import 'package:mr_blogger/view/Register_Screen/register_form.dart';

class RegisterScreen extends StatelessWidget {
  final UserService _userService;

  RegisterScreen({Key key, @required UserService userService})
      : assert(userService != null),
        _userService = userService,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (BuildContext context) {
      return OfflineBuilder(
          connectivityBuilder: (BuildContext context,
              ConnectivityResult connectivity, Widget child) {
            final bool connected = connectivity != ConnectivityResult.none;
            return Stack(
              fit: StackFit.expand,
              children: [
                child,
                Positioned(
                  left: 0.0,
                  right: 0.0,
                  height: 32.0,
                  child: connected
                      ? Container()
                      : AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          color: connected
                              ? Colors.purple[800]
                              : Color(0xFFEE4400),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "OFFLINE",
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              SizedBox(
                                width: 12.0,
                                height: 12.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            );
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            colors: [
                              Colors.purple[400],
                              Colors.purple[300],
                              Colors.purple[900]
                            ],
                            end: FractionalOffset.topCenter),
                        color: Colors.purpleAccent),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "SignUp",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontFamily: 'Paficico'),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.76,
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(60),
                                    topRight: Radius.circular(60))),
                            child: BlocProvider<RegisterBloc>(
                              create: (context) =>
                                  RegisterBloc(userService: _userService),
                              child: RegisterForm(
                                userService: _userService,
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
              ],
            ),
          ));
    }));
  }
}
