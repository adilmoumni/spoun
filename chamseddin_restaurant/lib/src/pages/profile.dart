import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/generated/l10n.dart';
import 'package:food_delivery_app/src/controllers/app_localization.dart';
import 'package:food_delivery_app/src/elements/CircularLoadingWidget.dart';
import 'package:food_delivery_app/src/elements/OrderListingWidget.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
import 'package:food_delivery_app/src/models/my_account_response.dart';
import 'package:food_delivery_app/src/models/user.dart';
import 'package:food_delivery_app/src/pages/customerService.dart';
import 'package:food_delivery_app/src/pages/myAccount.dart';
import 'package:food_delivery_app/src/pages/pages.dart';
import 'package:food_delivery_app/src/pages/payment_method.dart';
import 'package:food_delivery_app/src/pages/reset_user_password.dart';
import 'package:food_delivery_app/src/repository/user_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../main.dart';
import '../../session_manager.dart';
import '../TextSize.dart';
import '../constants.dart';
import '../controllers/profile_controller.dart';
import '../elements/PermissionDeniedWidget.dart';
import '../helpers/app_config.dart' as config;
import '../repository/user_repository.dart' as Repo;

class ProfileWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  MyAccountUser myAccountUser;
  MyAccountResponse myAccountResponse;
  PageBar pageBar;

  ProfileWidget({Key key, this.parentScaffoldKey, this.pageBar})
      : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends StateMVC<ProfileWidget> {
  ProfileController _con;
  File image;
  final picker = ImagePicker();
  int notificationsCount;
  User user;

  TextEditingController userImageController = TextEditingController();

  _ProfileWidgetState() : super(ProfileController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<bool> _onWillPop() async {
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return PagesWidget(
            currentTab: 0,
          );
        },
      ),
    );
    return true;
  }

  @override
  void didUpdateWidget(covariant ProfileWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    widget.myAccountUser = oldWidget.myAccountUser;
    print("===widget.myAccountUser==${widget.myAccountUser}");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          key: _con.scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PagesWidget(),
                ),
              ),
              icon:   Icon(Platform.isAndroid
                  ? Icons.arrow_back
                  : Icons.arrow_back_ios_sharp),

              color: Colors.black26,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: Repo.currentUser.value.apiToken == null
              ? PermissionDeniedWidget()
              : widget.myAccountUser == null
                  ? CircularLoadingWidget(
                      height: 50,
                    )
                  : SingleChildScrollView(
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 10, top: 10, bottom: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                  child: GestureDetector(
                                onTap: () {
                                  _showPicker(context);
                                },
                                child: CircleAvatar(
                                  radius: 65,
                                  backgroundColor: Colors.grey,
                                  child: ClipOval(
                                    child: image != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(70),
                                            child: Image.file(
                                              image,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.fill,
                                            ),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              shape: BoxShape.circle,
//                                                borderRadius:
//                                                    BorderRadius.circular(50)
                                            ),
                                            width: 120,
                                            height: 120,
                                            child: CachedNetworkImage(
                                              width: 100,
//                                              TextSize.SIZE_FIELD_WIDTH,
                                              height: 100,
//                                              TextSize.SIZE_FIELD_WIDTH,
                                              fit: BoxFit.fill,
                                              imageUrl: widget.myAccountUser
                                                          .image !=
                                                      null
                                                  ? widget.myAccountUser.image
                                                  : '',
                                              placeholder: (context, url) =>
                                                  CircularLoadingWidget(
                                                      height: 50),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      new Icon(Icons.error),
                                            )),
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          child: GridView.count(
                              crossAxisCount: 3,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              primary: false,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 20,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
//                                    final page = MyAccountWidget(user);
//                                    Navigator.push(
//                                      context,
//                                      MaterialPageRoute(
//                                        builder: (context) => page,
//                                      ),
//                                    );
                                    widget.pageBar.myAccount('myAccount');
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 20,
                                    margin: const EdgeInsets.only(
                                        left: 10, top: 0, bottom: 0),
                                    padding: const EdgeInsets.all(7.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                      shape: BoxShape.rectangle,
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Column(children: <Widget>[
                                      Container(
                                        child: InkWell(
                                          onTap: () {
//                                            final page = MyAccountWidget(user);
//                                            Navigator.push(
//                                              context,
//                                              MaterialPageRoute(
//                                                builder: (context) => page,
//                                              ),
//                                            );
                                            widget.pageBar
                                                .myAccount('myAccount');
                                          },
                                          child: IconButton(
                                            icon: new Image.asset(
                                              "assets/img/myAccount.png",
                                              color: const Color(0xFF6246E7),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(S.of(context).my_account,
                                          textAlign: TextAlign.center)
                                    ]),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
//                                    Navigator.push(
//                                      context,
//                                      MaterialPageRoute(
//                                        builder: (context) =>
//                                            PaymentMethodWidget(null),
//                                      ),
//                                    );
                                    widget.pageBar.payment('payment');
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    margin: const EdgeInsets.only(
                                        left: 0, top: 0, bottom: 0),
                                    padding: const EdgeInsets.all(7.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                    ),
                                    child: Column(children: <Widget>[
                                      Container(
                                        child: InkWell(
                                            onTap: () {
//                                              Navigator.push(
//                                                context,
//                                                MaterialPageRoute(
//                                                  builder: (context) =>
//                                                      PaymentMethodWidget(null),
//                                                ),
//                                              );
                                              widget.pageBar.payment('payment');
                                            },
                                            child: IconButton(
                                                icon: new Image.asset(
                                              "assets/img/paymentIcon.png",
                                              color: const Color(0xFF6246E7),
                                            ))),
                                      ),
                                      Text(S.of(context).payment_method,
                                          textAlign: TextAlign.center)
                                    ]),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
//                                    Navigator.push(
//                                      context,
//                                      MaterialPageRoute(
//                                        builder: (context) =>
//                                            ResetUserPasswordWidget(),
//                                      ),
//                                    );
                                    widget.pageBar
                                        .changePassword('resetPassword');
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    margin: const EdgeInsets.only(
                                        left: 0, top: 0, bottom: 0, right: 10),
                                    padding: const EdgeInsets.all(7.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                    ),
                                    child: Column(children: <Widget>[
                                      Container(
                                        child: InkWell(
                                            onTap: () {
//                                              Navigator.push(
//                                                context,
//                                                MaterialPageRoute(
//                                                  builder: (context) =>
//                                                      ResetUserPasswordWidget(),
//                                                ),
//                                              );
                                              widget.pageBar.changePassword(
                                                  'resetPassword');
                                            },
                                            child: IconButton(
                                                icon: new Image.asset(
                                              "assets/img/passwordIcon.png",
                                              color: const Color(0xFF6246E7),
                                            ))),
                                      ),
                                      Text(S.of(context).change_my_password,
                                          textAlign: TextAlign.center)
                                    ]),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
//                                    Navigator.push(
//                                      context,
//                                      MaterialPageRoute(
//                                        builder: (context) =>
//                                            OrderListingWidget(),
//                                      ),
//                                    );
                                    widget.pageBar.orderListing('orderListing');
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 20,
                                    margin: const EdgeInsets.only(
                                        left: 10, top: 0, bottom: 0, right: 0),
                                    padding: const EdgeInsets.all(7.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                    ),
                                    child: Column(children: <Widget>[
                                      Container(
                                        child: InkWell(
                                            onTap: () {
//                                              Navigator.push(
//                                                context,
//                                                MaterialPageRoute(
//                                                  builder: (context) =>
//                                                      OrderListingWidget(),
//                                                ),
//                                              );
                                              widget.pageBar
                                                  .orderListing('orderListing');
                                            },
                                            child: IconButton(
                                              icon: new Image.asset(
                                                "assets/img/qrCodeIcon.png",
                                              ),
                                              iconSize: 14,
                                            )),
                                      ),
                                      Text(
                                        S.of(context).my_orders,
                                        textAlign: TextAlign.center,
                                      ),
                                    ]),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
//                                    Navigator.push(
//                                      context,
//                                      MaterialPageRoute(
//                                        builder: (context) =>
//                                            CustomerServiceWidget(),
//                                      ),
//                                    );
                                    widget.pageBar
                                        .customerService('customerService');
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    margin: const EdgeInsets.only(
                                        left: 0, top: 0, bottom: 0),
                                    padding: const EdgeInsets.all(7.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                    ),
                                    child: Column(children: <Widget>[
                                      Container(
                                        child: InkWell(
                                            onTap: () {
//                                              Navigator.push(
//                                                context,
//                                                MaterialPageRoute(
//                                                  builder: (context) =>
//                                                      CustomerServiceWidget(),
//                                                ),
//                                              );
                                              widget.pageBar.customerService(
                                                  'customerService');
                                            },
                                            child: IconButton(
                                                icon: new Image.asset(
                                              "assets/img/serviceIcon.png",
                                              color: const Color(0xFF6246E7),
                                            ))),
                                      ),
                                      Text(S.of(context).customer_service,
                                          textAlign: TextAlign.center)
                                    ]),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
//                                    Navigator.of(context).pushNamed(
//                                        '/WebViewPage',
//                                        arguments: 'https://www.chamseddinweb.ni.iworklab.com');
                                    widget.pageBar.termsAndConditions(
                                        'termsAndConditions');
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    margin: const EdgeInsets.only(
                                        left: 0, top: 0, bottom: 0, right: 10),
                                    padding: const EdgeInsets.all(7.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                    ),
                                    child: Column(children: <Widget>[
                                      Container(
                                        child: InkWell(
                                            onTap: () {
                                              widget.pageBar.termsAndConditions(
                                                  'termsAndConditions');
//                                              Navigator.of(context).pushNamed(
//                                                  '/WebViewPage',
//                                                  arguments:
//                                                      'https://www.chamseddinweb.n1.iworklab.com');
                                              /*Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TermsAndConditonsWidget(),
                                          ),
                                        );*/
                                            },
                                            child: IconButton(
                                                icon: new Image.asset(
                                              "assets/img/termsIcon.png",
                                              color: const Color(0xFF6246E7),
                                            ))),
                                      ),
                                      Text(S.of(context).terms_and_conditions,
                                          textAlign: TextAlign.center)
                                    ]),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    widget.pageBar.help('help');
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    margin: const EdgeInsets.only(
                                        left: 10, top: 0, bottom: 0),
                                    padding: const EdgeInsets.all(7.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Column(children: <Widget>[
                                          Container(
                                            child: InkWell(
                                                onTap: () {
//                                                  Navigator.of(context).pushNamed(
//                                                      '/WebViewPage',
//                                                      arguments:
//                                                          'https://www.chamseddinweb.n1.iworklab.com');
                                                  widget.pageBar.help('help');
                                                },
                                                child: IconButton(
                                                    icon: new Image.asset(
                                                  "assets/img/helpIcon.png",
                                                  color:
                                                      const Color(0xFF6246E7),
                                                ))),
                                          ),
                                          Text(S.of(context).help,
                                              textAlign: TextAlign.center)
                                        ]),
                                      ],
                                    ),
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () {
                                    widget.pageBar.changeLanguage('change');
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    margin: const EdgeInsets.only(
                                        left: 10, top: 0, bottom: 0),
                                    padding: const EdgeInsets.all(7.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Column(children: <Widget>[
                                          Container(
                                            child: InkWell(
                                                onTap: () {
//                                                  Navigator.of(context).pushNamed(
//                                                      '/WebViewPage',
//                                                      arguments:
//                                                          'https://www.chamseddinweb.n1.iworklab.com');
                                                  widget.pageBar.changeLanguage('help');
                                                },
                                                child: IconButton(
                                                    icon: new Image.asset(
                                                      "assets/img/helpIcon.png",
                                                      color: const Color(0xFF6246E7),
                                                    ))),
                                          ),
                                          Text(S.of(context).change_language,
                                              textAlign: TextAlign.center)
                                        ]),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        Container(
                          width: config.App(context).appWidth(100),
                          margin: EdgeInsets.only(bottom: 40, top: 10),
                          alignment: Alignment.center,
                          child: RaisedButton(
                            padding: EdgeInsets.fromLTRB(50, 5, 50, 5),
                            color: const Color(0xFF6244E8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                                side:
                                    BorderSide(color: Colors.deepPurpleAccent)),
                            onPressed: () {
                              if (Repo.currentUser.value.apiToken != null) {
                                logout().then((value) {
                                  SessionManager.clearSession();
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/Login', (Route<dynamic> route) => false,
                                      arguments: 2);
                                });
                              } else {
                                Navigator.of(context).pushNamed('/Login');
                              }
                            },
                            child: Text(
                              S.of(context).log_out,
                              style: TextStyle(
                                  fontSize: TextSize.BUTTON_TEXT,
                                  color: Colors.white,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ]),
                    ),
        ));
  }

  void getUserProfile() {
    widget.myAccountUser == null;
    setState(() {});
    getUser().then((userResponse) {
//      this.widget.myAccountUser = userResponse.response.data.first;
      widget.myAccountUser = userResponse.response.data.first;
      setState(() {});
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    setState(() {
      image = image;
      updateUserImage(image);
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      image = image;
      print('image' + image.toString());
      updateUserImage(image);
    });
  }
}
