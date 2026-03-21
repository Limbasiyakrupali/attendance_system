import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';

class ShowUserListScreen extends StatefulWidget {
  const ShowUserListScreen({super.key});

  @override
  State<ShowUserListScreen> createState() => _ShowUserListScreenState();
}

class _ShowUserListScreenState extends State<ShowUserListScreen> {
  String selectedRole = "All";
  String selectedEmployee = "All";
  List<Map<String, dynamic>> getFilteredUsers(List<Map<String, dynamic>> users) {
    return users.where((user) {
      final roleMatch = selectedRole == "All" ||
          user['designation'].toString().toUpperCase() == selectedRole;

      final employeeMatch = selectedEmployee == "All" ||
          user['fullName'] == selectedEmployee;

      return roleMatch && employeeMatch;
    }).toList();
  }
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<UserProvider>().getUsers();
    });
  }
  @override
  Widget build(BuildContext context) {

    final user = context.watch<UserProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("User Details")),
    floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushNamed(context, 'add_user');
      },child: Icon(Icons.add),),
      body: user == null
          ? const Center(child: Text("No User Data"))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text("Name: ${user['name']}"),
            Text("Email: ${user['email']}"),
            Text("Role: ${user['role']}"),

            const SizedBox(height: 10),

            /// 🔥 SAFE IMAGE
            Image.network(
              user['photograph'],
              height: 120,
              errorBuilder: (_, __, ___) =>
              const Text("Image not load"),
            ),
          ],
        ),
      ),
    );
  }
}
