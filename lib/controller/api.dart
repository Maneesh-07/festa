
import 'dart:convert';
import 'package:festa/model/person.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static List<Person> parsePersons(List<dynamic> results) {
    List<Person> persons = [];

    for (var json in results) {
      persons.add(Person.fromJson(json));
    }

    return persons;
  }

  static Future<List<Person>> fetchPersons({String? gender}) async {
    String apiUrl = 'https://randomuser.me/api/?results=100';
    if (gender != null) {
      apiUrl += '&gender=$gender';
    }

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
     
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      List<Person> persons = parsePersons(results);
      return persons;
    } else {
    
      throw Exception('Failed to load persons');
    }
  }
}
