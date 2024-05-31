import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/workout/components/approaches_alert_dialog.dart';
import 'screens/workout/components/exercise_alert_dialog.dart';
import 'screens/workout/components/workout_alert_dialog.dart';

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
  String? authhash;

  var index;
  var indexTrainings;
  var indexCoachMan;
  var itemExercise;
  var training;
  var idTraining;
  var countWorkout;
  int currentStep = 0;
  int currentSubStep = 0;
  List<User>? listOfTutors;
  List<User>? listOfMyClients;
  List<User>? listOfAllClients;
  List<Training>? trainings;
  List<MadeApproachesChart>? madeApproachesChart;
  List<ExerciseList>? exercises;
  List<ExerciseList>? data;
  List<Exercises>? listExercises;
  List<ApproachesList>? approachesList;
  List<ClientExercise>? clientExercise;
  List<List<ApproachesList>>? approachesListClient; //_data
  List<List<MadeApproachesList>>? information; //workout.dart
  ApproachesList? currentData; //workout.dart
  ConnectionState connectionState = ConnectionState.waiting;
  dynamic exerciseList;
  int countMadeApproachesChart = 0;
  User? myTutor;

  ConnectionState connectionStateWorkout = ConnectionState.waiting;

  TextEditingController countDoneApproaches = TextEditingController();
  TextEditingController weightDoneApproaches = TextEditingController();

  bool isAuth = false;
  bool isLoad = false;
  bool? isClient;
  String? selectDayText;

  DateTime todayDay = DateTime.now();
  DateTime selectDay = DateTime(DateTime.now().year, DateTime.now().month);

  Future<void> loadAuthByClick(String login, String password) async {
    Me? newData = await _auth(login, password);
    if (newData != null) {
      isAuth = true;
      me = newData;
      exerciseList = 'строка не изменена';
    } else {
      isAuth = false;
    }
  }

  Future getAuth() async {
    print("auth");
    var prefs = await SharedPreferences.getInstance();
    var jsonData = prefs.getString('data');
    print(jsonData);
    var decodedResponse = jsonDecode(jsonData ?? "") as Map;
    print("authhash = ${decodedResponse['authhash']}");
    if (decodedResponse['authhash'] != null) {
      authhash = decodedResponse['authhash'];
      String jsonString = jsonEncode(decodedResponse['data']);
      final json = jsonDecode(jsonString) as List<dynamic>;
      me = Me.fromJson(json.first as Map<String, dynamic>);
      if (me!.idClient == null) {
        isClient = false;
      } else {
        isClient = true;
      }
      isAuth = true;
      isLoad = true;
      print("isLoad $isLoad");

      print(isAuth);
    } else {
      isLoad = true;
      print("isLoad $isLoad");
    }
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

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet) {
      dynamic auth = await http.get(uri);
      var decodedResponse = jsonDecode(utf8.decode(auth.bodyBytes)) as Map;
      print(utf8.decode(auth.bodyBytes));

      authhash = decodedResponse['authhash'];

      String jsonString = jsonEncode(decodedResponse['data']);
      try {
        final json = await jsonDecode(jsonString) as List<dynamic>;
        if (json.isNotEmpty) {
          data = Me.fromJson(json.first as Map<String, dynamic>);
          var prefs = await SharedPreferences.getInstance();
          prefs.setString('data', utf8.decode(auth.bodyBytes));
        }
      } catch (error) {}
    }
    return data;
  }

  Future<void> loadLogoutByClick() async {
    await _logout();
    isAuth = false;
    me = null;

    notifyListeners();
  }

  Future<Me?> _logout() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'auth',
      'object': 'logout',
      'authhash': authhash,
    });
    Me? data;
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet) {
      await http.get(uri);
    }
    return data;
  }

  Future<void> loadRegistByClick(
      Map<String, String> dataTextField, bool isRegClient) async {
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
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet) {
      dynamic auth = await http.get(uri);
      var decodedResponse = jsonDecode(utf8.decode(auth.bodyBytes)) as Map;
      String jsonString = jsonEncode(decodedResponse['data']);

      try {
        final json = await jsonDecode(jsonString) as dynamic;
        data = json
            .map((dynamic e) => Me.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (error) {}
    }
    return data;
  }

  void fetchMyClients() {
    loadMyClients().then((_) {
      notifyListeners();
    });
  }

  Future<void> loadMyClients() async {
    var newInfo = await getMyClients();
    if (newInfo != null) {
      listOfMyClients = newInfo;
    }
  }

  Future<List<User>?> getMyClients() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'myclients',
      'authhash': authhash,
    });

    List<User>? listOfUsers;

    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet) {
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
    var newInfo = await getAllClients();
    if (newInfo != null) {
      listOfTutors = newInfo;
    }
  }

  Future<List<User>?> getAllClients() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'allclients',
      'authhash': authhash,
    });
    List<User>? listOfUsers;

    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet) {
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
    // print("начало");
    var newInfo = await getMyTutor();
    if (newInfo != null) {
      // print("конец");
      myTutor = newInfo;
    }
  }

  Future<User?> getMyTutor() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'mytutor',
      'authhash': authhash,
    });

    User? user;

    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet) {
      var myTutorList = await http.get(uri);

      String jsonString = "";
      if (myTutorList.statusCode == 200) {
        var decodedResponse =
            jsonDecode(utf8.decode(myTutorList.bodyBytes)) as Map;
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
    // print("началоall");
    var newInfo = await getAllTutors();
    if (newInfo != null) {
      // print("конецall");
      listOfTutors = newInfo;
    }
  }

  Future<List<User>?> getAllTutors() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'alltutors',
      'authhash': authhash,
    });
    List<User>? listOfUsers;

    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet) {
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

  void updateTrainings(List<Training> newTrainings) {
    trainings = newTrainings;
    notifyListeners();
  }

  void handleCellLongPress(
      CalendarLongPressDetails details, BuildContext context) {
    if (details.appointments == null || details.appointments!.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return WorkoutAlertDialog(
            details: details,
          );
        },
      );
    }
  }

  void showDeleteConfirmationDialog(
      Training appointment, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Удалить тренировку?',
            style: TextStyle(color: Colors.black87),
          ),
          content: Text(
            "Вы уверены, что хотите удалить эту тренировку ${appointment.dateTime}?",
            style: const TextStyle(color: Colors.black54),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Отмена',
                style: TextStyle(color: Colors.black54),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Удалить'),
              onPressed: () {
                deleteTrainings();
                trainings!.removeWhere((t) => t.id == appointment.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchUpdateTraining() async {
    print("fetchUpdateTraining");
    updateTraining().then((_) {
      notifyListeners();
    });
  }

  Future<void> updateTraining() async {
    var newInfo =
        (isClient! ? await getClientTrainings() : await getTutorTrainings());
    if (newInfo != null) {
      trainings = newInfo;
      // print("данные получены");
    }
  }

  Future<List<Training>?> getTutorTrainings() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'tutorworkouts',
      'id_client': listOfMyClients![index].id,
      'authhash': authhash,
    });

    List<Training>? trainings;
    var responseTutor;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet) {
      responseTutor = await http.get(uri);

      String jsonString = "";
      if (responseTutor.statusCode == 200 && isAuth == true) {
        var decodedResponse =
            jsonDecode(utf8.decode(responseTutor.bodyBytes)) as Map;
        jsonString = jsonEncode(decodedResponse['data']);
      }
      try {
        final json = await jsonDecode(jsonString) as List<dynamic>;
        if (json.isNotEmpty) {
          trainings = json
              .map((dynamic e) => Training.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      } catch (error) {}
    }
    return trainings;
  }

  Future<List<Training>?> getClientTrainings() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'clientworkouts',
      'authhash': authhash,
    });
    var responseClient;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet) {
      responseClient = await http.get(uri);
      String jsonString = "";
      if (responseClient.statusCode == 200 && isAuth == true) {
        var decodedResponse =
            jsonDecode(utf8.decode(responseClient.bodyBytes)) as Map;
        jsonString = jsonEncode(decodedResponse['data']);
      }
      try {
        final json = await jsonDecode(jsonString) as List<dynamic>;
        if (json.isNotEmpty) {
          trainings = json
              .map((dynamic e) => Training.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      } catch (error) {}
    }
    return trainings;
  }

  Future<void> fetchDeleteTrainings() async {
    loadDeleteTrainings().then((_) {
      notifyListeners();
    });
  }

  Future<void> loadDeleteTrainings() async {
    var newInfo = await deleteTrainings();
    trainings = newInfo;
  }

  Future<List<Training>> deleteTrainings() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'set',
      'object': 'delworkout',
      'id_workout': trainings![indexTrainings].id,
      'authhash': authhash,
    });

    var response;
    var trainingsLoad;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet) {
      response = await http.get(uri);
      String jsonString = "";
      if (response.statusCode == 200 && isAuth == true) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map;
        jsonString = jsonEncode(decodedResponse['data']);
      }
      try {
        final json = await jsonDecode(jsonString) as List<dynamic>;
        if (json.isNotEmpty) {
          trainingsLoad = json
              .map((dynamic e) => Training.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      } catch (error) {}
    }
    return trainingsLoad ?? [];
  }

  Future<void> fetchAddTrainings(name, time) async {
    loadAddTrainings(name, time).then((_) {
      notifyListeners();
    });
  }

  Future<void> loadAddTrainings(name, time) async {
    await addTrainings(name, time);
  }

  Future<void> addTrainings(name, time) async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'set',
      'object': 'createworkout',
      'authhash': authhash,
      'id_client': listOfMyClients![index].id,
      'name_workout': name,
      'workout_date': time,
    });
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet) {
      dynamic response = await http.get(uri);
      String jsonString = "";
      if (response.statusCode == 200 && isAuth == true) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map;
        jsonString = jsonEncode(decodedResponse['data']);
      }
      try {
        final json = jsonDecode(jsonString) as List<dynamic>;
        if (json.isNotEmpty) {
          List<Training> newTrainings = json
              .map((dynamic e) => Training.fromJson(e as Map<String, dynamic>))
              .toList();
          updateTrainings(newTrainings);
        }
      } catch (error) {}
    }
  }

  Future<void> fetchGetMonthName() async {
    loadGetMonthName().then((_) {
      notifyListeners();
    });
  }

  Future<void> loadGetMonthName() async {
    initializeDateFormatting('ru', null);
    DateTime date = DateTime(selectDay.year, selectDay.month);
    String monthName = DateFormat.MMMM('ru').format(date);
    var text = capitalizeFirstLetter(monthName, selectDay.year);
    selectDayText = text;
  }

  void updateMonthName() {
    initializeDateFormatting('ru', null);
    DateTime date = DateTime(selectDay.year, selectDay.month);
    String monthName = DateFormat.MMMM('ru').format(date);
    selectDayText = capitalizeFirstLetter(monthName, selectDay.year);
  }

  String capitalizeFirstLetter(String word, int year) {
    return "${word.substring(0, 1).toUpperCase()}${word.substring(1)} $year";
  }

  Future<List<MadeApproachesChart>> fetchMadeApproachesList() async {
    var newInfo = await madeApproachesList();
    madeApproachesChart = newInfo;
    notifyListeners();
    return madeApproachesChart!;
  }

  Future<List<MadeApproachesChart>> madeApproachesList() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': isClient! ? 'madeclientapproaches' : 'madetutorapproaches',
      'authhash': authhash,
    });
    dynamic response;
    dynamic _madeApproachesChart;
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet) {
      response = await http.get(uri);
      String jsonString = "";
      if (response.statusCode == 200 && isAuth == true) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map;
        jsonString = jsonEncode(decodedResponse['data']);
      }
      try {
        final json = await jsonDecode(jsonString) as List<dynamic>;

        if (json.isNotEmpty) {
          _madeApproachesChart = json
              .map((dynamic e) =>
                  MadeApproachesChart.fromJson(e as Map<String, dynamic>))
              .toList();
          countMadeApproachesChart = madeApproachesChart!.length;
        }
      } catch (error) {}
      if (countMadeApproachesChart != 0) {
        connectionState = ConnectionState.done;
      }
    }
    return _madeApproachesChart ?? [];
  }

  void removeItem(int index, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтверждение удаления'),
          content: const Text('Вы действительно хотите удалить этот элемент?'),
          actions: [
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Удалить'),
              onPressed: () {
                fetchDeleteExercise(index);
                data!.removeAt(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void addExercise(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ExerciseAlertDialog();
      },
    );
  }

  void addApproaches(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ApproachesAlertDialog();
      },
    );
  }

  void updateExercise(List<ExerciseList> newExercise) {
    data = newExercise;
    notifyListeners();
  }

  Future<void> fetchDeleteExercise(index) async {
    loadDeleteExercise(index).then((_) {
      notifyListeners();
    });
  }

  Future<void> loadDeleteExercise(index) async {
    deleteExercise(index);
  }

  Future<void> deleteExercise(index) async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'set',
      'object': 'delexercise',
      'authhash': authhash,
      'id': data![index].id,
      'id_exercise': data![index].idExercise,
      'id_workout': data![index].idWorkout,
    });

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet) {
      await http.get(uri);

      try {
        for (var i = 0; i < data!.length; i++) {
          data![i].ordering = (i).toString();
        }
        fetchExercise();
      } catch (e) {}
    }
  }

  Future<void> fetchExercise() async {
    loadExercise().then((_) {
      notifyListeners();
    });
  }

  Future<void> loadExercise() async {
    setExercise();
  }

  Future<void> setExercise() async {
    var jsonData = data!.map((exercise) => exercise.toJson()).toList();
    // print(jsonData);
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'set',
      'object': 'addexercise',
      'authhash': authhash,
    });
    dynamic response;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet) {
      response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(jsonData));

      String jsonString = "";
      if (response.statusCode == 200 && isAuth == true) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map;
        jsonString = jsonEncode(decodedResponse['data']);
      }
      try {
        final json = await jsonDecode(jsonString) as List<dynamic>;
        if (json.isNotEmpty) {
          exercises = json
              .map((dynamic e) =>
                  ExerciseList.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      } catch (error) {}
      try {
        data = exercises!;
        exercises = [];
        fetchGetExercise();
      } catch (e) {}
    }
  }

  Future<void> fetchGetExercise() async {
    loadGetExercise().then((_) {
      notifyListeners();
    });
  }

  Future<void> loadGetExercise() async {
    getExercise();
  }

  Future<void> getExercise() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'getexercise',
      'id_workout': training.id.toString(),
      'authhash': authhash,
    });
    var response;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet) {
      response = await http.get(uri);
      String jsonString = "";
      if (response.statusCode == 200 && isAuth == true) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map;
        jsonString = jsonEncode(decodedResponse['data']);
      }
      // print(jsonString);
      try {
        final json = await jsonDecode(jsonString) as List<dynamic>;
        if (json.isNotEmpty) {
          exercises = json
              .map((dynamic e) =>
                  ExerciseList.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      } catch (error) {}
      try {
        data = exercises;
        exercises = [];
        updateTraining();
      } catch (e) {}
    }
  }

  Future<void> fetchGetTutorExercise() async {
    loadGetTutorExercise().then((_) {
      notifyListeners();
    });
  }

  Future<void> loadGetTutorExercise() async {
    var newData = await getTutorExercise();
    listExercises = newData;
  }

  Future<List<Exercises>?> getTutorExercise() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'gettutorexercises',
      'authhash': authhash,
    });
    var response;
    List<Exercises>? listexercises;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet) {
      response = await http.get(uri);
      String jsonString = "";
      if (response.statusCode == 200 && isAuth == true) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map;
        jsonString = jsonEncode(decodedResponse['data']);
      }
      try {
        final json = await jsonDecode(jsonString) as List<dynamic>;
        if (json.isNotEmpty) {
          listexercises = json
              .map((dynamic e) => Exercises.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      } catch (error) {}
    }
    return listexercises ?? [];
  }

  Future<void> fetchExercises(data) async {
    loadExercises(data).then((_) {
      notifyListeners();
    });
  }

  Future<void> loadExercises(data) async {
    setExercises(data);
  }

  Future<void> setExercises(ExerciseList data) async {
    var jsonData = data.toJson();
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'set',
      'object': 'addexercises',
      'authhash': authhash,
    });
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet) {
      await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(jsonData));
    }
  }

  Future<void> fetchSetApproaches() async {
    loadApproaches().then((_) {
      notifyListeners();
    });
  }

  Future<void> loadApproaches() async {
    setApproaches();
  }

  Future<void> setApproaches() async {
    var jsonData =
        approachesList!.map((aproaches) => aproaches.toJson()).toList();
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'set',
      'object': 'addapproaches',
      'authhash': authhash,
    });
    var response;
    List<ApproachesList> approaches = [];
    try {
      response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(jsonData));

      String jsonString = "";
      if (response.statusCode == 200 && isAuth == true) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map;
        jsonString = jsonEncode(decodedResponse['data']);
      }
      try {
        final json = await jsonDecode(jsonString) as List<dynamic>;
        approaches = json
            .map((dynamic e) =>
                ApproachesList.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (error) {}
      try {
        approachesList = approaches;
      } catch (e) {}
    } catch (error) {}
  }

  Future<void> fetchDeleteApproaches(i) async {
    loadDeleteApproaches(i).then((_) {
      notifyListeners();
    });
  }

  Future<void> loadDeleteApproaches(i) async {
    deleteApproaches(i);
  }

  Future<void> deleteApproaches(i) async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'set',
      'object': 'delapproaches',
      'authhash': authhash,
      'id': approachesList![i].id,
      'id_exercise_workout': approachesList![i].idExerciseWorkout,
    });
    await http.get(uri);

    try {
      for (var i = 0; i < approachesList!.length; i++) {
        approachesList![i].numberApproaches = (i + 1).toString();
      }
      fetchSetApproaches();
    } catch (e) {}
  }

  Future<void> fetchGetApproaches() async {
    loadGetApproaches().then((_) {
      notifyListeners();
    });
  }

  Future<void> loadGetApproaches() async {
    getApproaches();
  }

  Future<void> getApproaches() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'getapproaches',
      'authhash': authhash,
      'id_exercise_workout': itemExercise.id,
    });
    var response;
    List<ApproachesList> approaches = [];

    try {
      response = await http.get(uri);
    } catch (error) {}
    String jsonString = "";
    // print("привет ${utf8.decode(response.bodyBytes)}");
    if (response.statusCode == 200 && isAuth == true) {
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      jsonString = jsonEncode(decodedResponse['data']);
    }

    // print(jsonString);
    try {
      final json = await jsonDecode(jsonString) as List<dynamic>;
      if (json.length > 0) {
        approaches = json
            .map((dynamic e) =>
                ApproachesList.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (error) {}
    try {
      approachesList = (approaches == null) ? [] : approaches;
    } catch (e) {}
  }

  void removeItemApproaches(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтверждение удаления'),
          content: const Text('Вы действительно хотите удалить этот элемент?'),
          actions: [
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Удалить'),
              onPressed: () {
                fetchDeleteApproaches(index);
                approachesList!.removeAt(index);
                for (var i = 0; i < approachesList!.length; i++) {
                  approachesList![i].numberApproaches = (i + 1).toString();
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchClientTrainings() async {
    loadClientTrainings().then((_) {
      notifyListeners();
    });
  }

  Future<void> loadClientTrainings() async {
    clientTrainings();
  }

  Future<void> clientTrainings() async {
    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'get',
      'object': 'clientexercise',
      'authhash': authhash,
      'id_workout': idTraining,
    });
    var response;

    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.ethernet) {
      response = await http.get(uri);
      print(utf8.decode(response.bodyBytes));
      String jsonString = "";
      if (response.statusCode == 200 && isAuth == true) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map;
        jsonString = jsonEncode(decodedResponse['data']);
      }

      try {
        final json = await jsonDecode(jsonString) as List<dynamic>;
        if (json.isNotEmpty) {
          clientExercise = json
              .map((dynamic e) => ClientExercise.fromJson(
                    e as Map<String, dynamic>,
                  ))
              .toList();
          countWorkout = clientExercise!.length;
          fetchListClient();
        }
      } catch (error) {}
    }
  }

  Future<void> fetchListClient() async {
    loadListClient().then((_) {
      notifyListeners();
    });
  }

  Future<void> loadListClient() async {
    listClient();
  }

  Future<void> listClient() async {
    var index = 0;
    for (var element in clientExercise!) {
      Uri uriApproaches = Uri.http('gymapp.amadeya.net', '/api.php', {
        'apiv': '1',
        'action': 'get',
        'object': 'getapproaches',
        'authhash': authhash,
        'id_exercise_workout': element.id,
      });
      var responseApproaches;
      try {
        responseApproaches = await http.get(uriApproaches);
      } catch (error) {}
      String jsonStringApproaches = "";
      if (responseApproaches.statusCode == 200 && isAuth == true) {
        var decodedResponseApproaches =
            jsonDecode(utf8.decode(responseApproaches.bodyBytes)) as Map;
        jsonStringApproaches = jsonEncode(decodedResponseApproaches['data']);
      }
      try {
        final json = await jsonDecode(jsonStringApproaches) as List<dynamic>;

        if (approachesListClient!.length <= index) {
          approachesListClient!.add([]);
          approachesListClient![index].addAll(json
              .map((dynamic e) =>
                  ApproachesList.fromJson(e as Map<String, dynamic>))
              .toList());
        }
        index++;
      } catch (error) {}
    }
  }

  Future<void> fetchApproachers() async {
    List<List<Map<String, dynamic>>> jsonData = information!
        .map<List<Map<String, dynamic>>>((infoList) => infoList
            .map<Map<String, dynamic>>((info) => info.toJson())
            .toList())
        .toList();

    Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
      'apiv': '1',
      'action': 'set',
      'object': 'madeapproaches',
      'authhash': authhash,
    });
    await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(jsonData));
  }

  void Function()? onStepContinue(context) {
    if (approachesListClient != null) {
      if (currentSubStep < approachesListClient![currentStep].length - 1) {
        if (weightDoneApproaches.text != '' && countDoneApproaches.text != '') {
          if (information!.length <= currentStep) {
            information!.add([]);
          }
          if (currentSubStep == information![currentStep].length) {
            information![currentStep].add(
              MadeApproachesList(
                idApproaches:
                    approachesListClient![currentStep][currentSubStep].id,
                weight: weightDoneApproaches.text,
                countList: countDoneApproaches.text,
              ),
            );
          } else {
            information![currentStep][currentSubStep] = MadeApproachesList(
              idApproaches:
                  approachesListClient![currentStep][currentSubStep].id,
              weight: weightDoneApproaches.text,
              countList: countDoneApproaches.text,
            );
          }
          currentSubStep++;
          currentData = approachesListClient![currentStep][currentSubStep];
          if (information![currentStep].length > currentSubStep) {
            countDoneApproaches.text =
                information![currentStep][currentSubStep].countList;
            weightDoneApproaches.text =
                information![currentStep][currentSubStep].weight;
          } else {
            countDoneApproaches.clear();
            weightDoneApproaches.clear();
          }
        }
      } else {
        if (currentStep < approachesListClient!.length - 1) {
          if (weightDoneApproaches.text != '' &&
              countDoneApproaches.text != '') {
            if (currentSubStep == information![currentStep].length) {
              information![currentStep].add(
                MadeApproachesList(
                  idApproaches:
                      approachesListClient![currentStep][currentSubStep].id,
                  weight: weightDoneApproaches.text,
                  countList: countDoneApproaches.text,
                ),
              );
            } else {
              information![currentStep][currentSubStep] = MadeApproachesList(
                idApproaches:
                    approachesListClient![currentStep][currentSubStep].id,
                weight: weightDoneApproaches.text,
                countList: countDoneApproaches.text,
              );
            }
            if ((information![currentStep].length - 1 == currentSubStep) &&
                (information!.length > currentStep + 1)) {
              if (information![currentStep + 1].length > 0) {
                countDoneApproaches.text =
                    information![currentStep + 1][0].countList;
                weightDoneApproaches.text =
                    information![currentStep + 1][0].weight;
              }
            } else {
              countDoneApproaches.clear();
              weightDoneApproaches.clear();
            }
            currentStep++;
            currentSubStep = 0;
            currentData = approachesListClient![currentStep][currentSubStep];
          }
        } else {
          if (weightDoneApproaches.text != '' &&
              countDoneApproaches.text != '') {
            if (currentSubStep > information![currentStep].length - 1) {
              information![currentStep].add(
                MadeApproachesList(
                  idApproaches:
                      approachesListClient![currentStep][currentSubStep].id,
                  weight: weightDoneApproaches.text,
                  countList: countDoneApproaches.text,
                ),
              );
            } else {
              information![currentStep][currentSubStep] = MadeApproachesList(
                idApproaches:
                    approachesListClient![currentStep][currentSubStep].id,
                weight: weightDoneApproaches.text,
                countList: countDoneApproaches.text,
              );
            }
            if (information![currentStep].length > currentSubStep) {
              countDoneApproaches.text =
                  information![currentStep][currentSubStep].countList;
              weightDoneApproaches.text =
                  information![currentStep][currentSubStep].weight;
            } else {
              countDoneApproaches.clear();
              weightDoneApproaches.clear();
            }
            _showDialog(context);
          }
        }
      }
    }
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Закончить прохождение тренировки",
            style: TextStyle(color: Colors.black87),
          ),
          content: const Text(
            "Отменить сохранение тренировки нельзя!",
            style: TextStyle(color: Colors.black54),
          ),
          actions: [
            TextButton(
              child: const Text("Отмена"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Сохранить"),
              onPressed: () {
                fetchApproachers();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void Function()? onStepCancel() {
    if (currentSubStep > 0) {
      currentSubStep--;
      currentData = approachesListClient![currentStep][currentSubStep];
      countDoneApproaches.text =
          information![currentStep][currentSubStep].countList;
      weightDoneApproaches.text =
          information![currentStep][currentSubStep].weight;
    } else if (currentStep > 0) {
      currentStep--;
      currentSubStep = approachesListClient![currentStep].length - 1;
      currentData = approachesListClient![currentStep][currentSubStep];
      countDoneApproaches.text =
          information![currentStep][currentSubStep].countList;
      weightDoneApproaches.text =
          information![currentStep][currentSubStep].weight;
    }
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
      typeOfTraining: json['type_of_training'] as String?,
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
