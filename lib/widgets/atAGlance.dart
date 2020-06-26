import 'package:HyperBeam/widgets/designConstants.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AtAGlance extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;

  const AtAGlance({Key key, this.screenHeight, this.screenWidth}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _AtAGlanceState();
}

class _AtAGlanceState extends State<AtAGlance> {
  final controller = PageController();
  final List<Widget> _pages = <Widget>[
    new ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: new FlutterLogo(colors: Colors.blue),
    ),
    new ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: new FlutterLogo(style: FlutterLogoStyle.stacked, colors: Colors.red),
    ),
    new ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: new FlutterLogo(style: FlutterLogoStyle.horizontal, colors: Colors.green),
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: widget.screenWidth*0.1 - 8, top: 16),
      padding: EdgeInsets.only(left: 10,top: 10),
      height: widget.screenHeight * 0.20,
      width: widget.screenWidth * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 2.0, color: kPrimaryColor),
      ),
      child: Stack(
        children: <Widget>[
          PageView.builder(
            physics: new AlwaysScrollableScrollPhysics(),
            controller: controller,
            itemBuilder: (BuildContext context, int index) {
              return _pages[index % _pages.length];
            },
          ),
          Positioned(
            bottom: 4,
            left: 0.0,
            right: 0.0,
            child: Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect: WormEffect(),
              ),
            )
          ),
        ],
      )

/*
        SmoothPageIndicator(
          controller: controller,
          count: 3,
          effect: WormEffect(),
        )

 */
    );
  }
}