import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pocket_coach/all_class.dart';

dynamic getTutorsList = 'строка не изменена';

List<Tutor> listOfTutors = [
  Tutor(
    id: '',
    name: '',
    age: '',
    gender: '',
    typeOfTraining: '',
    cost: '0',
  ),
];

Future<List<Tutor>> getTutors() async {
  Uri uri = Uri.http('gymapp.amadeya.net', '/api.php', {
    'apiv': '1',
    'action': 'get',
    'object': 'tutors'
  }); //Конвертируем url в uri
  getTutorsList = await http.get(uri);
  var decodedResponse = jsonDecode(utf8.decode(getTutorsList.bodyBytes)) as Map;
  String jsonString = jsonEncode(decodedResponse['data']);

  try {
    final json = await jsonDecode(jsonString) as List<dynamic>;
    listOfTutors = json
        .map((dynamic e) => Tutor.fromJson(e as Map<String, dynamic>))
        .toList();
  } catch (error) {
    print(error);
  }
  return listOfTutors;
}
