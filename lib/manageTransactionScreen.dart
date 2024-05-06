import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'transaction.dart';

class TransactionListWidget extends StatefulWidget {
  final String email;

  TransactionListWidget({required this.email});

  @override
  _TransactionListWidgetState createState() => _TransactionListWidgetState();
}

class _TransactionListWidgetState extends State<TransactionListWidget> {
  late Future<List<MyTransaction>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _transactionsFuture = getTransactionsFromFirestore();
  }

  Future<List<MyTransaction>> getTransactionsFromFirestore() async {
    try {
      CollectionReference transactionsRef =
      FirebaseFirestore.instance.collection('Transactions');
      QuerySnapshot querySnapshot = await transactionsRef
          .where('uid', isEqualTo: widget.email)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _navigateToAddTransactionScreen();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<MyTransaction>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<MyTransaction> transactions = snapshot.data ?? [];
            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Transaction Options'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                GestureDetector(
                                  child: Text('Edit'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _editTransaction(transactions[index]);
                                  },
                                ),
                                Padding(padding: EdgeInsets.all(8.0)),
                                GestureDetector(
                                  child: Text('Delete'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    _deleteTransaction(transactions[index]);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: ListTile(
                    title: Text(transactions[index].description),
                    subtitle: Text(
                        '${transactions[index].category} - \$${transactions[index].value.toStringAsFixed(2)}'),
                    trailing: Text('${transactions[index].time.toString()}'),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddTransactionScreen();
        },
        backgroundColor: Color(0xff3a57e8),
        child: Icon(Icons.add),
      ),
    );
  }

  void _editTransaction(MyTransaction transaction) async {
    final updatedTransaction = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTransactionScreen(transaction: transaction),
      ),
    );

    if (updatedTransaction != null) {
      setState(() {
        // Implement logic to update transaction in Firestore here if needed
      });
    }
  }

  void _navigateToAddTransactionScreen() async {
    final newTransaction = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTransactionScreen(),
      ),
    );

    if (newTransaction != null) {
      // Handle the new transaction returned from AddTransactionScreen
      // You may want to add it to your list of transactions or perform any other action
    }
  }

  void _deleteTransaction(MyTransaction transaction) async {
    // Implement deletion logic here
  }
}

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  late TextEditingController _valueController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController();
    _descriptionController = TextEditingController();
    _valueController = TextEditingController();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _valueController,
              decoration: InputDecoration(labelText: 'Value'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 12.0),
            ListTile(
              title: Text('Date'),
              subtitle: Text('${_selectedDate.toString()}'),
              onTap: () {
                _showDatePicker();
              },
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                _saveTransaction();
              },
              child: Text('Save Transaction'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveTransaction() {
    // Retrieve input values
    String category = _categoryController.text;
    String description = _descriptionController.text;
    double value = double.tryParse(_valueController.text) ?? 0.0;

    // Create a new transaction object
    MyTransaction newTransaction = MyTransaction(
      category: category,
      description: description,
      value: value,
      time: _selectedDate,
      uid: UniqueKey().toString(), // Generating a unique id for the transaction
    );

    // Pass the new transaction back to the previous screen
    Navigator.pop(context, newTransaction);
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _descriptionController.dispose();
    _valueController.dispose();
    super.dispose();
  }
}

class EditTransactionScreen extends StatefulWidget {
  final MyTransaction transaction;

  EditTransactionScreen({required this.transaction});

  @override
  _EditTransactionScreenState createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  late TextEditingController _valueController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with transaction details
    _categoryController =
        TextEditingController(text: widget.transaction.category);
    _descriptionController =
        TextEditingController(text: widget.transaction.description);
    _valueController =
        TextEditingController(text: widget.transaction.value.toString());
    _selectedDate = widget.transaction.time;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _valueController,
              decoration: InputDecoration(labelText: 'Value'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 12.0),
            ListTile(
              title: Text('Date'),
              subtitle: Text('${_selectedDate.toString()}'),
              onTap: () {
                _showDatePicker();
              },
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // Save changes and pop the screen
                _saveChanges();
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveChanges() {
    // Parse the updated values
    String updatedCategory = _categoryController.text;
    String updatedDescription = _descriptionController.text;
    double updatedValue = double.tryParse(_valueController.text) ?? 0.0;

    // Create a new transaction object with updated values
    MyTransaction updatedTransaction = MyTransaction(
      category: updatedCategory,
      description: updatedDescription,
      value: updatedValue,
      time: _selectedDate, // Use the selected time
      uid: widget.transaction.uid,
    );

    // Pass the updated transaction back to the previous screen
    Navigator.pop(context, updatedTransaction);
  }

  @override
  void dispose() {
    // Dispose controllers
    _categoryController.dispose();
    _descriptionController.dispose();
    _valueController.dispose();
    super.dispose();
  }
}
