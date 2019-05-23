import 'package:flutter/material.dart';

final pages = [
  new PageViewModel('Amazing Products at Amazing Prices', Colors.blue[200],
      'assets/1.png', null, 'Buy'),
  new PageViewModel('Get the right value for your product', Colors.green[200],
      'assets/2.png', null, 'Sell'),
  new PageViewModel('Know your products worth', Colors.purple[200],
      'assets/3.png', null, 'Appraise'),
];

class Page extends StatelessWidget {
  final PageViewModel viewModel;
  final double percentVisible;

  Page({
    this.viewModel,
    this.percentVisible = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      color: viewModel.color,
      child: new Opacity(
        opacity: percentVisible,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Transform(
              transform: new Matrix4.translationValues(
                  0.0, 50.0 * (1.0 - percentVisible), 0.0),
              child: new Padding(
                  padding: new EdgeInsets.only(bottom: 25.0),
                  child: new Image.asset(
                    viewModel.heroAssetPath,
                    width: 200.0,
                    height: 200.0,
                  )),
            ),
            new Transform(
              transform: new Matrix4.translationValues(
                  0.0, 30.0 * (1.0 - percentVisible), 0.0),
              child: new Padding(
                padding: new EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: new Text(
                  viewModel.title,
                  style: new TextStyle(
                      color: Colors.white,
                      fontFamily: 'flamantRoma',
                      fontSize: 34.0),
                ),
              ),
            ),
            new Transform(
              transform: new Matrix4.translationValues(
                  0.0, 30.0 * (1 - percentVisible), 0.0),
              child: new Padding(
                padding: new EdgeInsets.only(bottom: 75.0),
                child: new Text(
                  viewModel.body,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageViewModel {
  final Color color;
  final String heroAssetPath;
  final String title;
  final String body;
  final String iconAssetPath;

  PageViewModel(
    this.body,
    this.color,
    this.heroAssetPath,
    this.iconAssetPath,
    this.title,
  );
}
