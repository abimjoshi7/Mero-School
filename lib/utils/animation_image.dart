import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mero_school/presentation/constants/images.dart';

class AnimationImage extends StatefulWidget {
  String? path = logo_placeholder;
  String? bg = "";
  double? width = double.infinity;

  AnimationImage({Key? key, this.path, this.bg, this.width}) : super(key: key);

  @override
  _AnimationImageState createState() {
    return _AnimationImageState();
  }
}

class _AnimationImageState extends State<AnimationImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: true);
    _animation = Tween(begin: Offset.zero, end: Offset(0, 0.08))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget backgrond = Container();

    if (widget.bg != null && widget.bg!.isNotEmpty) {
      backgrond = Image.asset(
        widget.bg!,
        width: widget.width,
      );
    }

    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Align(
              child: backgrond,
              alignment: Alignment.center,
            ),
            Align(
              alignment: Alignment.center,
              child: SlideTransition(
                position: _animation,
                child: Image.asset(
                  widget.path!,
                  width: widget.width,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
