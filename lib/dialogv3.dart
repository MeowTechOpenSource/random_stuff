import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Dialogv3 extends StatefulWidget {
  const Dialogv3({super.key});

  @override
  State<Dialogv3> createState() => _Dialogv3State();
}

class _Dialogv3State extends State<Dialogv3> {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
      child: AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.grey,
        insetPadding: EdgeInsets.zero,
        title: Row(
          children: [
            Text(
              "Large Cracks",
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            Spacer(),
            IconButton(
              icon: SvgPicture.asset(
                "assets/xmark.svg",
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Level 1 Cracks",
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "A small, superficial crack in the paint or plaster of a wall, often caused by settling or minor temperature changes. This type of crack is usually cosmetic and can be easily repaired with touch-up paint or filler.",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Level 2 Cracks",
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "A visible crack that extends through the surface of the wall, possibly indicating minor structural movement or settling issues. While it may not pose an immediate threat, it should be monitored and may require repair to prevent further deterioration.",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Level 3 Cracks",
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "A large or widening crack that compromises the structural integrity of the wall, possibly indicating significant foundation issues or water damage. This type of crack can lead to serious safety hazards and requires immediate professional assessment and repair to prevent collapse or further damage.",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
