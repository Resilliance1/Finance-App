import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections = [
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
    ];

    // Sample line chart data
    List<FlSpot> lineChartData = [
      FlSpot(0, 10),
      FlSpot(1, 15),
      FlSpot(2, 12),
      FlSpot(3, 14),
      FlSpot(4, 10),
    ];

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
              // Add your search functionality here
            },
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 16, 0),
            child: IconButton(
              icon: Icon(Icons.dashboard, color: Color(0xffffffff), size: 22),
              onPressed: () {
                // Add your dashboard functionality here
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
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: lineChartData,
                        isCurved: true,
                        colors: [Colors.blue],
                        barWidth: 4,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: SideTitles(showTitles: false),
                      bottomTitles: SideTitles(showTitles: false),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: const Color(0xff37434d),
                        width: 1,
                      ),
                    ),
                  ),
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
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 500,
                      child: ListView.builder(
                        itemCount: sections.length,
                        itemBuilder: (BuildContext context, int index) {
                          final section = sections[index];
                          return ListTile(
                            leading: Icon(
                              Icons.circle,
                              color: section.color,
                            ),
                            title: Text(
                              section.title,
                              style: TextStyle(
                                color: section.color,
                              ),
                            ),
                            trailing: Text(
                              '\$${section.value.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 500,
                      child: PieChart(
                        PieChartData(
                          sections: sections,
                        ),
                      ),
                    ),
                  ),
                ],
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
