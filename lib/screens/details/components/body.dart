import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'image_and_icon.dart';
import 'title_and_price.dart';

class Body extends StatelessWidget {
  const Body({
    super.key,
    required this.image,
    required this.title,
    required this.status,
    required this.price,
  });

  final String image, title, status;
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
          TitleAndPrice(title: title, status: status, price: price),
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
                  onPressed: () {}, //=> _openTelegramChat()
                  child: const Text(
                    "Перейти в чат",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
        ],
      ),
    );
  }

  // _openTelegramChat() async {
  //   final url = 'https://t.me/$title';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     print('Could not launch $url');
  //   }
  // }
}
