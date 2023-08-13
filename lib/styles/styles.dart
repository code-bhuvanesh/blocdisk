import 'package:flutter/material.dart';

class AppColors {
  // static const Color background = Colors.white; //#faf7f7 hex value
  // static const Color postBackgound =
  //     Color.fromARGB(255, 150, 150, 150); //#faf7f7 hex value
  // static const Color postBorder =
  //     Color.fromARGB(255, 246, 246, 246); //#fa
  static const Color background =
      Color.fromARGB(255, 246, 246, 246); //#faf7f7 hex value
  static const Color postBackgound = Color.fromARGB(255, 150, 150, 150);
  static const Color postBorder = Colors.white;
  static const Color blue = Color.fromARGB(255, 33, 54, 243);
}

class AppTextStyles {
  static const logoTextStyle = TextStyle(
    fontFamily: "Lovely_Bakery",
    fontSize: 36,
    fontWeight: FontWeight.w900,
  );

  static const postTittleText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static const commentTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const commentSubTitle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Color.fromARGB(255, 97, 97, 97));

  static const postSubTittleText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w300,
  );

  static const titleTextStyle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
  );
  static const subTitleTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );
  static const appDrawerTitleTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );
}

class AppSizes {
  //radius
  static double radius15 = 15;
  static double radius25 = 25;
  static BorderRadius border15 = BorderRadius.circular(radius15);
  static BorderRadius border25 = BorderRadius.circular(radius25);
  static double postTopSideRadius = 15;
  static BorderRadius postTopSideBorder = BorderRadius.only(
    topLeft: Radius.circular(radius15),
    topRight: Radius.circular(radius15),
  );
    static BorderRadius commentTopSideBorder = BorderRadius.only(
    topLeft: Radius.circular(radius25),
    topRight: Radius.circular(radius25),
  );
  static double radius8 = 8;
  static BorderRadius border8 = BorderRadius.circular(radius8);
  static double circleRadius = 200;
  static BorderRadius circleBorder = BorderRadius.circular(circleRadius);

  //margin
  static double margin_8 = 8;
}
