import 'package:entrance/bloc/play_bloc.dart';
import 'package:entrance/main.dart';
import 'package:entrance/ui/widgets/qsn_answer_widget.dart';
import 'package:entrance/ui/widgets/timmer_widget.dart';
import 'package:flutter/material.dart';

class EntrancePlayPage extends StatefulWidget {
  const EntrancePlayPage({Key? key}) : super(key: key);

  @override
  _EntrancePlayPageState createState() => _EntrancePlayPageState();
}

class _EntrancePlayPageState extends State<EntrancePlayPage>
    with SingleTickerProviderStateMixin {
  PageController? _pageController;
  late PlayBloc _playBloc;
  int total = 10;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _playBloc = PlayBloc();
    super.initState();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.close_outlined, color: Colors.grey),
                    onPressed: () => onBackPressed(),
                  ),
                  TimmerWidget(
                    time: 540,
                    isPlaying: true,
                    onTimerDone: () {
                      //
                      // // playBloc.pause();
                      //
                      // _playNotifier.value = false;
                      //
                      // playBloc.submit(topic);
                    },
                  ),
                ],
              ),
              Expanded(
                  child: Container(
                color: Colors.redAccent.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PageView.builder(
                    itemCount: total,
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemBuilder: (context, index) {
                      return SingleChildScrollView(
                        child: Container(
                            // child: Column(
                            //   mainAxisSize: MainAxisSize.max,
                            //   children: [
                            //
                            //     Text("Hello: Index $index")
                            //   ],
                            // ),

                            child: QuestionAnswerWidget(
                          index: index,
                          playBloc: _playBloc,
                        )),
                      );
                    },
                  ),
                ),
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      label: Text(
                        "BACK",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _pageController?.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_outlined,
                        color: Colors.white,
                      ),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0)),
                          backgroundColor:
                              MaterialStateProperty.all(primaryColor)),
                    ),
                    StreamBuilder<int>(
                        stream: _playBloc.positionController.stream,
                        initialData: 0,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var pageNumber = snapshot.data;
                            pageNumber = pageNumber! + 1;

                            return Text("$pageNumber/$total");
                          }

                          return SizedBox();
                        }),
                    TextButton.icon(
                      icon: Text(
                        "NEXT",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _pageController?.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      },
                      label: Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.white,
                      ),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0)),
                          backgroundColor:
                              MaterialStateProperty.all(primaryColor)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  var isPlaying = true;

  void onBackPressed() {
    print("isPlaying $isPlaying");

    if (isPlaying) {
      // ConfirmationDialog confirmationDialog = ConfirmationDialog("Are you sure ?",
      //     "You won't be able to continue this quiz.","Exit", (){
      //
      //       playBloc.submit(topic);
      //
      //
      //       //auto submit result
      //       Navigator.of(context).pop();
      //
      //
      //
      //     });
      //
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return confirmationDialog;
      //   },
      // );

    } else {
      Navigator.of(context).pop();
    }
  }

  void _onPageChanged(int value) {
    _playBloc.positionController.sink.add(value);
  }
}
