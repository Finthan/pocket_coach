class Me {
  final String id;

  Me({required this.id});

  factory Me.fromJson(Map<String, dynamic> json) {
    return Me(id: json['id'] as String);
  }
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
      id: json['id_user'] as String,
      gender: json['gender'] as String,
      typeOfTraining: json['type_of_training'] as String,
      name: json['name'] as String,
      age: json['age'] as String,
      cost: json['cost'] as String,
    );
  }
}

class Client {
  final String id;
  final String gender;
  final String cardnumber;
  final String age;
  final String name;

  Client({
    required this.id,
    required this.gender,
    required this.cardnumber,
    required this.age,
    required this.name,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id_user'] as String,
      gender: json['gender'] as String,
      cardnumber: json['cardnumber'] as String,
      name: json['name'] as String,
      age: json['age'] as String,
    );
  }
}

class Tutors {
  final String id;
  final String gender;
  final String typeOfTraining;
  final String age;
  final String name;
  final String cost;

  Tutors({
    required this.id,
    required this.gender,
    required this.typeOfTraining,
    required this.age,
    required this.name,
    required this.cost,
  });

  factory Tutors.fromJson(Map<String, dynamic> json) {
    return Tutors(
      id: json['id'] as String,
      gender: json['gender'] as String,
      typeOfTraining: json['type_of_training'] as String,
      name: json['name'] as String,
      age: json['age'] as String,
      cost: json['cost'] as String,
    );
  }
}

class Clients {
  final String id;
  final String gender;
  final String cardnumber;
  final String age;
  final String name;

  Clients({
    required this.id,
    required this.gender,
    required this.cardnumber,
    required this.age,
    required this.name,
  });

  factory Clients.fromJson(Map<String, dynamic> json) {
    return Clients(
      id: json['id'] as String,
      gender: json['gender'] as String,
      cardnumber: json['cardnumber'] as String,
      name: json['name'] as String,
      age: json['age'] as String,
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

// 'id_tutor': '',
// 'id_client': '',
// 'name_workout': '',
// 'workout_date': '',

class WorkoutList {
  final String idTutor;
  final String idClient;
  final String nameWorkout;
  final String workoutDate;

  WorkoutList({
    required this.idTutor,
    required this.idClient,
    required this.nameWorkout,
    required this.workoutDate,
  });

  factory WorkoutList.fromJson(Map<String, dynamic> json) {
    return WorkoutList(
      idTutor: json['id_tutor'] as String,
      idClient: json['id_client'] as String,
      nameWorkout: json['name_workout'] as String,
      workoutDate: json['workout_date'] as String,
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
