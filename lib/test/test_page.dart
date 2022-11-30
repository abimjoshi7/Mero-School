import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  TestPage() : super();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

void main() {
  BlocOverrides.runZoned(
    () {},
    blocObserver: TestObserver(),
  );
}

class TestObserver extends BlocObserver {}

/*

 */
