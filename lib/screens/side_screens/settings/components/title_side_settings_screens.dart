import 'package:flutter/material.dart';

import '../../../../constants.dart';

class TitleSideSettingsScreens extends StatelessWidget {
  const TitleSideSettingsScreens({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 25, bottom: 15),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: kTextSideScreens),
      ),
    );
  }
}
