import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../models/coach.dart';
import '../screens/details/details_screen.dart';

class CoachWoman extends StatefulWidget {
  const CoachWoman({
    super.key,
  });

  @override
  State<CoachWoman> createState() => _CoachWomanState();
}

class _CoachWomanState extends State<CoachWoman> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Coach(
            image: "assets/images/women_1.jpg",
            title: "Анастасия",
            TypeOfTraning: "Тренер",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DetailsScreen(
                    title: "Анастасия",
                    country: "Тренер",
                    image: "assets/images/women_1.jpg",
                    price: 500,
                  ),
                ),
              );
            },
            price: 500,
          ),
          Coach(
            image: "assets/images/women_2.jpg",
            title: "Виталина",
            TypeOfTraning: "Тренер",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DetailsScreen(
                    title: "Виталина",
                    country: "Тренер",
                    image: "assets/images/women_2.jpg",
                    price: 600,
                  ),
                ),
              );
            },
            price: 600,
          ),
        ],
      ),
    );
  }
}

class FeaturePlantCard extends StatelessWidget {
  const FeaturePlantCard({
    super.key,
    required this.image,
    required this.press,
  });

  final String image;
  final void Function() press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: const EdgeInsets.only(
          left: kDefaultPadding,
          top: kDefaultPadding / 2,
          bottom: kDefaultPadding / 2,
        ),
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(image),
          ),
        ),
      ),
    );
  }
}
