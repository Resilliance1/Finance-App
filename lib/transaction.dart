class Transaction {
  String category;
  String description;
  double value;
  DateTime time;
  String uid;

  Transaction(this.category, this.description, this.value, this.time,this.uid);

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
}