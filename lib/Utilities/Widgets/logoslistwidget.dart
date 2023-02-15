import 'package:flutter/material.dart';

import '../../Models/Logos/logosmodel.dart';
import '../../Screens/DetailScreens/categorydetail.dart';

class LogosListWidget extends StatelessWidget {
  const LogosListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: SizedBox(
        height: 55,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: logoslist.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(6.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarScreen(details: logoslist[index]),
                  ),
                );
              },
              child: Container(
                height: 40,
                width: 41,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffD9D9D9),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        logoslist[index].image,
                        height: 20,
                      ),
                      Expanded(
                        child: Text(
                          logoslist[index].name,
                          style: const TextStyle(
                              fontSize: 7, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
