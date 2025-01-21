import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const route = '/profile_screen';

  static setRoute() => '/profile_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF433878),
        title: Image.asset(
          'images/lu_assist_logo.png',
          height: 50,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.blue.shade100,
                      child: ClipOval(
                        child: Image.asset(
                          'images/user_image.png',
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.camera_alt_outlined, color: Colors.blue),
                      onPressed: () {
                        // Add functionality for uploading a profile picture
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),

              // Name
              _buildLabel("Name"),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),

              // ID
              _buildLabel("ID"),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),

              // Batch and Section
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Batch"),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Section"),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Department Dropdown
              _buildLabel("Department"),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                dropdownColor: Colors.white, // Set dropdown background color
                items: [
                  DropdownMenuItem(
                    child: Text('CSE', style: TextStyle(color: Colors.black)),
                    value: 'CSE',
                  ),
                  DropdownMenuItem(
                    child: Text('EEE', style: TextStyle(color: Colors.black)),
                    value: 'EEE',
                  ),
                  DropdownMenuItem(
                    child: Text('BBA', style: TextStyle(color: Colors.black)),
                    value: 'BBA',
                  ),
                  DropdownMenuItem(
                    child: Text('Civil', style: TextStyle(color: Colors.black)),
                    value: 'Civil',
                  ),
                  DropdownMenuItem(
                    child: Text('Islamis Studies', style: TextStyle(color: Colors.black)),
                    value: 'Islamis Studies',
                  ),
                  DropdownMenuItem(
                    child: Text('Architecture', style: TextStyle(color: Colors.black)),
                    value: 'Architecture',
                  ),
                  DropdownMenuItem(
                    child: Text('English', style: TextStyle(color: Colors.black)),
                    value: 'English',
                  ),
                ],
                onChanged: (value) {},
              ),
              SizedBox(height: 12),

              // Bus Route Dropdown
              _buildLabel("Bus Route"),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                dropdownColor: Colors.white, // Set dropdown background color
                items: [
                  DropdownMenuItem(
                    child: Text('Route 1', style: TextStyle(color: Colors.black)),
                    value: 'Route 1',
                  ),
                  DropdownMenuItem(
                    child: Text('Route 2', style: TextStyle(color: Colors.black)),
                    value: 'Route 2',
                  ),
                  DropdownMenuItem(
                    child: Text('Route 3', style: TextStyle(color: Colors.black)),
                    value: 'Route 3',
                  ),
                  DropdownMenuItem(
                    child: Text('Route 4', style: TextStyle(color: Colors.black)),
                    value: 'Route 4',
                  )
                ],
                onChanged: (value) {},
              ),
              SizedBox(height: 12),

              // Save Changes Button
              ElevatedButton(
                onPressed: () {
                  // Add functionality for saving changes
                },
                child: Text(
                  'Save changes',
                  style: TextStyle(fontSize: 16.0),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF433878),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable Label Widget
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
