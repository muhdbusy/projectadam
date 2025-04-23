import 'package:flutter/material.dart';
import 'package:day8_splash/helpsupport.dart';
import 'package:day8_splash/main.dart';
import 'accountinformation.dart';
import 'academicintegrity.dart'; // Make sure this page exists
import 'hardwarecomponents.dart'; // Make sure to import your HardwareComponentsPage

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "My Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF4CAF50), // Green color for farming theme
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Header with profile
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF4CAF50),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    image: DecorationImage(
                      image: AssetImage('assets/gadam.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "ADAM HAZIQ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "muhammadadamhaziq06@gmail.com",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.account_circle_outlined,
                    iconColor: Color(0xFF4CAF50),
                    title: "Account Information",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DeveloperProfilePage()),
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  _buildMenuItem(
                    context,
                    icon: Icons.help_outline,
                    iconColor: Color(0xFF2196F3),
                    title: "Help & Support",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HelpSupportPage()),
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  _buildMenuItem(
                    context,
                    icon: Icons.shield_outlined,
                    iconColor: Colors.orange,
                    title: "Academic Integrity",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AcademicIntegrityPage()),
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  _buildMenuItem(
                    context,
                    icon: Icons.hardware,
                    iconColor: Colors.purple,
                    title: "Hardware Components",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HardwareComponentsPage()),
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  _buildMenuItem(
                    context,
                    icon: Icons.logout,
                    iconColor: Colors.red[400]!,
                    title: "Logout",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, {
        required IconData icon,
        required Color iconColor,
        required String title,
        required Function onTap,
      }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[500]),
        onTap: () => onTap(),
      ),
    );
  }
}