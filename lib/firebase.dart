// Import the Encrypt library
import 'package:encrypt/encrypt.dart' as encrypt;

// Define the main function
void main() {
  // Define the encryption key and initialization vector (IV)
  final key = encrypt.Key.fromUtf8('1234567890123456'); // Replace with your 64-bit encryption key
  final iv = encrypt.IV.fromLength(16);

  // Define sample data
  String accountId = "unique_account_id";
  String email = "user@example.com";
  String password = "password123";
  String fname = "John";
  String lname = "Doe";
  double amount = 1000;
  String currency = "USD";

  // Encrypt sample data
  String encryptedEmail = encryptData(email, key, iv);
  String encryptedPassword = encryptData(password, key, iv);
  String encryptedFname = encryptData(fname, key, iv);
  String encryptedLname = encryptData(lname, key, iv);
  String encryptedAmount = encryptData(amount.toString(), key, iv);
  String encryptedCurrency = encryptData(currency, key, iv);

  // Update database with encrypted data
  updateDatabase(accountId, encryptedEmail, encryptedPassword, encryptedFname, encryptedLname, encryptedAmount, encryptedCurrency);

  // Retrieve and decrypt data from the database
  retrieveData(accountId, key, iv);
}

// Function to encrypt data
String encryptData(String data, encrypt.Key key, encrypt.IV iv) {
  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  final encrypted = encrypter.encrypt(data, iv: iv);
  return encrypted.base64;
}

// Function to decrypt data
String decryptData(String encryptedString, encrypt.Key key, encrypt.IV iv) {
  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  final decrypted = encrypter.decrypt64(encryptedString, iv: iv);
  return decrypted;
}

// Function to update database with encrypted data
void updateDatabase(String accountId, String email, String password, String fname, String lname, String amount, String currency) {
  // In a real application, you would store this encrypted data securely in a database or file.
  Map<String, dynamic> encryptedData = {
    'email': email,
    'password': password,
    'fname': fname,
    'lname': lname,
    'amount': amount,
    'currency': currency,
  };
  print('Updated Database: $encryptedData');
}

// Function to retrieve and decrypt data from the database
void retrieveData(String accountId, encrypt.Key key, encrypt.IV iv) {
  // In a real application, you would retrieve encrypted data from your database.
  // Here, we simulate decryption of previously encrypted data.
  Map<dynamic, dynamic> encryptedData = {
    'email': 'encrypted_email_string',
    'password': 'encrypted_password_string',
    'fname': 'encrypted_fname_string',
    'lname': 'encrypted_lname_string',
    'amount': 'encrypted_amount_string',
    'currency': 'encrypted_currency_string',
  };

  String email = decryptData(encryptedData['email'], key, iv);
  String password = decryptData(encryptedData['password'], key, iv);
  String fname = decryptData(encryptedData['fname'], key, iv);
  String lname = decryptData(encryptedData['lname'], key, iv);
  String amount = decryptData(encryptedData['amount'], key, iv);
  String currency = decryptData(encryptedData['currency'], key, iv);

  // Print decrypted data
  print('Retrieved Data:');
  print('Email: $email');
  print('Password: $password');
  print('First Name: $fname');
  print('Last Name: $lname');
  print('Amount: $amount');
  print('Currency: $currency');
}