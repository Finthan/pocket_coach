import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';

class ButtonBackSideScreens extends StatelessWidget {
  const ButtonBackSideScreens({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: IconButton(
        splashRadius: 23,
        padding: const EdgeInsets.all(16),
        icon: SvgPicture.asset(
          "assets/icons/back_arrow.svg",
          color: kButtonBackSideSrceens,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
