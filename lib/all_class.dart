class Me {
  final String id;
  final String? username;
  final int? age;
  final String? lastMessage;
  final String? time;
  final String? status;
  final String? unReadMessage;
  final bool? isRead;

  Me({
    required this.id,
    this.username,
    this.age,
    this.lastMessage,
    this.time,
    this.status,
    this.unReadMessage,
    this.isRead,
  });

  factory Me.fromJson(Map<String, dynamic> json) {
    return Me(
      id: json['id'] as String,
    );
  }
}

class User {
  final int id;
  final String username;
  final int age;
  final String lastMessage;
  final String time;
  final String status;
  final String unReadMessage;
  final bool isRead;

  User({
    required this.id,
    required this.username,
    required this.age,
    required this.lastMessage,
    required this.time,
    required this.status,
    required this.unReadMessage,
    required this.isRead,
  });
}

class Tutor {
  final String id;
  final String gender;
  final String typeOfTraining;
  final String age;
  final String name;
  final String cost;

  Tutor({
    required this.id,
    required this.gender,
    required this.typeOfTraining,
    required this.age,
    required this.name,
    required this.cost,
  });

  factory Tutor.fromJson(Map<String, dynamic> json) {
    return Tutor(
      id: json['id'] as String,
      gender: json['gender'] as String,
      typeOfTraining: json['type_of_training'] as String,
      name: json['name'] as String,
      age: json['age'] as String,
      cost: json['cost'] as String,
    );
  }
}

class Message {
  late bool isMe;
  late String message;
  late String time;

  Message(
    this.isMe,
    this.message,
    this.time,
  );
}

class Training {
  late int id;
  late String nameIcon;
  late String name;
  late String dateTime;
  late List<String> workout;
  late int colors;

  Training(
    this.id,
    this.nameIcon,
    this.name,
    this.dateTime,
    this.workout,
    this.colors,
  );
}
