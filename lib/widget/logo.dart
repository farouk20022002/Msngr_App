import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/colors.dart';

class LogoApp extends StatelessWidget {
  const LogoApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/svg/louagi2.svg',
      height: 200,
      colorFilter: ColorFilter.mode(kPrimaryColor, BlendMode.srcIn),
    );
  }
}