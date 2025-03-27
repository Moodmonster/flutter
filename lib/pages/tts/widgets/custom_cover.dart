import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Expanded customCover({
  required String coverImg,
  required String title
}) {
  return Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Color(0xff21283F),
              width: 1,
            ),
          ),
          child: Hero(
            tag: coverImg,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                coverImg,
                width: 240.w,
                height: 240.w,
              ),
            ),
          ),
        ),
        SizedBox(height: 24),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white
          ),
        )
      ],
    ),
  );
}