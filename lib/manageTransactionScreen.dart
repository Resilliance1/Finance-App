import 'package:flutter/material.dart';
import 'transaction.dart';

class TransactionListWidget extends StatefulWidget {
  final List<Transaction> transactions;

  TransactionListWidget({required this.transactions});

  @override
  _TransactionListWidgetState createState() => _TransactionListWidgetState();
}

class _TransactionListWidgetState extends State<TransactionListWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction List'),
      ),
      body: ListView.builder(
        itemCount: widget.transactions.length,
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
                              _editTransaction(index); // Call edit function
                            },
                          ),
                          Padding(padding: EdgeInsets.all(8.0)),
                          GestureDetector(
                            child: Text('Delete'),
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                widget.transactions.removeAt(index);
                              });
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
              title: Text(widget.transactions[index].description),
              subtitle: Text('${widget.transactions[index].category} - \$${widget.transactions[index].value.toStringAsFixed(2)}'),
              trailing: Text('${widget.transactions[index].time.toString()}'),
            ),
          );
        },
      ),
    );
  }
  void _editTransaction(int index) async {
    final updatedTransaction = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTransactionScreen(transaction: widget.transactions[index]),
      ),
    );

    if (updatedTransaction != null) {
      setState(() {
        widget.transactions[index] = updatedTransaction;
      });
    }
  }
}

class EditTransactionScreen extends StatefulWidget {
  final Transaction transaction;

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
    _categoryController = TextEditingController(text: widget.transaction.category);
    _descriptionController = TextEditingController(text: widget.transaction.description);
    _valueController = TextEditingController(text: widget.transaction.value.toString());
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
    Transaction updatedTransaction = Transaction(
      updatedCategory,
      updatedDescription,
      updatedValue,
      _selectedDate, // Use the selected date
      widget.transaction.uid,
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