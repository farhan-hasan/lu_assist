import 'package:flutter/material.dart';
import 'package:lu_assist/src/core/utils/extension/context_extension.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});
  static const route = '/schedule_screen';

  static setRoute() => '/schedule_screen';
  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF433878),
        title: Image.asset(
          'assets/images/LU_Assist__LOGO.png',
          height: screenSize.height * 0.20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF8B83AA),
               borderRadius: BorderRadius.circular(16),
               boxShadow: [
              BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 8, // How far the shadow spreads
              blurRadius: 7, // Softness of the shadow
              offset: Offset(3, 3), // Position of the shadow (x, y)
            ),
          ],
              ),
              child: TabBar(
                controller: _tabController,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: Color(0xFFC5C1DA),
                  border: Border.all(color: Colors.black),
                  shape: BoxShape.circle,
                ),
                labelPadding: EdgeInsets.all(12),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.transparent,
                      child: Text('1',
                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Tab(
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.transparent,
                      child: Text('2',
                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Tab(
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.transparent,
                      child: Text('3',
                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Tab(
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.transparent,
                      child: Text('4',
                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                ],
                indicatorColor: Colors.transparent,
              ),
            ),
            SizedBox(height: 20),

            // Edit Schedule Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF433878),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                onPressed: () {},
                child: Text(
                  'Edit Schedule',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Time Section
            Expanded(
              child: ListView(
                children: [
                  Text(
                    'Time : 9 am',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Bus Cards
                  _buildBusCard('Bus : 01'),
                  SizedBox(height: 10),
                  _buildBusCard('Bus : 02'),
                ],
              ),
            ),

            SizedBox(height: 10),

            // Bus Cards
            /*Expanded(
              child: ListView(
                children: [
                  _buildBusCard('Bus : 01'),
                  SizedBox(height: 10),
                  _buildBusCard('Bus : 02'),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  Widget _buildBusCard(String busNumber) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF8880A8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/DRBUS.png',
            height: 60,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  busNumber,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    _buildRadioButton('Incoming'),
                    SizedBox(width: 8),
                    _buildRadioButton('Outgoing'),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Color(0xFF433878)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildRadioButton(String label) {
    return Row(
      children: [
        Radio<String>(
          value: label,
          groupValue: _selectedOption,
          activeColor: Color(0xFF433878),
          onChanged: (value) {
            setState(() {
              _selectedOption = value;
            });
          },
        ),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }
}
