import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pocket_coach/all_class.dart';

dynamic getTutorsList = 'строка не изменена';

List<Tutors> listOfTutors = [
  Tutors(
    id: '',
    name: '',
    age: '',
    gender: '',
    typeOfTraining: '',
    cost: '0',
  ),
];

Future<void> getTutors() async {
  Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
    'apiv': '1',
    'action': 'get',
    'object': 'tutors',
  });
  getTutorsList = await http.get(uri);
  var decodedResponse = jsonDecode(utf8.decode(getTutorsList.bodyBytes)) as Map;
  String jsonString = jsonEncode(decodedResponse['data']);
  try {
    final json = await jsonDecode(jsonString) as List<dynamic>;

    listOfTutors = json
        .map((dynamic e) => Tutors.fromJson(e as Map<String, dynamic>))
        .toList();
  } catch (error) {
    print(error);
  }
}

List<Clients> listOfClients = [
  Clients(
    id: '',
    name: '',
    age: '',
    gender: '',
    cardnumber: '',
  ),
];

Future<void> getClients() async {
  Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
    'apiv': '1',
    'action': 'get',
    'object': 'clients',
  });
  getTutorsList = await http.get(uri);
  var decodedResponse = jsonDecode(utf8.decode(getTutorsList.bodyBytes)) as Map;
  String jsonString = jsonEncode(decodedResponse['data']);
  try {
    print(jsonString);
    final json = await jsonDecode(jsonString) as List<dynamic>;
    listOfClients = json
        .map((dynamic e) => Clients.fromJson(e as Map<String, dynamic>))
        .toList();
  } catch (error) {
    print(error);
  }
}
