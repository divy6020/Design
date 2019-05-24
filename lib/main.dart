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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  StreamController<SlideUpdate> slideUpdateStream;
  AnimatedPageDragger animatedPageDragger;

  int activeIndex = 0;
  int nextPageIndex = 0;
  SlideDirection slideDirection = SlideDirection.none;
  double slidePercent = 0.0;

  _MyHomePageState(){
  slideUpdateStream = new StreamController<SlideUpdate>();

  slideUpdateStream.stream.listen((SlideUpdate event)
    {
      setState(() {
        if(event.update == UpdateType.dragging ){
        slideDirection  = event.direction;
        slidePercent = event.slidePercent;

        if(slideDirection == SlideDirection.leftToRight){
          nextPageIndex = activeIndex - 1;
        }
        else if (slideDirection == SlideDirection.rightToLeft){
           nextPageIndex = activeIndex + 1;
        }
        else{
          nextPageIndex = activeIndex;
        }

        // nextPageIndex = slideDirection == SlideDirection.leftToRight
        //                   ? activeIndex - 1
        //                   : activeIndex + 1;
        nextPageIndex.clamp(0.0, pages.length - 1);
        }
        else if(event.update == UpdateType.donedragging)
        {

          if(slidePercent > 0.3)
          {
          animatedPageDragger  = new AnimatedPageDragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.open,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
          );
          }
          else
          {
              animatedPageDragger  = new AnimatedPageDragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.close,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
          );

          nextPageIndex = activeIndex;
          }

          animatedPageDragger.run();
        }
        else if(event.update  == UpdateType.animating){
           slideDirection  = event.direction;
        slidePercent = event.slidePercent;
        }
        else if(event.update  == UpdateType.doneAnimating){
            activeIndex = nextPageIndex;

            slideDirection = SlideDirection.none;
            slidePercent = 0.0;

            animatedPageDragger.dispose();
          
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
              canDragltor: activeIndex > 0,
              canDragrtol: activeIndex < pages.length - 1,
              slideUpdateStream: this.slideUpdateStream,
            ),
          ],
        ),
      );
    }
  }
