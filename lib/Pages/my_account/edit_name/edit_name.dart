import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trust_app_updated/Components/button_widget/button_widget.dart';
import 'package:trust_app_updated/Pages/wishlists/wishlists.dart';
import 'package:trust_app_updated/Server/functions/functions.dart';

import '../../../Components/bottom_bar_widget/bottom_bar_widget.dart';
import '../../../Components/loading_widget/loading_widget.dart';
import '../../../Constants/constants.dart';

class EditName extends StatefulWidget {
  const EditName({super.key});

  @override
  State<EditName> createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {
  @override
  int _currentIndex = 0;
  String USER_ID = "";
  setControllers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _userid = await prefs.getString('user_id') ?? "";
    String? user_name = await prefs.getString('name') ?? "";
    setState(() {
      USER_ID = _userid;
      NameController.text = user_name;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setControllers();
  }

  TextEditingController NameController = TextEditingController();
  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Scaffold(
          bottomNavigationBar: BottomBarWidget(currentIndex: _currentIndex),
          appBar: AppBar(
              backgroundColor: MAIN_COLOR,
              centerTitle: true,
              title: Text(
                AppLocalizations.of(context)!.profile,
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
                          onPressed: () {},
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
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 80,
                      width: double.infinity,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  "الأسم الكامل",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15, left: 15),
                            child: Form(
                              key: _formKey,
                              child: Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: TextFormField(
                                  validator: validatePhoneNumber,
                                  controller: NameController,
                                  obscureText: false,
                                  decoration: InputDecoration(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: ButtonWidget(
                          name: "Save",
                          height: 40,
                          width: 80,
                          BorderColor: MAIN_COLOR,
                          FontSize: 16,
                          OnClickFunction: () {
                            if (_formKey.currentState!.validate()) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return LoadingWidget(heightLoading: 50);
                                },
                              );
                              changeName(USER_ID, NameController.text, context);
                            }
                          },
                          BorderRaduis: 20,
                          ButtonColor: MAIN_COLOR,
                          NameColor: Colors.white),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }

    return null; // Return null if the input is valid
  }

  Widget ContainerWidgetMyAccount(
      {IconData? AccountIcon,
      String FirstName = "",
      String LastName = "",
      required Widget myWidget}) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: InkWell(
        onTap: () {
          NavigatorFunction(context, myWidget);
        },
        child: Container(
          width: double.infinity,
          height: 50,
          color: Color.fromARGB(255, 241, 241, 241),
          child: Row(
            children: [
              SizedBox(
                width: 15,
              ),
              Icon(
                AccountIcon,
                color: Colors.black,
              ),
              SizedBox(
                width: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      FirstName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      LastName,
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
