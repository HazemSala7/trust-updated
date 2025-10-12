import 'package:flutter/material.dart';
import 'package:trust_app_updated/l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trust_app_updated/Components/button_widget/button_widget.dart';
import 'package:trust_app_updated/Constants/constants.dart';
import 'package:trust_app_updated/Pages/authentication/login_screen/login_screen.dart';
import 'package:trust_app_updated/Server/functions/functions.dart';

import '../../../Components/loading_widget/loading_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  TextEditingController NameController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController AddrsssController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  TextEditingController RePasswordController = TextEditingController();
  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/bg.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 130,
                          width: double.infinity,
                          child: Center(
                            child: Image.asset(
                              'assets/images/icon.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          AppLocalizations.of(context)!.login,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 50, left: 50),
                          child: Container(
                            height: 335,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromRGBO(0, 0, 0, 0.7),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Color(0xffF15024),
                                        size: 35,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        height: 40,
                                        width: 220,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: TextField(
                                          controller: NameController,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 67, 67, 67),
                                                fontSize: 15),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              borderSide: BorderSide(
                                                  color: MAIN_COLOR,
                                                  width: 2.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              borderSide: BorderSide(
                                                  width: 2.0,
                                                  color: Color(0xffD6D3D3)),
                                            ),
                                            hintText: "الأسم الكامل",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 12, left: 12),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.email,
                                        color: Color(0xffF15024),
                                        size: 35,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        height: 40,
                                        width: 220,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: TextField(
                                          controller: EmailController,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 67, 67, 67),
                                                fontSize: 15),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              borderSide: BorderSide(
                                                  color: MAIN_COLOR,
                                                  width: 2.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              borderSide: BorderSide(
                                                  width: 2.0,
                                                  color: Color(0xffD6D3D3)),
                                            ),
                                            hintText: "البريد الالكتروني",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 12),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.password_sharp,
                                        color: MAIN_COLOR,
                                        size: 35,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        height: 40,
                                        width: 220,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: TextField(
                                          controller: PasswordController,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 67, 67, 67),
                                                fontSize: 15),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              borderSide: BorderSide(
                                                  color: MAIN_COLOR,
                                                  width: 2.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              borderSide: BorderSide(
                                                  width: 2.0,
                                                  color: Color(0xffD6D3D3)),
                                            ),
                                            hintText: "كلمه المرور",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 12),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.password_sharp,
                                        color: MAIN_COLOR,
                                        size: 35,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        height: 40,
                                        width: 220,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: TextField(
                                          controller: PasswordController,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 67, 67, 67),
                                                fontSize: 15),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              borderSide: BorderSide(
                                                  color: MAIN_COLOR,
                                                  width: 2.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              borderSide: BorderSide(
                                                  width: 2.0,
                                                  color: Color(0xffD6D3D3)),
                                            ),
                                            hintText: "تأكيد كلمه المرور",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 12),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.home,
                                        color: MAIN_COLOR,
                                        size: 35,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        height: 40,
                                        width: 220,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: TextField(
                                          controller: AddrsssController,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 67, 67, 67),
                                                fontSize: 15),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              borderSide: BorderSide(
                                                  color: MAIN_COLOR,
                                                  width: 2.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              borderSide: BorderSide(
                                                  width: 2.0,
                                                  color: Color(0xffD6D3D3)),
                                            ),
                                            hintText: "العنوان",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12, top: 25),
                                    child: ButtonWidget(
                                        name:
                                            AppLocalizations.of(context)!.login,
                                        FontSize: 18,
                                        height: 45.0,
                                        width: double.infinity,
                                        BorderColor: MAIN_COLOR,
                                        OnClickFunction: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: SizedBox(
                                                  height: 60,
                                                  width: 60,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      SpinKitFadingCircle(
                                                        color: Colors.black,
                                                        size: 40.0,
                                                      ),
                                                      Text(
                                                        "Loggin you in",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                          sendLoginRequest(EmailController.text,
                                              PasswordController.text, context);
                                        },
                                        BorderRaduis: 20,
                                        ButtonColor: MAIN_COLOR,
                                        NameColor: Colors.white)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    color: const Color.fromRGBO(0, 0, 0, 0.7),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          AppLocalizations.of(context)!.doyouhaveaccount,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ButtonWidget(
                            name: AppLocalizations.of(context)!.login,
                            FontSize: 13,
                            height: 35.0,
                            width: 150,
                            BorderColor: Colors.white,
                            OnClickFunction: () {
                              NavigatorFunction(context, LoginScreen());
                            },
                            BorderRaduis: 40,
                            ButtonColor: Colors.white,
                            NameColor: MAIN_COLOR),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
