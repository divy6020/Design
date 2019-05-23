import 'dart:async';

import 'package:design/pager_indicator.dart';
import 'package:flutter/material.dart';

class PageDragger extends StatefulWidget {

  final StreamController<SlideUpdate> slideUpdateStream;
  PageDragger({this.slideUpdateStream});

  _PageDraggerState createState() => _PageDraggerState();
}

class _PageDraggerState extends State<PageDragger> {

  static const FULL_TRANSITION = 300.0;
  Offset dragStart;
  SlideDirection slideDirection;
  double slidePercent = 0.0;

  onDragStart(DragStartDetails details){
    dragStart = details.globalPosition;
  }
  onDragUpdate(DragUpdateDetails details){
    if(dragStart != null){
    final newPosition = details.globalPosition;
    final dx = dragStart.dx - newPosition.dx;
    if(dx > 0.0)
    {
      slideDirection = SlideDirection.rightToLeft;
    }
    else if(dx < 0.0)
    {
      slideDirection = SlideDirection.leftToRight;
    }
    else{
      slideDirection = SlideDirection.none;
    }

    slidePercent = (dx / FULL_TRANSITION).abs().clamp(0.0, 1.0);
    print('Dragging $slideDirection at $slidePercent');

    widget.slideUpdateStream.add(new SlideUpdate(UpdateType.dragging,slidePercent, slideDirection));
  }
    }
  onDragEnd(DragEndDetails details){
    widget.slideUpdateStream.add(new SlideUpdate(UpdateType.donedragging,0.0,SlideDirection.none));
  }



  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onHorizontalDragStart: onDragStart,
      onHorizontalDragUpdate: onDragUpdate,
      onHorizontalDragEnd: onDragEnd,
    );
  }
}
enum UpdateType{
  dragging,
  donedragging,
}

class SlideUpdate{
  final update;
  final direction;
  final slidePercent;

  SlideUpdate(this.update,this.slidePercent,this.direction);
}