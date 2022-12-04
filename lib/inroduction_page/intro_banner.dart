import 'package:flutter/material.dart';
import 'package:linear/inroduction_page/intro_page.dart';

class LinearIntroBanner extends StatefulWidget {
  const LinearIntroBanner({super.key});

  @override
  State<LinearIntroBanner> createState() => _LinearIntroBannerState();
}

class _LinearIntroBannerState extends State<LinearIntroBanner> {
  bool _shouldShowBanner = true;

  @override
  Widget build(BuildContext context) {
    if (!_shouldShowBanner) {
      return Material(child: Container());
    }
    return Material(
        child: SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: DecoratedBox(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF618F6E),
              Color(0xFFBAC9BE),
            ],
          )),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LinearIntro()),
                  );
                },
                child: const Text("Click here to get to know the linear App!",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    maxLines: 1),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _shouldShowBanner = false;
                });
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
          ])),
    ));
  }
}
