import 'package:festa/controller/api.dart';
import 'package:festa/model/person.dart';
import 'package:festa/views/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        // Handle if user is not logged in
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

class AppbarWidget extends StatefulWidget {
  final String title;
   final Function(String?) onFilterSelected;
  const AppbarWidget({Key? key, required this.title, required this.onFilterSelected}) : super(key: key);

  @override
  State<AppbarWidget> createState() => _AppbarWidgetState();
}

class _AppbarWidgetState extends State<AppbarWidget> {
  @override
  Widget build(BuildContext context) {
    final firstLetter = widget.title.isNotEmpty ? widget.title[0] : '';
    final restOfTitle = widget.title.substring(1);

    return AppBar(
      centerTitle: true,
      backgroundColor: const Color.fromARGB(255, 4, 42, 95),
      leading: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          );
        }),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              text: firstLetter,
              style: GoogleFonts.robotoSlab(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 4,
                ),
              ),
              children: [
                TextSpan(
                  text: restOfTitle,
                  style: GoogleFonts.robotoSlab(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white, // Update color here
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            onPressed: () async {
              await showFilterDialog(context);
            },
            style: ButtonStyle(
              fixedSize: const MaterialStatePropertyAll(Size(10, 20)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(Colors.white),
              foregroundColor: MaterialStateProperty.all(Colors.blue),
            ),
            child: const Text('Filter'),
          ),
        )
      ],
    );
  }
   Future<void> showFilterDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertDialog(
          onFilterSelected: widget.onFilterSelected,
        );
      },
    );
  }
}


class MyAlertDialog extends StatefulWidget {
  final Function(String?) onFilterSelected;

  const MyAlertDialog({Key? key, required this.onFilterSelected}) : super(key: key);

  @override
  _MyAlertDialogState createState() => _MyAlertDialogState();
}

class _MyAlertDialogState extends State<MyAlertDialog> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Options'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('All'),
            leading: Radio<String>(
              value: 'null',
              groupValue: selectedGender,
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Male'),
            leading: Radio<String>(
              value: 'male',
              groupValue: selectedGender,
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Female'),
            leading: Radio<String>(
              value: 'female',
              groupValue: selectedGender,
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                });
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            widget.onFilterSelected(selectedGender);
            print('Selected Filter: $selectedGender');
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}



