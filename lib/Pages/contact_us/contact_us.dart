import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:trust_app_updated/Components/button_widget/button_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trust_app_updated/Server/functions/functions.dart';
import '../../Components/search_dialog/search_dialog.dart';
import '../../Constants/constants.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  TextEditingController NameController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController MessageController = TextEditingController();
  openMap() async {
    String googleUrl = 'https://maps.app.goo.gl/EvGP5vzoYKy4qp828';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: MAIN_COLOR,
              centerTitle: true,
              title: Text(
                AppLocalizations.of(context)!.contact,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white)),
                    child: Center(
                      child: IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            showSearchDialog(context);
                          },
                          icon: Icon(
                            Icons.search_outlined,
                            color: Colors.white,
                            size: 15,
                          )),
                    ),
                  ),
                ),
              ],
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ))),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg-full.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFieldContactUs(
                      name: AppLocalizations.of(context)!.name_contact,
                      nameController: NameController),
                  TextFieldContactUs(
                      name: AppLocalizations.of(context)!.contact_email,
                      nameController: EmailController),
                  TextFieldContactUs(
                      name: AppLocalizations.of(context)!.message_contact,
                      nameController: MessageController),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ButtonWidget(
                        name: AppLocalizations.of(context)!.send,
                        height: 40,
                        width: 80,
                        BorderColor: MAIN_COLOR,
                        FontSize: 16,
                        OnClickFunction: () {
                          if (NameController.text.isEmpty ||
                              EmailController.text.isEmpty ||
                              MessageController.text.isEmpty) {
                            // Show error message or handle validation failure
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text(
                                    AppLocalizations.of(context)!.regempty,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  actions: [
                                    ButtonWidget(
                                        name: AppLocalizations.of(context)!.ok,
                                        height: 40,
                                        width: 80,
                                        BorderColor: MAIN_COLOR,
                                        FontSize: 16,
                                        OnClickFunction: () {
                                          Navigator.pop(context);
                                        },
                                        BorderRaduis: 10,
                                        ButtonColor: MAIN_COLOR,
                                        NameColor: Colors.white)
                                  ],
                                );
                              },
                            );
                          } else {
                            // Proceed with sending the contact information
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SpinKitFadingCircle(
                                          color: Colors.black,
                                          size: 40.0,
                                        ),
                                        Text(
                                          "Sending",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                            sendContact(
                              MessageController.text,
                              EmailController.text,
                              NameController.text,
                              context,
                            );
                          }
                        },
                        BorderRaduis: 20,
                        ButtonColor: MAIN_COLOR,
                        NameColor: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      AppLocalizations.of(context)!.address,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      AppLocalizations.of(context)!.address1,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      AppLocalizations.of(context)!.address2,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ButtonWidget(
                        name: AppLocalizations.of(context)!.show_on_map,
                        height: 40,
                        width: 140,
                        BorderColor: Colors.black,
                        FontSize: 16,
                        OnClickFunction: () {
                          openMap();
                        },
                        BorderRaduis: 4,
                        ButtonColor: Colors.black,
                        NameColor: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      AppLocalizations.of(context)!.contact,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${AppLocalizations.of(context)!.contact_phone} : ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("02 221 9800",
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.contact_fax} : ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("022220127",
                                    textDirection: TextDirection.ltr,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.contact_mobile} : ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("1700900300",
                                    textDirection: TextDirection.ltr,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.contact_email} : ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("Info@redtrust.ps",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget TextFieldContactUs(
      {String name = "", TextEditingController? nameController}) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15, top: 15),
      child: Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 243, 243, 243),
          borderRadius: BorderRadius.circular(4),
        ),
        child: TextField(
          controller: nameController,
          obscureText: false,
          decoration: InputDecoration(
            hintStyle:
                TextStyle(color: Color.fromARGB(255, 67, 67, 67), fontSize: 15),
            hintText: name,
          ),
        ),
      ),
    );
  }
}
