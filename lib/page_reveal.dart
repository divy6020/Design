import 'dart:math';

import 'package:flutter/material.dart';

class PageReveal extends StatelessWidget {
  final double revealPercent;
  final Widget child;

  PageReveal({
    this.child,
    this.revealPercent,
  });

  @override
  Widget build(BuildContext context) {
    return new ClipOval(
      clipper: new CircleRevealClipper(revealPercent),
      child: child,
    );
  }
}

class CircleRevealClipper extends CustomClipper<Rect> {
  final double revealPercent;

  CircleRevealClipper(this.revealPercent);
  @override
  Rect getClip(Size size) {
  final epicenter = new Offset(size.width / 2, size.height * 0.9); //where the circle begins

  //calculate the distance from the eppicenter to the corner
  double theta = atan(epicenter.dy / epicenter.dx);
  final distancetocorner = epicenter.dy / sin(theta);

  final radius = distancetocorner * revealPercent ;
  final diameter = radius * 2 ;
    
    return new Rect.fromLTWH(epicenter.dx - radius , epicenter.dy - radius, diameter, diameter);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
