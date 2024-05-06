import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ResillianceFinance/LoginScreen.dart';
import 'package:ResillianceFinance/DashboardScreen.dart';
import 'package:ResillianceFinance/RegisterScreen.dart';

void main() {
  testWidgets('Login screen UI test', (WidgetTester tester) async {

    await tester.pumpWidget(MaterialApp(
      home: LoginScreen(),
    ));


    final signInButtonFinder = find.text('Login');
    final signUpButtonFinder = find.text('Sign Up');
    final emailTextFieldFinder = find.byType(TextField).first;
    final passwordTextFieldFinder = find.byType(TextField).last;


    expect(signInButtonFinder, findsOneWidget);
    expect(signUpButtonFinder, findsOneWidget);
    expect(emailTextFieldFinder, findsOneWidget);
    expect(passwordTextFieldFinder, findsOneWidget);


    await tester.tap(signInButtonFinder);
    await tester.pumpAndSettle();
    expect(find.byType(DashboardScreen), findsOneWidget);
  });
  testWidgets('RegisterScreen should register a user', (WidgetTester tester) async {
    // Build our widget
    await tester.pumpWidget(MaterialApp(
      home: RegisterScreen(),
    ));

    // Find text fields and buttons
    final firstNameField = find.byWidgetPredicate((widget) =>
    widget is TextField && widget.decoration?.labelText == "First Name");
    final lastNameField = find.byWidgetPredicate((widget) =>
    widget is TextField && widget.decoration?.labelText == "Last Name");
    final emailField = find.byWidgetPredicate((widget) =>
    widget is TextField && widget.decoration?.labelText == "Email");
    final passwordField = find.byWidgetPredicate((widget) =>
    widget is TextField && widget.decoration?.labelText == "Password");
    final confirmPasswordField = find.byWidgetPredicate((widget) =>
    widget is TextField && widget.decoration?.labelText == "Confirm Password");
    final budgetField = find.byWidgetPredicate((widget) =>
    widget is TextField && widget.decoration?.labelText == "Your budget");
    final signUpButton = find.text("Sign Up");

    // Enter text into text fields
    await tester.enterText(firstNameField, 'John');
    await tester.enterText(lastNameField, 'Doe');
    await tester.enterText(emailField, 'john.doe@example.com');
    await tester.enterText(passwordField, 'password');
    await tester.enterText(confirmPasswordField, 'password');
    await tester.enterText(budgetField, '1000');

    // Simulate tapping the Sign Up button
    await tester.tap(signUpButton);
    await tester.pumpAndSettle();

    // Verify that navigation to LoginScreen happened
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}

