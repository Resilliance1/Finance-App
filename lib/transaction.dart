import 'dart:math';

class MyTransaction {
  String category;
  String description;
  double value;
  DateTime time;
  String uid;
  late String transactionID = '';

  MyTransaction({
    required this.category,
    required this.description,
    required this.value,
    required this.time,
    required this.uid,
  }) {
    // Generate a random string for transactionID, "composite key", random string + user email
    // Probably not best practice but this so it's easier to update and delete records
    String randomString = _generateRandomString(10);
    transactionID = '$randomString-$uid';
  }

  // Function to generate a random string of a given length
  String _generateRandomString(int length) {
    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
  }

  String getCategory() {
    return category;
  }

  void setCategory(String newCategory) {
    category = newCategory;
  }

  String getDescription() {
    return description;
  }

  void setDescription(String newDescription) {
    description = newDescription;
  }

  String getUid() {
    return uid;
  }

  void setUid(String newUid) {
    uid = newUid;
  }

  double getValue() {
    return value;
  }

  void setValue(double newValue) {
    value = newValue;
  }

  DateTime getTime() {
    return time;
  }

  void setTime(DateTime newTime) {
    time = newTime;
  }

  void setTransactionID(String ID){
    transactionID = ID;
  }

  // Function to map a transaction for use in storing in db
  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'description': description,
      'value': value,
      'time': time.toIso8601String(),
      'uid': uid,
      'transactionID': transactionID,
    };
  }

  // Constructor for creating Transaction from map for loading from db
  factory MyTransaction.fromMap(Map<String, dynamic> map) {
    return MyTransaction(
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      value: map['value'] != null ? map['value'].toDouble() : 0.0,
      time: DateTime.tryParse(map['time'] ?? '') ?? DateTime.now(),
      uid: map['uid'] ?? '',
    )..transactionID = map['transactionID'] ?? '';
  }
}
