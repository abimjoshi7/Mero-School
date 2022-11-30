import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewAlertDialog extends StatelessWidget {
  Function(String?, String?, double, String?)? callBack;

  ReviewAlertDialog({this.callBack});

  TextStyle textStyle = TextStyle(color: Colors.black);
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? firstName;
  String? lastName;
  String? review = '';
  double rating = 5.0;
  bool isName = true;

  Future<SharedPreferences> getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
        future: getPref(),
        builder:
            (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
          firstName = snapshot.data?.getString(first_name);
          lastName = snapshot.data?.getString(last_name);

          if (firstName.toString().toUpperCase() == "USER" &&
              lastName.toString().toUpperCase() == "DEMO") {
            isName = true;
          } else if (firstName != null && lastName != null) {
            isName = false;
          }

          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: AlertDialog(
                  content: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Entypo.cross,
                          color: HexColor.fromHex(bottomNavigationIdealState),
                        )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: isName,
                          child: TextFormField(
                            onChanged: (value) {},
                            maxLines: 1,
                            minLines: 1,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("This field can't be empty");
                              }
                              return null;
                            },
                            onSaved: (String? value) {
                              firstName = value;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "First Name",

                              // labelStyle: TextStyle(
                              //     color: myFocusNode.hasFocus
                              //         ? HexColor.fromHex(bottomNavigationIdealState)
                              //         : HexColor.fromHex(colorAccent))
                            ),
                          ),
                        ),
                        Visibility(
                          visible: isName,
                          child: TextFormField(
                            onChanged: (value) {},
                            maxLines: 1,
                            minLines: 1,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("This field can't be empty");
                              }
                              return null;
                            },
                            onSaved: (String? value) {
                              lastName = value;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Last Name",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        RatingBar.builder(
                          initialRating: 5,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          unratedColor: Colors.amber.withAlpha(50),
                          itemCount: 5,
                          itemSize: 35.0,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rated) {
                            rating = rated;
                          },
                          updateOnDrag: true,
                        ),
                        TextFormField(
                          onChanged: (value) {},
                          maxLines: 5,
                          minLines: 1,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("This field can't be empty");
                            }
                            return null;
                          },
                          onSaved: (String? value) {
                            review = value;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Write your review here",
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState!.validate()) {
                                Navigator.pop(context);

                                _formKey.currentState!.save();
                                callBack!(firstName, lastName, rating, review);
                              }
                            },
                            child: Text("Submit")),
                      ],
                    )
                  ],
                ),
              )));
        });
  }
}
