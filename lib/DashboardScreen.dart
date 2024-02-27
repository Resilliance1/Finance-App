import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'MyAccountScreen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff3a57e8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: Text(
          "Home",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 20,
            color: Color(0xfff9f9f9),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Color(0xffffffff), size: 22),
            onPressed: () {
            },
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 16, 0),
            child: IconButton(
              icon: Icon(Icons.dashboard, color: Color(0xffffffff), size: 22),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyAccountScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Account Balance Over Time",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                child: LineChart(
                  LineChartData(), // Add LineChartData here
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Expense Distribution",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                height: 500,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        color: Colors.blue,
                        value: 40, // Sample value
                        title: 'Food', // Sample label
                        radius: 175,
                      ),
                      PieChartSectionData(
                        color: Colors.green,
                        value: 30, // Sample value
                        title: 'Transport', // Sample label
                        radius: 175,
                      ),
                      PieChartSectionData(
                        color: Colors.red,
                        value: 20, // Sample value
                        title: 'Housing', // Sample label
                        radius: 175,
                      ),
                      PieChartSectionData(
                        color: Colors.orange,
                        value: 10, // Sample value
                        title: 'Entertainment', // Sample label
                        radius: 175,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality for floating action button here
        },
        backgroundColor: Color(0xff3a57e8),
        child: Icon(Icons.add),
      ),
    );
  }
}
