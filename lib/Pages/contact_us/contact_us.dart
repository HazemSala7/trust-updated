import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:trust_app_updated/Components/button_widget/button_widget.dart';
import 'package:trust_app_updated/l10n/app_localizations.dart';
import 'package:trust_app_updated/Server/functions/functions.dart';
import '../../Components/search_dialog/search_dialog.dart';
import '../../Constants/constants.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  // Controllers
  final TextEditingController NameController = TextEditingController();
  final TextEditingController EmailController = TextEditingController();
  final TextEditingController MessageController = TextEditingController();

  // NEW: simple email validator
  bool _isValidEmail(String email) {
    final reg = RegExp(
      r'^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$',
      caseSensitive: false,
    );
    return reg.hasMatch(email.trim());
  }

  openMap() async {
    String googleUrl = 'https://maps.app.goo.gl/EvGP5vzoYKy4qp828';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
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
                style: const TextStyle(
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
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            showSearchDialog(context);
                          },
                          icon: const Icon(
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
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ))),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/BackGround.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFieldContactUs(
                    name: AppLocalizations.of(context)!.name_contact,
                    nameController: NameController,
                  ),
                  TextFieldContactUs(
                    name: AppLocalizations.of(context)!.contact_email,
                    nameController: EmailController,
                    isEmail: true, // NEW: email keyboard + hint
                  ),
                  TextFieldContactUs(
                    name: AppLocalizations.of(context)!.message_contact,
                    nameController: MessageController,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ButtonWidget(
                        name: AppLocalizations.of(context)!.send,
                        height: 40,
                        width: 80,
                        BorderColor: MAIN_COLOR,
                        FontSize: 16,
                        OnClickFunction: () {
                          // trim once
                          final name = NameController.text.trim();
                          final email = EmailController.text.trim();
                          final message = MessageController.text.trim();

                          if (name.isEmpty ||
                              email.isEmpty ||
                              message.isEmpty) {
                            // Show "empty" error
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text(
                                    AppLocalizations.of(context)!.regempty,
                                    style: const TextStyle(
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
                                      NameColor: Colors.white,
                                    )
                                  ],
                                );
                              },
                            );
                            return;
                          }

                          // NEW: email format validation
                          if (!_isValidEmail(email)) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text(
                                    AppLocalizations.of(context)!.invalid_email,
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
                                      NameColor: Colors.white,
                                    )
                                  ],
                                );
                              },
                            );
                            return;
                          }

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
                                    children: const [
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
                            message,
                            email,
                            name,
                            context,
                          );
                        },
                        BorderRaduis: 20,
                        ButtonColor: MAIN_COLOR,
                        NameColor: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      AppLocalizations.of(context)!.address,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      AppLocalizations.of(context)!.address1,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      AppLocalizations.of(context)!.address2,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ButtonWidget(
                        name: AppLocalizations.of(context)!.show_on_map,
                        height: 40,
                        width: 180,
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
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22),
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
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text("02 221 9800",
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
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text("022220127",
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
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text("1700900300",
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
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text("Info@redtrust.ps",
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

  // Updated to allow email keyboard when needed
  Widget TextFieldContactUs({
    String name = "",
    TextEditingController? nameController,
    bool isEmail = false, // NEW
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15, top: 15),
      child: Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 243, 243, 243),
          borderRadius: BorderRadius.circular(4),
        ),
        child: TextField(
          controller: nameController,
          obscureText: false,
          keyboardType:
              isEmail ? TextInputType.emailAddress : TextInputType.text, // NEW
          textInputAction: TextInputAction.next, // NEW: nicer UX
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            border: InputBorder.none,
            hintStyle: const TextStyle(
                color: Color.fromARGB(255, 67, 67, 67), fontSize: 15),
            hintText: name,
          ),
        ),
      ),
    );
  }
}
