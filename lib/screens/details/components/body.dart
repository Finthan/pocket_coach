import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'image_and_icon.dart';
import 'title_and_price.dart';

class Body extends StatelessWidget {
  const Body({
    super.key,
    required this.image,
    required this.title,
    required this.country,
    required this.price,
  });

  final String image, title, country;
  final int price;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ImageAndIcons(
            size: size,
            image: image,
          ),
          TitleAndPrice(title: title, country: country, price: price),
          const SizedBox(
            height: kDefaultPadding / 2,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: size.width / 2,
                height: 84,
                child: TextButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                        ),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all(kPrimaryColor)),
                  onPressed: () {},
                  child: const Text(
                    "Купить сейчас",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Описание",
                    style: TextStyle(color: kPrimaryColor, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
