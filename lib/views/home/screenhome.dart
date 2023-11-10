import 'package:festa/controller/api.dart';
import 'package:festa/model/person.dart';
import 'package:festa/views/widgets/appbarwidget.dart';
import 'package:festa/views/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  late Future<List<Person>> futurePerson;
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    futurePerson = ApiService.fetchPersons();
  }

  Future<bool> checkIfUserIsLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  void updatePersonList(String? gender) {
    setState(() {
      selectedGender = gender;
      futurePerson = ApiService.fetchPersons(gender: gender);
    });
  }

  @override
  Widget build(BuildContext context) {
    checkIfUserIsLoggedIn().then((isLoggedIn) {
      if (!isLoggedIn) {
        
      }
    });

    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Container(
          color: Colors.white,
          child: const MyDrawer(),
        ),
      ),
      appBar:  PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppbarWidget(
          title: 'Home', onFilterSelected: updatePersonList,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Person>>(
          future: futurePerson,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Person person = snapshot.data![index];
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(person.picture.large),
                        Text('Name: ${person.name.first} ${person.name.last}'),
                        Text(
                          'Email: ${person.email}',
                          maxLines: 2,
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      
    );
  }

 
}
