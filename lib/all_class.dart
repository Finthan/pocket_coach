import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Me {
  final String id;
  String? idTutor;
  String? idClient;
  final String gender;
  final String age;
  final String name;
  String? typeOfTraining;
  String? cost;
  String? cardnumber;

  Me({
    required this.id,
    this.idTutor,
    this.idClient,
    required this.gender,
    required this.age,
    required this.name,
    this.typeOfTraining,
    this.cost,
    this.cardnumber,
  });

  factory Me.fromJson(Map<String, dynamic> json) {
    return Me(
      id: json['id'] as String,
      idTutor: json['id_tutor'] as String?,
      idClient: json['id_client'] as String?,
      gender: json['gender'] as String,
      name: json['name'] as String,
      age: json['age'] as String,
      typeOfTraining: json['type_of_training'] as String?,
      cost: json['cost'] as String?,
      cardnumber: json['cardnumber'] as String?,
    );
  }
}

class MeModel with ChangeNotifier {
  Me? me;

  List<User>? listOfTutors;
  List<User>? listOfMyClients;
  List<User>? listOfAllClients;
  User? myTutor;

  bool? loadingAuth;
  bool? loadingRegist;
  bool? loadingMyClients;
  bool? loadingAllClients;
  bool? loadingMyTutor;
  bool? loadingAllTutors;

  bool? isAuth;
  bool? isClient;

  Future<void> loadAuthByClick(String login, String password) async {
    loadingAuth = true;
    notifyListeners();
    Me? newData = await _auth(login, password);
    if (newData != null) {
      isAuth = true;
      me = newData;
      me!.cardnumber == null
          ? {
              isClient = false,
              fetchMyClients(),
              fetchAllClients(),
            }
          : {
              isClient = true,
              fetchMyTutor(),
              fetchAllTutors(),
            };
    } else {
      isAuth = false;
    }
    loadingAuth = false;
    notifyListeners();
  }

  Future<Me?> _auth(String login, String password) async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'auth',
      'object': 'login',
      'login': login,
      'pass': password,
    });
    Me? data;
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult != ConnectivityResult.none) {
      dynamic auth = await http.get(uri);
      var decodedResponse = jsonDecode(utf8.decode(auth.bodyBytes)) as Map;
      String jsonString = jsonEncode(decodedResponse['data']);
      try {
        final json = await jsonDecode(jsonString) as List<dynamic>;
        if (json.isNotEmpty) {
          data = Me.fromJson(json.first as Map<String, dynamic>);
        }
      } catch (error) {}
    }
    return data;
  }

  Future<void> loadRegistByClick(
      Map<String, String> dataTextField, bool isRegClient) async {
    loadingRegist = true;
    notifyListeners();
    Me? newData = await _regist(dataTextField, isRegClient);
    if (newData != null) {
      isAuth = true;
      me = newData;
      if (me!.cardnumber == null) {
        isClient = false;
      } else {
        isClient = true;
      }
    } else {
      isAuth = false;
    }
    loadingRegist = false;
    notifyListeners();
  }

  Future<Me?> _regist(
      Map<String, String> dataTextField, bool isRegClient) async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'auth',
      'object': isRegClient ? 'registerclient' : 'registertutor',
      'login': dataTextField['login'],
      'pass': dataTextField['password'],
      'name': dataTextField['name'],
      'age': dataTextField['age'],
      'number': dataTextField['number'],
      'gender': dataTextField['gender'],
      if (isRegClient) ...{
        'cardnumber': dataTextField['cardnumber'],
      } else ...{
        'type_of_training': dataTextField['training'],
        'cost': dataTextField['cost'],
      }
    });

    Me? data;

    dynamic auth = await http.get(uri);
    var decodedResponse = jsonDecode(utf8.decode(auth.bodyBytes)) as Map;
    String jsonString = jsonEncode(decodedResponse['data']);

    try {
      final json = await jsonDecode(jsonString) as dynamic;
      data = json
          .map((dynamic e) => Me.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (error) {}
    return data;
  }

  void fetchMyClients() {
    loadMyClients().then((_) {
      notifyListeners();
    });
  }

  Future<void> loadMyClients() async {
    loadingMyClients = true;
    var newInfo = await getMyClients();
    if (newInfo != null) {
      listOfMyClients = newInfo;
    }
    loadingMyClients = false;
  }

  Future<List<User>?> getMyClients() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'myclients',
      'id_user': me!.id.toString(),
    });

    List<User>? listOfUsers;

    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult != ConnectivityResult.none) {
      myClientsList = await http.get(uri);

      String jsonString = "";
      if (myClientsList.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(myClientsList.bodyBytes)) as Map;
        jsonString = jsonEncode(decodedResponse['data']);
        print(jsonString);
      }

      try {
        final json = await jsonDecode(jsonString) as List<dynamic>;
        if (json.isNotEmpty) {
          listOfUsers = json
              .map((dynamic e) => User.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      } catch (error) {}
    }

    return listOfUsers;
  }

  void fetchAllClients() async {
    loadAllClients().then((_) {
      notifyListeners();
    });
  }

  Future<void> loadAllClients() async {
    loadingAllClients = true;
    var newInfo = await getAllClients();
    if (newInfo != null) {
      listOfTutors = newInfo;
    }
    loadingAllClients = false;
  }

  Future<List<User>?> getAllClients() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'allclients',
    });
    List<User>? listOfUsers;

    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult != ConnectivityResult.none) {
      myClientsList = await http.get(uri);

      String jsonString = "";
      if (myClientsList.statusCode == 200 && isAuth == true) {
        var decodedResponse =
            jsonDecode(utf8.decode(myClientsList.bodyBytes)) as Map;
        jsonString = jsonEncode(decodedResponse['data']);
      }

      try {
        final json = await jsonDecode(jsonString) as List<dynamic>;
        if (json.isNotEmpty) {
          listOfUsers = json
              .map((dynamic e) => User.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      } catch (error) {}
    }

    return listOfUsers;
  }

  Future<void> fetchMyTutor() async {
    loadMyTutor().then((_) {
      notifyListeners();
    });
  }

  Future<void> loadMyTutor() async {
    loadingMyTutor = true;
    var newInfo = await getMyTutor();
    if (newInfo != null) {
      myTutor = newInfo;
    }
    loadingMyTutor = false;
  }

  Future<User?> getMyTutor() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'mytutor',
      'id_user': me!.id.toString(), //!!!!!! Изменить в PHP
    });

    User? user;

    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult != ConnectivityResult.none) {
      myClientsList = await http.get(uri);

      String jsonString = "";
      if (myClientsList.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(myClientsList.bodyBytes)) as Map;
        jsonString = jsonEncode(decodedResponse['data']);
      }

      try {
        final json = await jsonDecode(jsonString) as List<dynamic>;
        if (json.isNotEmpty) {
          user = User.fromJson(json.first as Map<String, dynamic>);
        }
      } catch (error) {}
    }
    return user;
  }

  Future<void> fetchAllTutors() async {
    loadAllTutors().then((_) {
      notifyListeners();
    });
  }

  Future<void> loadAllTutors() async {
    loadingAllTutors = true;
    var newInfo = await getAllTutors();
    if (newInfo != null) {
      listOfTutors = newInfo;
    }
    loadingAllTutors = false;
  }

  Future<List<User>?> getAllTutors() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'alltutors',
      'id_client': MeModel().me!.idClient, //!!!!!! Изменить в PHP
    });
    List<User>? listOfUsers;

    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult != ConnectivityResult.none) {
      getTutorsList = await http.get(uri);

      String jsonString = "";
      if (getTutorsList.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(getTutorsList.bodyBytes)) as Map;
        jsonString = jsonEncode(decodedResponse['data']);
      }

      try {
        final json = await jsonDecode(jsonString) as List<dynamic>;
        if (json.isNotEmpty) {
          listOfUsers = json
              .map((dynamic e) => User.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      } catch (error) {}
    }
    return listOfUsers;
  }
}

dynamic getTutorsList = 'строка не изменена';
dynamic myClientsList = 'строка не изменена';
dynamic allClientsList = 'строка не изменена';

class User {
  String id;
  String gender;
  String? cardnumber;
  String age;
  String number;
  String name;
  String? typeOfTraining;
  String? cost;

  User(
      {required this.id,
      required this.gender,
      this.cardnumber,
      required this.age,
      required this.number,
      required this.name,
      this.typeOfTraining,
      this.cost});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      gender: json['gender'] as String,
      cardnumber: json['cardnumber'] as String?,
      name: json['name'] as String,
      age: json['age'] as String,
      number: json['number'] as String,
      typeOfTraining: json['typeOfTraining'] as String?,
      cost: json['cost'] as String?,
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
  }) : dateTime = "$dateTime 00:00:00Z";

  factory Training.fromJson(Map<String, dynamic> json) {
    int colors;
    String typeWorkout;
    String nameIcon;
    String muscleGroup;
    if (json['muscle_group'] != null) {
      muscleGroup = (json['muscle_group'] as String).toLowerCase();
    } else {
      muscleGroup = '';
    }
    switch (muscleGroup) {
      case 'квадрицепс':
        nameIcon = "assets/images/workout_g.png";
        typeWorkout = 'Ноги';
        colors = 0xFF0F8644;
        break;
      case 'икроножная мышца':
        nameIcon = "assets/images/workout_g.png";
        typeWorkout = 'Ноги';
        colors = 0xFF0F8644;
        break;
      case 'грудь':
        nameIcon = "assets/images/workout_g.png";
        typeWorkout = 'Грудь';
        colors = 0xFF36B37B;
        break;
      case 'бицепс':
        nameIcon = "assets/images/workout_g.png";
        typeWorkout = 'Руки';
        colors = 0xFF8B1FA9;
        break;
      case 'трицепс':
        nameIcon = "assets/images/workout_g.png";
        typeWorkout = 'Руки';
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
      'id_exercise': idExercise,
      'name_exercise': nameExercise,
      'muscle_group': muscleGroup,
      'ordering': int.parse(ordering),
    };
  }
}

class Exercises {
  String id;
  String muscleGroup;
  String nameExercise;

  Exercises({
    required this.id,
    required this.muscleGroup,
    required this.nameExercise,
  });

  factory Exercises.fromJson(Map<String, dynamic> json) {
    return Exercises(
      id: json['id'] as String,
      muscleGroup: json['muscle_group'] as String,
      nameExercise: json['name_exercise'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name_exercise': nameExercise,
      'muscle_group': muscleGroup,
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
