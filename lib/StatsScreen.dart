import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';


class StatsScreen extends StatefulWidget {
  final String email;

  StatsScreen({required this.email});

  @override
  _StatsScreenState createState() => _StatsScreenState(email: email);
}

class _StatsScreenState extends State<StatsScreen> {
  final String email;

  _StatsScreenState({required this.email});

  List<MyTransaction> transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    List<MyTransaction> loadedTransactions =
    await getTransactionsFromFirestore();
    await updateData(loadedTransactions);
  }

  Future<void> updateData(List<MyTransaction> updatedTransactions) async {
    if (updatedTransactions.isEmpty) {
      // Clear existing data if no transactions are available
      setState(() {
        transactions.clear();
      });
      return;
    }

    setState(() {
      transactions = updatedTransactions;
    });
  }

  Future<List<MyTransaction>> getTransactionsFromFirestore() async {
    try {
      CollectionReference transactionsRef =
      FirebaseFirestore.instance.collection('Transactions');
      QuerySnapshot querySnapshot =
      await transactionsRef.where('uid', isEqualTo: email).get();
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
          "Resilience",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 20,
            color: Color(0xfff9f9f9),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.offAllNamed('/settings', arguments: email);
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'This Year',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Check if transactions list is empty
            transactions.isEmpty
                ? Center(
              child: Text(
                'No data',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
                : Center(
              child: Container(
                width: 600, // Adjust width as needed
                height: 500, // Adjust height as needed
                child: ThisYear(transactions: transactions),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
              onPressed: () {
                Get.offAllNamed('/dashboard', arguments: email);
              },
              backgroundColor: Colors.grey,
              child: Icon(Icons.trending_up),
            ),
            FloatingActionButton(
              onPressed: () {
                Get.offAllNamed('/edit', arguments: email);
              },
              backgroundColor: Color(0xff3a57e8),
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}


class ThisYear extends StatelessWidget {
  final List<MyTransaction> transactions;

  ThisYear({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return YearBarChart(transactions: transactions);
  }
}

class YearBarChart extends StatelessWidget {
  final List<MyTransaction> transactions;

  YearBarChart({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => const TextStyle(color: Colors.black),
            margin: 10,
            getTitles: (double value) {
              // Display month names on the x-axis
              final months = [
                'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
              ];
              final currentMonth = DateTime
                  .now()
                  .month;
              if (value.toInt() >= 0 && value.toInt() <= currentMonth) {
                return months[value.toInt()];
              }
              return '';
            },
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => const TextStyle(color: Colors.black),
            margin: 10,
            getTitles: (double value) {
              if (value % 50 == 0) {
                return value.toInt().toString();
              } else {
                return '';
              }
            },
          ),
        ),
        borderData: FlBorderData(show: true),
        barGroups: generateBarGroups(),
      ),
    );
  }

  List<BarChartGroupData> generateBarGroups() {
    // Initialize bar groups list
    final List<BarChartGroupData> barGroups = [];

    // Initialize lists to hold positive and negative transaction amounts for each month
    final List<double> positiveAmounts = List.filled(12, 0);
    final List<double> negativeAmounts = List.filled(12, 0);

    // Filter out erroneous transactions
    final validTransactions = transactions.where((transaction) =>
    transaction.time.month >= 1 &&
        transaction.time.month <= 12);

    // Calculate positive and negative transaction amounts for each month
    for (var transaction in validTransactions) {
      final month = transaction.time.month;
      if (transaction.value >= 0) {
        positiveAmounts[month - 1] += transaction.value;
      } else {
        negativeAmounts[month - 1] += transaction.value.abs();
      }
    }

    // Get the current month
    final currentMonth = DateTime
        .now()
        .month;

    // Add bar data for each month
    for (int i = 0; i <= currentMonth; i++) {
      final List<BarChartRodData> barRods = [
        BarChartRodData(
          y: positiveAmounts[i],
          colors: [Colors.green], // Positive transactions color
          width: 16,
        ),
        BarChartRodData(
          y: negativeAmounts[i],
          colors: [Colors.red], // Negative transactions color
          width: 16,
        ),
      ];

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: barRods,
        ),
      );
    }

    return barGroups;
  }
}
