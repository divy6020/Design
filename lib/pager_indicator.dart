import 'dart:ui';

import 'package:design/pages.dart';
import 'package:flutter/material.dart';

class PagerIndicator extends StatelessWidget {

  final PageIndicatorViewModel viewModel;

  PagerIndicator({this.viewModel,});
  
  @override
  Widget build(BuildContext context) {

    List<PageBubble> bubbles = [];
    for(var i=0;i<viewModel.pages.length;++i){
      final page = viewModel.pages[i];
      bubbles.add(new PageBubble(
        viewModel: new PagerBubbleViewModel(i == viewModel.activeIndex ? 1.0 : 0.0, page.color, page.iconAssetPath, false),
      ));
    }

    return   new Column(
            children: [
              new Expanded(
                child: new Container(),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 new PageBubble(
                  viewModel: new PagerBubbleViewModel(0.0, Colors.green, 'assets/4.png', false),
                 ),
               new PageBubble(
                 viewModel: new PagerBubbleViewModel(1.0, Colors.green, 'assets/4.png', false),
               ),
               new PageBubble(
                 viewModel: new PagerBubbleViewModel(0.0, Colors.green, 'assets/4.png', true),
               )
                ],
              )
            ],
          );
  }
}

class PagerBubbleViewModel {
  final String iconAssetPath;
  final Color color;
  final bool isHollow;
  final double activePercent;

  PagerBubbleViewModel(

    this.activePercent,
    this.color,
    this.iconAssetPath,
    this.isHollow
  );
}

enum SlideDirection{
  leftToRight,
  rightToLeft,
  none
}

class PageIndicatorViewModel{
  final List<PageViewModel> pages;
  final int activeIndex;
  final SlideDirection slideDirection;
  //slide direction
  final double slidePercent;

  PageIndicatorViewModel(
    this.activeIndex,
    this.pages,
    this.slideDirection,
    this.slidePercent
  );

}

class PageBubble extends StatelessWidget {
  
  final PagerBubbleViewModel viewModel;

  PageBubble({this.viewModel});

  @override
  Widget build(BuildContext context) {
    return   new Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: new Container(
                      width: lerpDouble(20.0,35.0,viewModel.activePercent ),
                      height: lerpDouble(20.0,35.0,viewModel.activePercent ),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: viewModel.isHollow
                        ? Colors.transparent
                        : Color(0x88ffffff),
                        border: new Border.all(
                          color: viewModel.isHollow
                          ?const Color(0x88ffffff)
                          :Colors.transparent,
                          width: 3.0
                        )
                      ),
                      child: new Opacity(opacity: viewModel.activePercent,child: new Image.asset(viewModel.iconAssetPath,color: viewModel.color,)),

                    ),
                  );
  }
}