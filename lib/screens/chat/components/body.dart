import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'icon_message.dart';
import 'title_message.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  static List<User> users = [
    User(
      1,
      "Никита",
      21,
      "Никита, убедительная просьба, временно не покупать мне сладкое, потому что я чувствую себя каким-то наркоманом Шоколадка просто лежит на столе, а я не могу на неё просто смотреть, обязательно надо съесть. И сегодня на работе съели с девочкой целую пачку конфет + баунти, это ппц. Если я буду знать, что в комнате существует что-то сладкое, то я ж не усну ночью",
      "23:03",
    ),
    User(
      2,
      "Антон",
      30,
      "Привет, что делаешь?",
      "15:36",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            stretch: true,
            forceElevated: true,
            pinned: true,
            floating: false,
            backgroundColor: kPrimaryColor,
            toolbarHeight: 70,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Чаты",
                style: TextStyle(color: kTextColorBackground),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                for (var i = 0; i < users.length; i++)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 70,
                        color: kSideColorMenu,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const IconMessage(),
                            TitleMessage(users: users, i: i),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
