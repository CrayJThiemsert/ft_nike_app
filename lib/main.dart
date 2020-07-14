import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ft_nike_app/box_widget.dart';

import 'shoe.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double pagerValue = 0;
  PageController pageController = PageController();
  var containerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [.3, 1],
    colors: [Colors.grey[300].withOpacity(.85), Colors.white]
  );
  Shoe currentShoe;
  int currentIndex = 0;
  double animation = 0, opacity;

  @override
  void initState() {
    pageController.addListener(() {
      setState(() {
        pagerValue = pageController.page;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Stack(
        children: [
          buildAppBar(),
          buildBottomContainer(size),
          buildCartButton(size),
          buildPagerView(),
        ],
      ),
    );
  }

  Widget buildAppBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Row(
          children: [
            SizedBox(width: 20,),
            Icon(Icons.arrow_back_ios, color: Colors.black87,),
            Spacer(),
            Image.asset('images/nike.png', width: 80, color: Colors.black87),
            Spacer(),
            SizedBox(width: 20,),
          ],
        ),
      ),
    );
  }

  Widget buildPagerView() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: PageView(
        controller: pageController,
        children: getShoes().map((e) => BoxWidget(shoe: e, pagerValue: pagerValue,)).toList(),
      ),
    );
  }

  List<Shoe> getShoes() {
    List<Shoe> list = [];
    list.add(Shoe(0, 'images/image1.png', 'FALCONE SHOES', 'PINK', 110, 4.3));
    list.add(Shoe(1, 'images/image2.png', 'Air Max 270', 'BLACK', 110, 4.3));
    list.add(Shoe(2, 'images/image3.png', 'Air Max 270', 'WHITE', 110, 4.3));
    return list;
  }

  Widget buildBottomContainer(Size size) {
    if((currentIndex - pagerValue).abs().toInt() > 0) {
      currentIndex = pagerValue.toInt();
    }
    currentShoe = getShoes()[currentIndex];
    opacity = 0;
    opacity = 1 - animation.abs();
    animation = currentIndex - pagerValue;
    if(animation.abs() > .5) {
      int sign = animation > 0 ? 1 : -1;
      animation = (1 - animation * sign) * -1 * sign;
      opacity = 1 - animation.abs();
      if(animation > 0) {
        currentShoe = getShoes()[currentIndex + 1];
      } else {
        currentShoe = getShoes()[currentIndex - 1];
      }
    }
    return Center(
      child: Container(
        height: size.height - 280,
        width: double.maxFinite,
        margin: EdgeInsets.only(top: 220, left: 50, right: 50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: containerGradient
        ),
        child: Column(
          children: [
            SizedBox(height: 190,),
            animateWidget(child: Text('MEN\'S SHOE ${size.height}', style: TextStyle(color: Colors.grey[400]),)),
            SizedBox(height: 10,),
            animateWidget(distance: 200, child: Text(currentShoe.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
            SizedBox(height: 10,),
            animateWidget(child: Text(currentShoe.color, style: TextStyle(fontSize: 18),)),
            SizedBox(height: 10,),
            animateWidget(child: Text('\$ ${currentShoe.price}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)),
            Spacer(),
            buildRateFaceRow(),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

  Widget animateWidget({Widget child, double distance = 100}) {
    return Transform(
      transform: Matrix4.identity()
      ..translate(distance * animation),
      child: Opacity(opacity: opacity,
        child: child,
      ),
    );

  }

  Widget buildRateFaceRow() {
    return Row(
      children: [
        SizedBox(width: 20,),
        buildContainerBorder(
          child: animateWidget(
            distance: 30,
            child: Text('4.5',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
          )
        ),
        Spacer(),
        buildContainerBorder(
            child: Icon(Icons.favorite_border, color: Colors.black54,),
        ),
        SizedBox(width: 20,),
      ],
    );
  }

  Container buildContainerBorder({Widget child}) {
    return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Center(
          child: child,
        ),
      );
  }

  Widget buildCartButton(Size size) {
    return Positioned(
      right: size.width / 2 - 20,
      bottom: 50 - 40.0,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Colors.black87,
        ),
        child: Image.asset('images/cart.png', color: Colors.white,),
      ),
    );
  }
}
