import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class LinearIntro extends StatefulWidget {
  const LinearIntro({super.key});

  @override
  State<LinearIntro> createState() => _LinearIntroState();
}

class _LinearIntroState extends State<LinearIntro> {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
        pages: buildListOfIntoPages(),
        showNextButton: true,
        next: const Icon(Icons.arrow_forward),
        showBackButton: false,
        done: const Text(
          "Done",
          style: TextStyle(fontWeight: FontWeight.w700),
          ),
        onDone: () {
          Navigator.of(context).pop();
        },
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Theme.of(context).colorScheme.secondary,
          color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0)
          ),
        ),
      );
  }
  
  buildListOfIntoPages() {
    return [
      PageViewModel(
        title: "Welcome to the linear app!",
        body: "This is a simple introduction to the linear app.",
        image: Center(
          child: Image.asset('assets/launcher/linear_logo.png'),
        ),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          imagePadding: EdgeInsets.fromLTRB(0, 54, 0, 24),
          contentMargin: EdgeInsets.all(26),
        ),
      ),
      PageViewModel(
        title: "Follow your friends",
        body: "And those who share your passions and interests.",
        image: Center(
          child: Image.asset('assets/intro/follow_people.png'),
        ),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), 
          imagePadding: EdgeInsets.fromLTRB(0, 54, 0, 24),
          contentMargin: EdgeInsets.all(26),
        ),
      ),
      PageViewModel(
        title: "Join communities",
        body: "And share your thoughts in a supportive and encouraging environment.",
        image: Center(
          child: Image.asset('assets/intro/team_building.png'),
        ),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          imagePadding: EdgeInsets.fromLTRB(0, 54, 0, 24),
          contentMargin: EdgeInsets.all(26),
        ),
      ),
      PageViewModel(
        title: "Achieve your goals",
        body: "Get a step closer to your goals and document your journey.",
        image: Center(
          child: Image.asset('assets/intro/achieve_goals.png'),
        ),
        decoration: const PageDecoration(
          titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          imagePadding: EdgeInsets.fromLTRB(0, 54, 0, 24),
          contentMargin: EdgeInsets.all(26),
        ),
      ),
    ];
  }
}