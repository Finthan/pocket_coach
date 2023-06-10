import 'package:flutter/material.dart';

import '../../../constants.dart';

class TitleAndPrice extends StatelessWidget {
  const TitleAndPrice({
    super.key,
    required this.title,
    required this.status,
    required this.price,
  });

  final String title, status;
  final int price;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
      ),
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$title\n",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextSpan(
                  text: status,
                  style: const TextStyle(
                    fontSize: 20,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            '₽$price',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: kPrimaryColor,
                ),
          ),
        ],
      ),
    );
  }
}
