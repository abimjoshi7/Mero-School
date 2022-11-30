import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../../utils/extension_utils.dart';
import '../constants/colors.dart';
import '../constants/images.dart';

class FeedbackForm extends StatefulWidget {
  FeedbackForm({Key? key}) : super(key: key);

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> items = ["Like", "Question", "Suggestion", "Problem"];
  String? selectedValue;
  bool isTrue = false;
  // bool isloading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: HexColor.fromHex(bottomNavigationEnabledState)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Image.asset(
          logo_no_text,
          height: 38,
          width: 38,
        ),
        actions: [
          // TextButton(
          //     onPressed: () async {
          //       if (fetchToken == null) {
          //         print(1);
          //       } else {
          //         print(2);
          //       }
          //       print("token:$fetchToken");
          //       postAffiliateForm();
          //     },
          //     child: Text("test")),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 250,
                    width: 400,
                    child: Image.asset(
                      "assets/5385893.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration:
                        CustomInputDecoration.editProfileInputDecoration(
                            "Name", FontAwesome.user),
                    onSaved: (String? value) {
                      var name = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration:
                        CustomInputDecoration.editProfileInputDecoration(
                            "Email", FontAwesome.at),
                    onSaved: (String? value) {
                      var email = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField<String>(
                      // hint: Text("Category"),
                      decoration:
                          CustomInputDecoration.editProfileInputDecoration(
                              "Category", FontAwesome.list),
                      // value: items[0],
                      items: items
                          .map(
                            (e) => DropdownMenuItem<String>(
                              child: Text(e),
                              value: e,
                            ),
                          )
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue;
                        });
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    maxLines: 3,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration:
                        CustomInputDecoration.editProfileInputDecoration(
                            "Enrolled Courses", FontAwesome.book),
                    onSaved: (String? value) {
                      var courses = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    maxLines: 3,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration:
                        CustomInputDecoration.editProfileInputDecoration(
                            "Message", FontAwesome.sticky_note),
                    onSaved: (String? value) {
                      var message = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  // Row(
                  //   children: [
                  //     Checkbox(
                  //         value: isTrue,
                  //         onChanged: (value) {
                  //           setState(() {
                  //             isTrue = value!;
                  //           });
                  //         }),
                  //     Flexible(
                  //       child: Text(
                  //         'Click to automatically attach a screenshot of this page',
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Container(
                    child: _submitButton(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: HexColor.fromHex(colorBlue),
      ),
      child: Text(
        "Submit",
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
        }
      },
    );
  }
}
