import 'package:flutter/material.dart';

import '../Colors/color.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    Key? key,
    required this.sc,
  }) : super(key: key);

  final Size sc;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      child: SizedBox(
        height: sc.height * 0.05,
        width: sc.width / 1.1,
        child: TextFormField(
          decoration: InputDecoration(
            suffixIcon: Container(
                height: sc.height * 0.05,
                width: sc.width / 5,
                decoration: const BoxDecoration(
                    color: primaryClr,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(3),
                      bottomRight: Radius.circular(3),
                    )),
                child: const Icon(
                  Icons.search,
                  color: wbackgroundclr,
                )),
            contentPadding: const EdgeInsets.only(bottom: 18, left: 15),
            hintText: "Search",
            hintStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: Color(0xff868383),
            ),
            filled: true,
            fillColor: const Color(0xffDBD7D7),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
