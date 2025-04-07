import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/profile.jpg'), // Replace with a valid image path
              ),
            ),
            SizedBox(height: 20),
            Text(
              "John Doe", // Replace with actual user name
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "johndoe@example.com", // Replace with actual user email
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 30),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Account Information"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text("Change Password"),
              onTap: () {
                // Implement change password functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text("Help & Support"),
              onTap: () {
                // Implement help & support functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                // Implement logout functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
