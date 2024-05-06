import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'MyAccountScreen.dart';
import 'manageTransactionScreen.dart';
import 'transaction.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardScreen extends StatefulWidget {
  final String email;

  DashboardScreen({required this.email});
  @override
  _DashboardScreenState createState() => _DashboardScreenState(email:email);
}

class _DashboardScreenState extends State<DashboardScreen> {
  final String email;

  _DashboardScreenState({required this.email});
  List<MyTransaction> transactions = [];
  List<PieChartSectionData> sections = [];
  List<FlSpot> lineChartData = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }
  Future<void> _loadTransactions() async {
    List<MyTransaction> loadedTransactions = await getTransactionsFromFirestore();
    updateData(loadedTransactions);
  }

  Future<void> updateData(List<MyTransaction> updatedTransactions) async {

    double totalValue = updatedTransactions.fold(0.0, (sum, transaction) => sum + transaction.getValue());

    List<PieChartSectionData> updatedSections = updatedTransactions.map((transaction) {
      double percentage = (transaction.getValue() / totalValue) * 100;
      return PieChartSectionData(
        color: generateRandomColor(),
        value: percentage,
        title: transaction.getCategory(),
        radius: 175,
      );
    }).toList();

    List<FlSpot> updatedLineChartData = convertTransactionsToLineChartData(updatedTransactions);

    setState(() {
      transactions = updatedTransactions;
      sections = updatedSections;
      lineChartData = updatedLineChartData;
    });
  }
// Todo use firestore or something to store and retrieve transactions
  Future<List<MyTransaction>> getTransactionsFromFirestore() async {
    try {
      CollectionReference transactionsRef =
      FirebaseFirestore.instance.collection('Transactions');
      QuerySnapshot querySnapshot = await transactionsRef
          .where('uid', isEqualTo: email)
          .get();
      List<MyTransaction> transactions = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return MyTransaction.fromMap(data);
      }).toList();
      return transactions;
    } catch (e) {
      print("Error getting transactions: $e");
      return [];
    }
  }

  List<PieChartSectionData> convertTransactionsToPieData(List<MyTransaction> transactions) {
    double totalValue = transactions.fold(0.0, (sum, transaction) => sum + transaction.getValue());

    List<PieChartSectionData> pieChartSections = transactions.map((transaction) {
      double percentage = (transaction.getValue() / totalValue) * 100;
      return PieChartSectionData(
        color: generateRandomColor(),
        value: percentage,
        title: transaction.getCategory(),
        radius: 175,
      );
    }).toList();

    return pieChartSections;
  }

  List<FlSpot> convertTransactionsToLineChartData(List<MyTransaction> transactions) {
    List<FlSpot> lineChartData = [];

    for (int i = 0; i < transactions.length; i++) {
      // Use the transaction's time as the x-coordinate
      // and the value as the y-coordinate
      lineChartData.add(FlSpot(transactions[i].getTime().millisecondsSinceEpoch.toDouble(), transactions[i].getValue()));
    }

    return lineChartData;
  }

  Color generateRandomColor() {
    return Color.fromRGBO(
      _generateRandomInt(0, 255),
      _generateRandomInt(0, 255),
      _generateRandomInt(0, 255),
      1,
    );
  }

  int _generateRandomInt(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  void _editTransactionsList(List<MyTransaction> transactions) async {
    final updatedTransactionList = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionListWidget(email:email),
      ),
    );

    if (updatedTransactionList != null) {
      setState(() {
        transactions = updatedTransactionList;
      });
      updateData(transactions);
    }
  }

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
            onPressed: () {},
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 16, 0),
            child: IconButton(
              icon: Icon(Icons.dashboard, color: Color(0xffffffff), size: 22),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyAccountScreen(email:email)),
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
          _editTransactionsList(transactions);
        },
        backgroundColor: Color(0xff3a57e8),
        child: Icon(Icons.add),
      ),
    );
  }
}
