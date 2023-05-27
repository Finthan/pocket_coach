import 'package:flutter/material.dart';

import '../constants.dart';

class Coach extends StatelessWidget {
  const Coach({
    super.key,
    required this.image,
    required this.title,
    required this.country,
    required this.price,
    required this.press,
  });

  final String image, title, country;
  final int price;
  final void Function() press;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: kDefaultPadding,
        top: kDefaultPadding / 2,
        bottom: kDefaultPadding * 2.5,
      ),
      //width: size.width * 0.4,
      width: 180,
      child: Column(
        children: <Widget>[
          Image.asset(image),
          GestureDetector(
            onTap: press,
            child: Container(
              padding: const EdgeInsets.all(kDefaultPadding / 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 50,
                    color: kPrimaryColor.withOpacity(0.23),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 120,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "$title\n".toUpperCase(),
                            style: TextStyle(
                                color:
                                    kTextColor), //Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text: country.toUpperCase(),
                            style: TextStyle(
                              color: kPrimaryColor.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '₽$price',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: kPrimaryColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
