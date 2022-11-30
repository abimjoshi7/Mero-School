import 'package:flutter/material.dart';
import 'package:mero_school/app_database.dart';
import 'package:mero_school/business_login/blocs/notification_bloc.dart';
import 'package:mero_school/presentation/constants/colors.dart';
import 'package:mero_school/presentation/constants/images.dart';
import 'package:mero_school/presentation/constants/route.dart';
import 'package:mero_school/presentation/constants/strings.dart';
import 'package:mero_school/presentation/widgets/custom_notification_alert_dialog.dart';
import 'package:mero_school/presentation/widgets/error.dart';
import 'package:mero_school/presentation/widgets/loading/loading.dart';
import 'package:mero_school/quiz/widget/confirmation_alert_dialog.dart';
import 'package:mero_school/utils/extension_utils.dart';
import 'package:mero_school/utils/image_error.dart';
import 'package:mero_school/webengage/tags.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late NotificationBloc notificationBloc;

  @override
  void initState() {
    notificationBloc = NotificationBloc();
    // notificationBloc.setReadAllNotification();
    super.initState();

    WebEngagePlugin.trackScreen(TAG_PAGE_NOTIFICATION);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: HexColor.fromHex(bottomNavigationEnabledState)),
          onPressed: () => Navigator.pushReplacementNamed(context, home_page),
        ),
        title: Image.asset(
          logo_no_text,
          height: 38,
          width: 38,
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.delete_sweep_outlined,
                  color: HexColor.fromHex(bottomNavigationEnabledState)),
              onPressed: () {
                ConfirmationDialog confirmationDialog = ConfirmationDialog(
                    "Mero School ",
                    "Are you sure to delete all notifications?",
                    "Delete All", () {
                  //auto submit resule
                  //delete and observe change
                  notificationBloc.deleteAllNotifications();
                });

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return confirmationDialog;
                  },
                );
              })
        ],
      ),
      body: StreamBuilder<List<NotificationModelData>>(
          stream: notificationBloc.unallMessage,
          builder: (BuildContext context,
              AsyncSnapshot<List<NotificationModelData>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Loading(loadingMessage: "loading");

              default:
                if (snapshot.hasError)
                  return Error(
                    errorMessage: "${snapshot.error}",
                    isDisplayButton: false,
                    onRetryPressed: () =>
                        notificationBloc.getNotificationData(),
                  );
                else if (snapshot.data!.length == 0) {
                  return Error(
                    errorMessage: "No new Notifications",
                    isDisplayButton: false,
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return singleItemCard(snapshot.data![index]);
                        }),
                  );
                }
            }
          }),
    );
  }

  Widget singleItemCard(NotificationModelData model) {
    return GestureDetector(
      onTap: () {
        notificationBloc.setRead(model);

        if (model.type == "course") {
          Navigator.pushNamed(context, course_details,
              arguments: <String, String?>{
                'course_id': model.courseId,
                'thumbnail': model.icon
              });
        } else if (model.type == "plan") {
          Navigator.pushNamed(context, plans_details_page,
              arguments: <String, String?>{'plan_id': model.courseId});
        } else if (model.type.toLowerCase() == "allplan") {
          Navigator.pushNamed(context, all_plans,
              arguments: <String, String?>{'id': model.courseId});
        } else if (model.type.toLowerCase() == "allcourse") {
          Navigator.pushNamed(context, all_course,
              arguments: <String, String?>{'course_id': model.courseId});
        } else if (model.type.toLowerCase() == "web") {
          Navigator.of(context).pushNamedAndRemoveUntil(
              web_page, (route) => false,
              arguments: <String, String>{'paymentUrl': "${model.courseId}"});
          // Navigator.pushNamed(context, web_page,
          //     arguments: <String, String>{'paymentUrl': "${model.courseId}"});
        } else if (model.type.toLowerCase() == "quiz") {
          Navigator.of(context).pushNamed(web_page_entrance);
        } else if (model.type.toLowerCase() == "wishlist") {
          Navigator.of(context).pushNamed(route_wish_list);
        } else if (model.type.toLowerCase() == "carts") {
          Navigator.of(context).pushNamed(my_carts);
        }

        //else if(path.toLowerCase().contains("wishlist")){
        //           Navigator.of(navigatorKey.currentState!.overlay!.context).pushNamed(route_wish_list);
        //         }else if(path.toLowerCase().contains("carts")){
        //           Navigator.of(navigatorKey.currentState!.overlay!.context).pushNamed(my_carts);
        //         }

        else {
          //display dialog

          var dialog = CustomNotificationAlertDialog(
              model.title, model.notifyTime, model.description, model.icon);

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return dialog;
            },
          );
        }
      },
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ClipOval(
                        child: FadeInImage.assetNetwork(
                      placeholder: logo,
                      image: model.icon != empty
                          ? model.icon
                          : logo,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (_, __, ___) {
                        return ImageErrorLogo();
                      },
                    )),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    model.title,
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      ConfirmationDialog confirmationDialog =
                                          ConfirmationDialog(
                                              "Mero School ",
                                              "Are you sure delete?.",
                                              "Delete", () {
                                        //auto submit resule
                                        //delete and observe change
                                        notificationBloc
                                            .deleteSingleNotification(model);
                                        // notificationBloc.getNotificationData();
                                      });

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return confirmationDialog;
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.black26,
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              model.description.trim(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .apply(color: Colors.black87),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  model.notifyTime,
                                  style: TextStyle(color: Colors.black87),
                                )),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
