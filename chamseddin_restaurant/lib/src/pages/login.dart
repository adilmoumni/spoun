import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';

import 'package:flutter_login_facebook/flutter_login_facebook.dart';

import 'package:food_delivery_app/session_manager.dart';

import 'package:google_sign_in/google_sign_in.dart';

import 'package:http/http.dart' as http;

import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';

import '../TextSize.dart';

import '../controllers/user_controller.dart';

import '../helpers/app_config.dart' as config;

import '../helpers/helper.dart';

import '../models/social_login.dart';

import '../models/user.dart' as User1;

import '../repository/user_repository.dart' as userRepo;

import 'forget_password.dart';

import 'signup.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends StateMVC<LoginWidget> {
  UserController _con;

  TextEditingController _textEditingControllerEmail;

  TextEditingController _textEditingControllerPassword;

  TextEditingController _textEditingControllerDeviceToken;

  _LoginWidgetState() : super(UserController()) {
    _con = controller;
  }

  @override
  void initState() {
    _textEditingControllerEmail = TextEditingController();

    _textEditingControllerPassword = TextEditingController();

    _textEditingControllerDeviceToken = TextEditingController();

    super.initState();

    if (userRepo.currentUser.value.apiToken != null) {
      Navigator.of(context).pushReplacementNamed('/Pages', arguments: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: Helper.of(context).onWillPop,
        child: Scaffold(
            key: _con.scaffoldKey,
            backgroundColor: const Color(0xFFCCDFEE),
            resizeToAvoidBottomInset: false,
            body: Stack(alignment: AlignmentDirectional.topCenter, children: <
                Widget>[
              Center(
                  child: Stack(children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    child: Text(
                      S.of(context).yourRestaurantnanywhereYouAre,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: TextSize.TEXT1,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(
                        0, TextSize.ADD_PIC_HEIGHT, 0, TextSize.TEXT2),
                  ),
                ),
                Positioned(
                    top: config.App(context).appHeight(0),
                    bottom: config.App(context).appHeight(5),
                    left: config.App(context).appWidth(15),
                    right: config.App(context).appWidth(0),

//                                TextSize.TEXT, bottom: TextSize.TEXT1, left: TextSize.TEXT1, right: 0,

                    child: Container(
                      alignment: Alignment.center,
                      child: new Image(
                        image: new AssetImage(
                          "assets/img/login.png",
                        ),
                        height: TextSize.IMAGE_WIDTH,
                        width: TextSize.IMAGE_HEIGHT,
                      ),
                      padding: EdgeInsets.only(bottom: 10),
                    )),
                Positioned(
                    top: config.App(context).appHeight(44),
                    child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 0,
                        ),
                        padding: EdgeInsets.only(
                            top: TextSize.TEXT2,
                            right: 0,
                            left: TextSize.BUTTON_TEXT,
                            bottom: TextSize.TEXT),
                        width: config.App(context).appWidth(88),

//              height: config.App(context).appHeight(55),

                        child: Form(
                            key: _con.loginFormKey,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextFormField(

//                                                controller: emailController,

                                      keyboardType: TextInputType.emailAddress,
                                      onSaved: (input) =>
                                          _con.user.email = input,
                                      controller: _textEditingControllerEmail,
                                      style: TextStyle(color: Colors.white),
                                      validator: (input) => !input.contains('@')
                                          ? S
                                              .of(context)
                                              .should_be_a_valid_email
                                          : null,
                                      decoration: InputDecoration(
//                                               labelText: S.of(context).email,

                                        prefixIcon: new Icon(Icons.person),

                                        hintText: S.of(context).email,

                                        hintStyle: TextStyle(
                                            color: Colors.black45,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w500),

                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                      )),
                                  SizedBox(height: TextSize.SIZE),
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(color: Colors.white),
                                    onSaved: (input) =>
                                        _con.user.password = input,
                                    controller: _textEditingControllerPassword,
                                    validator: (input) => input.length < 3
                                        ? S
                                            .of(context)
                                            .should_be_more_than_3_characters
                                        : null,
                                    obscureText: _con.hidePassword,
                                    decoration: InputDecoration(
                                      prefixIcon: new Icon(Icons.lock),
                                      hintText: S.of(context).password,
                                      hintStyle: TextStyle(
                                        color: Colors.black45,
                                        fontFamily: 'Montserrat',
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ForgetPasswordWidget(),

//                                                      ResetPasswordWidget()
                                          ),
                                        );
                                      },
                                      child: new Text(
                                        S.of(context).forgotYourPassword,
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w500,
                                          fontSize: TextSize.FONT_SIZE3,
                                        ),
                                      ),
                                    ),
                                  ),
                                  new Container(
                                    // color:Colors.black,
                                    padding: EdgeInsets.only(
                                        top: TextSize.TEXT_PADDING2,
                                        left: TextSize.TEXT2),
                                    child: new Row(
                                      children: <Widget>[
                                        ButtonTheme(
                                          minWidth: 10,
                                          child: new RaisedButton(
                                            onPressed: () {
                                              initiateFacebookLogin();
                                            },
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(40.0),
                                                side: BorderSide(
                                                    color: Colors.white)),
                                            child: Row(
                                              children: <Widget>[
                                                new Image(
                                                  image: AssetImage(
                                                    'assets/img/facebook.png',
                                                  ),
                                                  color: null,
                                                ),
                                                Text(
                                                  S
                                                      .of(context)
                                                      .continue_with_facebook,
                                                  style: TextStyle(
                                                      fontSize: TextSize
                                                          .TEXT_PADDING1,
                                                      color: const Color(
                                                          0xFF736F83),
                                                      fontFamily:
                                                          'Montserrat-Regular'),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: TextSize.TEXT),
                                        _signInButton(),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: TextSize.TEXT_PADDING2),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        TextSize.DATE_HEIGHT,
                                        TextSize.TEXT_PADDING,
                                        TextSize.PADDING,
                                        TextSize.BUTTON),
                                    alignment: Alignment.center,
                                    child: RaisedButton(
                                      padding:
                                          EdgeInsets.fromLTRB(50, 5, 50, 5),
                                      color: const Color(0xFF6244E8),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                          side: BorderSide(
                                              color: Colors.deepPurpleAccent)),
                                      onPressed: () {
                                        _con.user.email =
                                            _textEditingControllerEmail.text;

                                        _con.user.password =
                                            _textEditingControllerPassword.text;

                                        _con.user.deviceToken =
                                            _textEditingControllerDeviceToken
                                                .text;

                                        getDeviceToken();
                                      },
                                      child: Text(
                                        S.of(context).login,
                                        style: TextStyle(
                                            fontSize: TextSize.BUTTON_TEXT,
                                            color: Colors.white,
                                            fontFamily: 'Montserrat'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 0),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        TextSize.DATE_HEIGHT,
                                        TextSize.TEXT_PADDING2,
                                        TextSize.PADDING_SIZE2,
                                        TextSize.PADDING),
                                    alignment: Alignment.center,
                                    child: Text(
                                      S.of(context).or_signup,
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Montserrat',
                                        fontSize: TextSize.TEXT,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: TextSize.TEXT_PADDING2),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                        TextSize.DATE_HEIGHT,
                                        TextSize.TEXT_PADDING2,
                                        TextSize.PADDING,
                                        TextSize.TEXT_PADDING),
                                    alignment: Alignment.bottomCenter,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpWidget(null),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          new Text(
                                            S.of(context).dont_have_an_account,
                                            style: TextStyle(
                                                color: Colors.black45,
                                                fontWeight: FontWeight.w500,
                                                fontSize: TextSize.TEXT,
                                                fontFamily: 'Montserrat'),
                                          ),
                                          new Text(
                                            S.of(context).signup,
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold,
                                                fontSize: TextSize.TEXT,
                                                fontFamily: 'Montserrat'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    padding: EdgeInsets.only(
                                        bottom: TextSize.TOP_PADDING),
                                  )
                                ]))))
              ]))
            ])));
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoggedIn = false;

  GlobalKey<ScaffoldState> scaffoldKey;

  GlobalKey<FormState> loginFormKey;

  OverlayEntry loader;

  ValueNotifier<User1.User> currentUser1 = new ValueNotifier(User1.User());

  void initiateFacebookLogin() async {
    loader = Helper.overlayLoader(context);

    loginFormKey = new GlobalKey<FormState>();

    this.scaffoldKey = new GlobalKey<ScaffoldState>();

    final facebookLogin = FacebookLogin();

    final facebookLoginResult =
        await facebookLogin.logIn(permissions: [FacebookPermission.email]);

    //(customPermissions: ['email']);

    //Overlay.of(context).insert(loader);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.Success:
        print("LoggedIn");

        Overlay.of(context).insert(loader);

        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${facebookLoginResult.accessToken.token}');

        var profile = jsonDecode(graphResponse.body);

        print(profile.toString());

        final credential = FacebookAuthProvider.credential(
            facebookLoginResult.accessToken.token);

        print("Access token is : $credential");

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);

        final User user = authResult.user;

        credential.providerId;

        credential.idToken;

        assert(!user.isAnonymous);

        assert(await user.getIdToken() != null);

        final User currentUser = await _auth.currentUser;

        assert(user.uid == currentUser.uid);

        if (user != null) {
          FirebaseMessaging _firebaseMessaging;

          _firebaseMessaging = FirebaseMessaging();

          _firebaseMessaging.getToken().then((String _deviceToken) async {
            print("Device token from shared pref : $_deviceToken");

            User1.User user = new User1.User();

            user.name = currentUser.displayName;

            user.socialId = currentUser.uid;

            user.email = currentUser.email;

            user.socialName = "Facebook";

            user.deviceToken = _deviceToken;

            setSocialId(user.socialId);

            setSocialName(user.socialName);

            print("DONE: fb login name ${user.name} email ${user.email}");

            SocialLogin socialLogin = await userRepo.socialLogin(user);

            if (socialLogin == null ||
                socialLogin.response == null ||
                socialLogin.response.apiToken == null) {
              loader.remove();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignUpWidget(user),
                ),
              );
            } else {
              user.apiToken = socialLogin.response.apiToken;

              SessionManager.setLoginCredentials(
                user.name,
                user.familyName,
                user.address,
                user.country,
                user.birthDate,
                user.countryCode,
                user.mobileNumber,
                user.email,
                user.password,
                user.deviceToken,
              );

              loader.remove();

              Navigator.of(context).pushNamed('/Pages', arguments: 0);
            }
          });
        }

        onLoginStatusChanged(true, profileData: profile);

        break;

      case FacebookLoginStatus.Cancel:
        print("CancelledByUser");

        onLoginStatusChanged(false);

        break;

      case FacebookLoginStatus.Error:
        print("Error" + FacebookLoginStatus.Error.toString());

        onLoginStatusChanged(false);

        break;
    }
  }

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    setState(() {
      this._isLoggedIn = isLoggedIn;
    });
  }

  Future<String> signInWithGoogle() async {
    loader = Helper.overlayLoader(context);

//    Overlay.of(context).insert(loader);

    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    Overlay.of(context).insert(loader);

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);

    final User user = authResult.user;

    assert(!user.isAnonymous);

    assert(await user.getIdToken() != null);

    final User currentUser = await _auth.currentUser;

    assert(user.uid == currentUser.uid);

//    Overlay.of(context).insert(loader);

    if (user != null) {
      FirebaseMessaging _firebaseMessaging;

      _firebaseMessaging = FirebaseMessaging();

      _firebaseMessaging.getToken().then((String _deviceToken) async {
        print("Device token from shared pref : $_deviceToken");

        User1.User user = new User1.User();

        user.name = currentUser.displayName;

        user.socialId = currentUser.uid;

        user.email = currentUser.email;

        user.socialName = "Google";

        user.deviceToken = _deviceToken;

        currentUser1.value = user;

        setSocialId(user.socialId);

        setSocialName(user.socialName);

        SocialLogin socialLogin = await userRepo.socialLogin(user);

        if (socialLogin == null ||
            socialLogin.response == null ||
            socialLogin.response.apiToken == null) {
          loader.remove();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignUpWidget(user),
            ),
          );
        } else {
          User1.User user = new User1.User();

          user.apiToken = socialLogin.response.apiToken;

          SessionManager.setLoginCredentials(
            user.name,
            user.familyName,
            user.address,
            user.country,
            user.birthDate,
            user.countryCode,
            user.mobileNumber,
            user.email,
            user.password,
            user.deviceToken,
          );

          loader.remove();

          Navigator.of(context).pushNamed('/Pages', arguments: 0);
        }
      });
    }

    print(user.email);

    print(user.uid);

    print(user.displayName);

    print(user.getIdToken().toString());

    print(user.refreshToken);

    return 'signInWithGoogle succeeded: $user';
  }

  void signOutGoogle() async {
    await _googleSignIn.signOut();

    print("User Sign Out");
  }

  Widget _signInButton() {
    return new RaisedButton(
      onPressed: () {
        signInWithGoogle().whenComplete(() {});
      },
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
          side: BorderSide(color: Colors.white)),
      child: Row(
        children: <Widget>[
          new Image(
            image: AssetImage('assets/img/google.png'),
          ),
          Text(
            S.of(context).continue_with_google,
            style: TextStyle(
                fontSize: TextSize.TEXT_PADDING1,
                color: const Color(0xFF736F83),
                fontFamily: 'Montserrat-Regular'),
          )
        ],
      ),
    );
  }

  getDeviceToken() async {
    User1.User user = User1.User();

    FirebaseMessaging _firebaseMessaging;

    _firebaseMessaging = FirebaseMessaging();

    _firebaseMessaging.getToken().then((String _deviceToken) {
      user.deviceToken = _deviceToken;

      print("Device token from shared pref : $_deviceToken");

      _con.login(_deviceToken);
    });
  }

  setSocialId(String socialId) {
    SessionManager.setSocialId(socialId);
  }

  setSocialName(String socialName) {
    SessionManager.setSocialName(socialName);
  }
}
