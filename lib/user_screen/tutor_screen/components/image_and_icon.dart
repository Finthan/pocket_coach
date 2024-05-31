import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../all_class.dart';
import '../../../constants.dart';

class ImageAndIcons extends StatelessWidget {
  const ImageAndIcons({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Consumer<MeModel>(
      builder: (contextModel, meModel, child) {
        return SizedBox(
          height: (size.height * 0.7) - 84,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding * 3,
                  ),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding),
                          icon: SvgPicture.asset(
                            "assets/icons/back_arrow.svg",
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      // const Spacer(),
                      // const IconCard(icon: "assets/icons/sun.svg"),
                      // const IconCard(icon: "assets/icons/icon_2.svg"),
                      // const IconCard(icon: "assets/icons/icon_3.svg"),
                      // const IconCard(icon: "assets/icons/icon_4.svg"),
                    ],
                  ),
                ),
              ),
              Container(
                height: size.height * 0.8,
                width: size.width * 0.75,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(63),
                      bottomLeft: Radius.circular(63),
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 10),
                        blurRadius: 60,
                        color: kPrimaryColor.withOpacity(0.50),
                      ),
                    ],
                    image: DecorationImage(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.contain,
                        image: AssetImage(
                            "assets/images/men_${meModel.indexCoachMan + 1}.jpg"))),
              ),
            ],
          ),
        );
      },
    );
  }
}
