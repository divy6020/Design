import 'dart:async';
import 'dart:ui';

import 'package:design/pager_indicator.dart';
import 'package:flutter/material.dart';

class PageDragger extends StatefulWidget {
  final bool canDragltor;
  final bool canDragrtol;

  final StreamController<SlideUpdate> slideUpdateStream;
  PageDragger({this.slideUpdateStream, this.canDragltor, this.canDragrtol});

  _PageDraggerState createState() => _PageDraggerState();
}

class _PageDraggerState extends State<PageDragger> {
  static const FULL_TRANSITION = 200.0;
  Offset dragStart;
  SlideDirection slideDirection;
  double slidePercent = 0.0;

  onDragStart(DragStartDetails details) {
    dragStart = details.globalPosition;
  }

  onDragUpdate(DragUpdateDetails details) {
    if (dragStart != null) {
      final newPosition = details.globalPosition;
      final dx = dragStart.dx - newPosition.dx;
      if (dx > 0.0 && widget.canDragrtol) {
        slideDirection = SlideDirection.rightToLeft;
      } else if (dx < 0.0 && widget.canDragltor) {
        slideDirection = SlideDirection.leftToRight;
      } else {
        slideDirection = SlideDirection.none;
      }

      if (slideDirection != SlideDirection.none) {
        slidePercent = (dx / FULL_TRANSITION).abs().clamp(0.0, 1.0);
        print('Dragging $slideDirection at $slidePercent');
      } else {
        slidePercent = 0.0;
      }
      widget.slideUpdateStream.add(
          new SlideUpdate(UpdateType.dragging, slidePercent, slideDirection));
    }
  }

  onDragEnd(DragEndDetails details) {
    widget.slideUpdateStream.add(
        new SlideUpdate(UpdateType.donedragging, 0.0, SlideDirection.none));
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

class AnimatedPageDragger {
  static const PERCENT_PER_MILLISECOND = 0.005;

  final slideDirection;
  final transitionGoal;

  AnimationController completeAnimationController;

  AnimatedPageDragger({
    this.slideDirection,
    this.transitionGoal,
    slidePercent,
    StreamController<SlideUpdate> slideUpdateStream,
    TickerProvider vsync,
  }) {
    final startSlidePercent = slidePercent;
    var endSlidePercent;
    var duration;

    if (transitionGoal == TransitionGoal.open) {
      endSlidePercent = 1.0;
      final slideRemaining = 1.0 - slidePercent;
      duration = new Duration(
          milliseconds: (slideRemaining / PERCENT_PER_MILLISECOND).round());
    } else {
      endSlidePercent = 0.0;
      duration = new Duration(
          milliseconds: (slidePercent / PERCENT_PER_MILLISECOND).round());
    }

    completeAnimationController = new AnimationController(
      duration: duration,
      vsync: vsync,
    )
      ..addListener(() {
        final slidePercent = lerpDouble(startSlidePercent, endSlidePercent,
            completeAnimationController.value);

        slideUpdateStream.add(new SlideUpdate(
            UpdateType.animating, slidePercent, slideDirection));
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          slideUpdateStream.add(SlideUpdate(
              UpdateType.doneAnimating, endSlidePercent, slideDirection));
        }
      });
  }

  run(){
    completeAnimationController.forward(from: 0.0);

  }

  dispose(){
    completeAnimationController.dispose();
  }

}

enum TransitionGoal {
  open,
  close,
}

enum UpdateType {
  dragging,
  donedragging,
  animating,
  doneAnimating,
}

class SlideUpdate {
  final update;
  final direction;
  final slidePercent;

  SlideUpdate(this.update, this.slidePercent, this.direction);
}
