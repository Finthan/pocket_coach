import 'package:flutter/material.dart';

import '../../../all_class.dart';
import '../../../constants.dart';

class ListWorkout extends StatelessWidget {
  const ListWorkout({super.key, required this.training});

  final List<Training> training;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          height: 55,
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(
            top: 15,
            left: 20,
          ),
          child: const Text(
            "Планируемые тренировки",
            style: TextStyle(
              color: kWiteColor,
              fontSize: 20,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 17, right: 17),
          child: Divider(
            color: kTextColorBox,
            height: 1,
          ),
        ),
        for (var j = 0; j < 3; j++)
          ListTile(
            contentPadding: const EdgeInsets.only(top: 5, left: 20),
            leading: const CircleAvatar(
                radius: 25,
                backgroundImage: ExactAssetImage('assets/images/people.png')),
            title: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                training[j].name,
                style: const TextStyle(color: kTextSideScreens),
              ),
            ),
            subtitle: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  training[j].date,
                  style: const TextStyle(color: kTextSideScreens),
                )),
          )
      ],
    );
  }
}

// ListTile(
//       contentPadding: const EdgeInsets.only(top: 5, left: 10),
//       leading: const CircleAvatar(
//           radius: 25,
//           backgroundImage: ExactAssetImage('assets/images/people.png')),
//       title: Padding(
//         padding: const EdgeInsets.only(right: 10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               users[i].username,
//               style: const TextStyle(color: kTextSideScreens),
//             ),
//             Text(
//               users[i].time,
//               style: const TextStyle(color: kTextSideScreens),
//             )
//           ],
//         ),
//       ),
//       subtitle: Padding(
//         padding: const EdgeInsets.only(right: 10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               users[i].lastMessage,
//               style: TextStyle(color: kTextSideScreens),
//             ),
//             users[i].isRead
//                 ? Container(
//                     child: Text(
//                       users[i].unReadMessage,
//                       style: TextStyle(color: kTextSideScreens),
//                     ),
//                     decoration: BoxDecoration(
//                         border: Border.all(width: 1, color: kPrimaryColor),
//                         borderRadius: BorderRadius.circular(50),
//                         color: kPrimaryColor),
//                   )
//                 : Container(),
//           ],
//         ),
//       ),
//     );