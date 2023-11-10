import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


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
                      color: Colors.white, 
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




