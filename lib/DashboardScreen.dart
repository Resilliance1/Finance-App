import 'package:flutter/material.dart';
import 'transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  final String email;

  DashboardScreen({required this.email});
  @override
  _DashboardScreenState createState() => _DashboardScreenState(email: email);
}

class _DashboardScreenState extends State<DashboardScreen> {
  final String email;
  late int userBudget; // Variable to store user's budget
  List<MyTransaction> transactions = [];

  _DashboardScreenState({required this.email});

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    _fetchUserBudget(); // Fetch user's budget when the screen initializes
  }

  double calculateTotalBalance(List<MyTransaction> transactions) {
    double totalBalance = transactions.fold(
        0.0, (sum, transaction) => sum + transaction.getValue());
    return double.parse(totalBalance.toStringAsFixed(2));
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

  // Todo use firestore retrieve transactions // Done
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

// Fetch user's budget from Firestore
  Future<void> _fetchUserBudget() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where("email", isEqualTo: email)
          .get();

      // Check if any documents are returned
      if (querySnapshot.docs.isNotEmpty) {
        // Access the first document in the snapshot
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

        // Get the value of the "budget" field from the document
        String budgetString = documentSnapshot.get('Budget');

        // Convert the budget string to an integer
        userBudget = int.parse(budgetString);
        print(userBudget);

        // Check the number of transactions
        int numberOfTransactions = transactions.length;

        // Check if user has more than 5 transactions
        if (numberOfTransactions > 5) {
          // Check if user's balance is nearing the budget
          double totalBalance = calculateTotalBalance(transactions);
          print(totalBalance);
          if (calculateTotalBalance(transactions) <= userBudget * 1.3) {
            _showBudgetnearSnackbar();
          } else if (calculateTotalBalance(transactions) == userBudget) {
            _showBudgetreachedSnackbar();
          } else if (calculateTotalBalance(transactions) < userBudget) {
            _showBudgetbelowSnackbar();
          }
        } else {
          print('User has less than 5 transactions.');
        }
      } else {
        print('No documents found for the email: $email');
      }
    } catch (e) {
      print("Error fetching user's budget: $e");
    }
  }

  // Methods to show snackbar notification
  void _showBudgetnearSnackbar() {
    Get.snackbar(
      'Budget Alert',
      'Your balance is nearing your budget!',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void _showBudgetreachedSnackbar() {
    Get.snackbar(
      'Budget Alert',
      'Your balance at your budget!',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void _showBudgetbelowSnackbar() {
    Get.snackbar(
      'Budget Alert',
      'Your balance is lower than your budget',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void _editTransactionsList(List<MyTransaction> transactions) async {
    final updatedTransactionList =
        await Get.offAllNamed('/edit', arguments: email);
    if (updatedTransactionList != null) {
      setState(() {});
      _loadTransactions();
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
              _navigateSettings(email: email);
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            if (transactions.isNotEmpty)
              Center(
                child: Text(
                  "Your Current Balance\n\£${calculateTotalBalance(transactions)}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
            SizedBox(height: 20),
            Center(
              child: Container(
                height: 200,
                child: RecentListWidget(transactions: transactions),
              ),
            ),
            SizedBox(height: 10),
            if (transactions.isEmpty)
              Center(
                child: Text(
                  "No transactions - Press the '+' button!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
              onPressed: () {
                Get.offAllNamed('/stats', arguments: email);
              },
              backgroundColor: Colors.grey,
              child: Icon(Icons.trending_up),
            ),
            FloatingActionButton(
              onPressed: () {
                _editTransactionsList(transactions);
              },
              backgroundColor: Color(0xff3a57e8),
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateSettings({required String email}) {
    Get.offAllNamed('/settings', arguments: email);
  }
}

class RecentListWidget extends StatelessWidget {
  final List<MyTransaction> transactions;

  RecentListWidget({required this.transactions});

  @override
  Widget build(BuildContext context) {
    // order transactions put last 5 in list widget
    // Sort transactions by time in descending order
    transactions.sort((a, b) => b.time.compareTo(a.time));

    List<MyTransaction> recentTransactions = transactions.take(10).toList();

    return ListView.builder(
      itemCount: recentTransactions.length,
      itemBuilder: (context, index) {
        MyTransaction transaction = recentTransactions[index];
        return ListTile(
          title: Text(
              "£${transaction.value} - ${transaction.description} - ${transaction.category}"),
        );
      },
    );
  }
}
