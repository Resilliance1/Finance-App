class Transaction {
  String category;
  String description;
  double value;
  DateTime time;

  Transaction(this.category, this.description, this.value, this.time);

  String getCategory() {
    return category;
  }

  void setCategory(String newGroup) {
    category = newGroup;
  }

  String getDescription() {
    return description;
  }

  void setDescription(String newDescription) {
    description = newDescription;
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