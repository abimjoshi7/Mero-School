import 'package:entrance/ui/widgets/CountWidget.dart';
import 'package:flutter/material.dart';

class SyllabusWidget extends StatelessWidget {
  const SyllabusWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.greenAccent.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CountWidget(
                    iconData: Icons.people_alt,
                    title: "Users".toUpperCase(),
                    count: 13,
                  ),
                  CountWidget(
                    iconData: Icons.question_answer,
                    title: "Questions".toUpperCase(),
                    count: 132,
                  ),
                  CountWidget(
                    iconData: Icons.book,
                    title: "Courses".toUpperCase(),
                    count: 51,
                  ),
                ],
              ),
              Divider(color: Colors.grey),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
                    style: TextStyle(),
                    textAlign: TextAlign.justify,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
