import 'package:festa/services/auth.dart';
import 'package:festa/views/login/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  final User? user;

  const MyDrawer({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? "User Name"),
            accountEmail: Text(user?.email ?? "user@email.com"),
          ),
          GestureDetector(
            onTap: () {
              _showLogoutConfirmationDialog(context);
            },
            child: const ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text('Log Out'),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final logoutProvider =
                    Provider.of<LoginProvider>(context, listen: false);
                logoutProvider.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AuthPage(),
                  ),
                  (Route<dynamic> route) =>
                      false, // This predicate always returns false, so it removes all routes.
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
