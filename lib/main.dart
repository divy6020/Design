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
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: [
          new Page(
            viewModel: pages[0],
            percentVisible: 1.0,
          ),
          new PageReveal(
            revealPercent: 1.0,
            child: new Page(
              viewModel: pages[1],
              percentVisible: 1.0,
            ),
          ),
          new PagerIndicator(
            viewModel:
                new PageIndicatorViewModel(1, pages, SlideDirection.none, 0.0),
          ),
        ],
      ),
    );
  }
}
