class MyTransaction {
  String category;
  String description;
  double value;
  DateTime time;
  String uid;

  MyTransaction(this.category, this.description, this.value, this.time,this.uid);

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
  // Function to map a transaction for use in storing in db
  Map<String, String> toMap() {
    return {
      'category': category,
      'description': description,
      'value': value.toString(),
      'time': time.toString(),
      'uid': uid
    };
  }
  // Constructor for creating Transaction from map for loading from db
  factory MyTransaction.fromMap(Map<String, String> map) {
    return MyTransaction(
      map['category'] ?? '',
      map['description'] ?? '',
      double.tryParse(map['value'] ?? '0.0') ?? 0.0,
      DateTime.tryParse(map['time'] ?? '') ?? DateTime.now(),
      map['uid'] ?? '',
    );
  }
}