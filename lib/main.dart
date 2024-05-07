import 'package:ResillianceFinance/DashboardScreen.dart';
import 'package:ResillianceFinance/RegisterScreen.dart';
import 'package:ResillianceFinance/SettingScreen.dart';
import 'package:ResillianceFinance/manageTransactionScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey:
              "AIzaSyAzaoSTEdlNubxgJEPcnVZbKlPlf9nVD3E", // these lines are what connect it to my firebase account
          appId: "1:998860827066:web:64b8fe8db8f93acecf9583",
          messagingSenderId: "998860827066",
          projectId: "resilience-finance"));
  runApp(GetMaterialApp(
    initialRoute: '/login',
    getPages: [
      GetPage(name: '/login', page: () => LoginScreen()),
      GetPage(
        name: '/dashboard',
        page: () {
          final email = Get.arguments; // Get the email from arguments
          return DashboardScreen(email: email); // Pass the email to DashboardScreen
        }),
      GetPage(
          name: '/edit',
          page: () {
            final email = Get.arguments; // Get the email from arguments
            return TransactionListWidget(email: email); // Pass the email to DashboardScreen
          }),      GetPage(
          name: '/settings',
          page: () {
            final email = Get.arguments; // Get the email from arguments
            return SettingScreen(email: email); // Pass the email to DashboardScreen
          }),
      GetPage(name: '/register', page: () => RegisterScreen()),
    ],
    defaultTransition: Transition.zoom,
  ));
}


