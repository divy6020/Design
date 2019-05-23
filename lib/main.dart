import 'dart:async';

import 'package:design/page_dragger.dart';
import 'package:design/page_reveal.dart';
import 'package:design/pager_indicator.dart';
import 'package:flutter/material.dart';
import 'package:design/pages.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Baller',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  StreamController<SlideUpdate> slideUpdateStream;

  int activeIndex = 0;
  int nextPageIndex = 0;
  SlideDirection slideDirection = SlideDirection.none;
  double slidePercent = 0.0;

  _MyHomePageState(){
  slideUpdateStream = new StreamController<SlideUpdate>();

  slideUpdateStream.stream.listen((SlideUpdate event)
    {
      setState(() {
        if(event.update == UpdateType.dragging){
        slideDirection  = event.direction;
        slidePercent = event.slidePercent;

        nextPageIndex = slideDirection == SlideDirection.leftToRight
                          ? activeIndex - 1
                          : activeIndex + 1;
        nextPageIndex.clamp(0.0, pages.length ); //-1
        }
        else if(event.update == UpdateType.donedragging)
        {

          if(slidePercent > 0.5)
          {
            activeIndex = slideDirection == SlideDirection.leftToRight
                          ? activeIndex - 1
                          : activeIndex + 1;
          }

          slideDirection = SlideDirection.none;
          slidePercent = 0.0;
        }
      });
    });
    }
  
    @override
    Widget build(BuildContext context) {
      return new Scaffold(
        body: new Stack(
          children: [
            new Page(
              viewModel: pages[activeIndex],
              percentVisible: 1.0,
            ),
            new PageReveal(
              revealPercent: slidePercent,
              child: new Page(
                viewModel: pages[nextPageIndex],
                percentVisible: slidePercent,
              ),
            ),
            new PagerIndicator(
              viewModel:
                  new PageIndicatorViewModel(activeIndex, pages, slideDirection, slidePercent),
            ),
            new PageDragger(
              slideUpdateStream: this.slideUpdateStream,
            ),
          ],
        ),
      );
    }
  }
