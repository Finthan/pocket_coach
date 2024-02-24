class Me {
  final String id;

  Me({
    required this.id,
  });

  factory Me.fromJson(Map<String, dynamic> json) {
    print(json);
    return Me(
      id: json['id'] as String,
    );
  }
}

dynamic getTutorsList = 'строка не изменена';
dynamic myClientsList = 'строка не изменена';
dynamic allClientsList = 'строка не изменена';

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
      id: json['id'] as String,
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

class Training {
  final String id;
  final String nameWorkout;
  final String dateTime;
  final String typeWorkout;
  final String nameIcon;
  final int colors;

  Training({
    required this.id,
    required this.nameWorkout,
    required String dateTime,
    required this.nameIcon,
    required this.typeWorkout,
    required this.colors,
  }) : dateTime = dateTime + " 00:00:00Z";

  factory Training.fromJson(Map<String, dynamic> json) {
    int colors;
    String typeWorkout;
    String nameIcon;
    switch (json['name_workout'] as String) {
      case 'Тренирока на грудь':
        nameIcon = "assets/images/workout_g.png";
        typeWorkout = 'Грудь';
        colors = 0xFF0F8644;
        break;
      case 'Тренирока на ноги':
        nameIcon = "assets/images/workout_g.png";
        typeWorkout = 'Грудь';
        colors = 0xFF36B37B;
        break;
      case 'Тренирока на руки':
        nameIcon = "assets/images/workout_g.png";
        typeWorkout = 'Грудь';
        colors = 0xFF8B1FA9;
        break;
      default:
        nameIcon = "assets/images/workout_g.png";
        typeWorkout = 'Нет типа';
        colors = 0xFFFC571D;
        break;
    }
    return Training(
      id: json['id'] as String,
      nameWorkout: json['name_workout'] as String,
      dateTime: json['workout_date'] as String,
      colors: colors,
      typeWorkout: typeWorkout,
      nameIcon: nameIcon,
    );
  }
}

class ExerciseList {
  String id;
  String idWorkout;
  String idExercise;
  String nameExercise;
  String muscleGroup;
  String ordering;

  ExerciseList({
    required this.id,
    required this.idWorkout,
    required this.idExercise,
    required this.nameExercise,
    required this.muscleGroup,
    required this.ordering,
  });

  factory ExerciseList.fromJson(Map<String, dynamic> json) {
    return ExerciseList(
      id: json['id'] as String,
      idWorkout: json['id_workout'] as String,
      idExercise: json['id_exercise'] as String,
      nameExercise: json['name_exercise'] as String,
      muscleGroup: json['muscle_group'] as String,
      ordering: json['ordering'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_workout': idWorkout,
      'name_exercise': nameExercise,
      'muscle_group': muscleGroup,
      'ordering': int.parse(ordering),
    };
  }
}

class ApproachesList {
  String id;
  String idExerciseWorkout;
  String numberApproaches;
  String weight;
  String countList;

  ApproachesList({
    required this.id,
    required this.idExerciseWorkout,
    required this.numberApproaches,
    required this.weight,
    required this.countList,
  });

  factory ApproachesList.fromJson(Map<String, dynamic> json) {
    return ApproachesList(
      id: json['id'] as String,
      idExerciseWorkout: json['id_exercise_workout'] as String,
      numberApproaches: json['number_approaches'] as String,
      weight: json['weight'] as String,
      countList: json['count'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': int.parse(id),
      'id_exercise_workout': idExerciseWorkout,
      'number_approaches': int.parse(numberApproaches),
      'weight': double.parse(weight.replaceAll(',', '.')),
      'count_list': int.parse(countList),
    };
  }
}

class MadeApproachesList {
  String idApproaches;
  String weight;
  String countList;

  MadeApproachesList({
    required this.idApproaches,
    required this.weight,
    required this.countList,
  });

  factory MadeApproachesList.fromJson(Map<String, dynamic> json) {
    return MadeApproachesList(
      idApproaches: json['id_approaches'] as String,
      weight: json['weight'] as String,
      countList: json['count'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_approaches': int.parse(idApproaches),
      'weight': double.parse(weight.replaceAll(',', '.')),
      'count_list': int.parse(countList),
    };
  }
}

class MadeApproachesChart {
  String id;
  String idWorkout;
  String workoutDate;
  String weight;
  String countList;
  String numberApproaches;

  MadeApproachesChart({
    required this.id,
    required this.idWorkout,
    required this.workoutDate,
    required this.weight,
    required this.countList,
    required this.numberApproaches,
  });

  factory MadeApproachesChart.fromJson(Map<String, dynamic> json) {
    return MadeApproachesChart(
      id: json['id'] as String,
      idWorkout: json['id_workout'] as String,
      workoutDate: json['workout_date'] as String,
      weight: json['weight'] as String,
      countList: json['count'] as String,
      numberApproaches: json['number_approaches'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': int.parse(id),
      'id_workout': int.parse(idWorkout),
      'workout_date': int.parse(workoutDate),
      'weight': double.parse(weight.replaceAll(',', '.')),
      'count_list': int.parse(countList),
      'number_approaches': int.parse(numberApproaches),
    };
  }
}

class ClientExercise {
  String id;
  String idWorkout;
  String nameExercise;
  String muscleGroup;
  String ordering;

  ClientExercise({
    required this.id,
    required this.idWorkout,
    required this.nameExercise,
    required this.muscleGroup,
    required this.ordering,
  });

  factory ClientExercise.fromJson(Map<String, dynamic> json) {
    return ClientExercise(
      id: json['id'] as String,
      idWorkout: json['id_workout'] as String,
      nameExercise: json['name_exercise'] as String,
      muscleGroup: json['muscle_group'] as String,
      ordering: json['ordering'] as String,
    );
  }
}
