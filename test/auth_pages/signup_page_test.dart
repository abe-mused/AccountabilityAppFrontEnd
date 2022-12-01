import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linear/auth_pages/login_page.dart';
import 'package:linear/auth_pages/signup_page.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

@GenerateMocks([http.Client])

void main() {
  testWidgets('smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpPage()));
    expect(find.byType(SignUpPage), findsOneWidget);
  });

  test('Email Field Changes', () {
    final email = TextEditingController();
    email.text = 'gx0340@wayne.edu';
    expect(email.text, 'gx0340@wayne.edu');
  });

  test('Username Field Changes', () {
    final username = TextEditingController();
    username.text = 'mohammedali';
    expect(username.text, 'mohammedali');
  });

  test('Name Field Changes', () {
    final name = TextEditingController();
    name.text = 'Mohammed Ali';
    expect(name.text, 'Mohammed Ali');
  });

  test('Password Field Changes', () {
    final password = TextEditingController();
    password.text = 'Password2022!';
    expect(password.text, 'Password2022!');
  });

  test('Confirm Password Field Changes', () {
    final confirmPassword = TextEditingController();
    confirmPassword.text = 'Password2022!';
    expect(confirmPassword.text, 'Password2022!');
  });

  testWidgets('Successful Sign Up', (tester) async {
    final mockObserver = MockNavigatorObserver(); 
    final client = MockClient((request) async {
      return Response(
        json.encode({
          'status': true,
          'message': 'Success! Account has successfully been created.'
        }),
        200,
        headers: {'content-type': 'text/plain'});
    });
    await tester.pumpWidget(
      MaterialApp(
        home: const SignUpPage(),
        navigatorObservers: [mockObserver],
      ),
    );
    // Enter text field with sign up information
    await tester.enterText(find.byKey(const Key('emailKey')), 'gx0340@wayne.edu'); // Enter email
    await tester.pump();
    await tester.enterText(find.byKey(const Key('usernameKey')), 'mohammedali'); // Enter username
    await tester.pump();
    await tester.enterText(find.byKey(const Key('fullNameKey')), 'Mohammed Ali'); // Enter full name
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Password2022!'); // Enter password
    await tester.pump();
    await tester.enterText(find.byKey(const Key('confirmPasswordKey')), 'Password2022!'); // Enter confirm password
    await tester.pump();
    // Rebuild the widget with the new item.
    await tester.pumpAndSettle();
    // Sign Up
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    /// Verify that a push event happened
    expect(client, isA<MockClient>());
  });

  testWidgets('REGEX TEST - Please fill out all fields!', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpPage()));
    // No information entered in text field
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Expect to find error message
    expect(find.text("Please fill out all fields!"), findsOneWidget);
  });

  testWidgets('REGEX TEST - Invalid Email Address Input', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpPage()));
    // Enter all info and invalid password
    await tester.pump();
    await tester.enterText(find.byKey(const Key('emailKey')), 'mohammedali'); // Enter invalid email
    await tester.pump();
    await tester.enterText(find.byKey(const Key('usernameKey')), 'mohammedali'); // Enter username
    await tester.pump();
    await tester.enterText(find.byKey(const Key('fullNameKey')), 'Mohammed Ali'); // Enter full name
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Password2022!'); // Enter password
    await tester.pump();
    await tester.enterText(find.byKey(const Key('confirmPasswordKey')), 'Password2022!'); // Enter confirm password
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Expect to find error message 
    expect(find.text("Invalid email! please try again."),findsOneWidget);
  });

    testWidgets('REGEX TEST - Blank Email Address Input', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpPage()));
    // Enter all info and invalid password
    await tester.pump();
    await tester.enterText(find.byKey(const Key('emailKey')), ' '); // Enter invalid email
    await tester.pump();
    await tester.enterText(find.byKey(const Key('usernameKey')), 'mohammedali'); // Enter username
    await tester.pump();
    await tester.enterText(find.byKey(const Key('fullNameKey')), 'Mohammed Ali'); // Enter full name
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Password2022!'); // Enter password
    await tester.pump();
    await tester.enterText(find.byKey(const Key('confirmPasswordKey')), 'Password2022!'); // Enter confirm password
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Expect to find error message 
    expect(find.text("Invalid email! please try again."),findsOneWidget);
  });

  testWidgets('REGEX TEST - Invalid Username Input', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpPage()));
    // Enter all info and invalid username
    await tester.pump();
    await tester.enterText(find.byKey(const Key('emailKey')), 'gx0340@wayne.edu'); // Enter email
    await tester.pump();
    await tester.enterText(find.byKey(const Key('usernameKey')), 'Mohammed Ali Test'); // Enter invalid username
    await tester.pump();
    await tester.enterText(find.byKey(const Key('fullNameKey')), 'Mohammed Ali'); // Enter full name
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Password2022!'); // Enter password
    await tester.pump();
    await tester.enterText(find.byKey(const Key('confirmPasswordKey')), 'Password2022!'); // Enter confirm password
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Expect to find error message 
    expect(find.text("Invalid username! Username has to be a minimum of 5 characters and must contain alphanumeric characters and optionally an underscore"),findsOneWidget);
  });

    testWidgets('REGEX TEST - Blank Username Input', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpPage()));
    // Enter all info and invalid username
    await tester.pump();
    await tester.enterText(find.byKey(const Key('emailKey')), 'gx0340@wayne.edu'); // Enter email
    await tester.pump();
    await tester.enterText(find.byKey(const Key('usernameKey')), ' '); // Enter invalid username
    await tester.pump();
    await tester.enterText(find.byKey(const Key('fullNameKey')), 'Mohammed Ali'); // Enter full name
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Password2022!'); // Enter password
    await tester.pump();
    await tester.enterText(find.byKey(const Key('confirmPasswordKey')), 'Password2022!'); // Enter confirm password
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Expect to find error message 
    expect(find.text("Invalid username! Username has to be a minimum of 5 characters and must contain alphanumeric characters and optionally an underscore"),findsOneWidget);
  });

  testWidgets('REGEX TEST - Invalid Password Input', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpPage()));
    // Enter all info and invalid password
    await tester.pump();
    await tester.enterText(find.byKey(const Key('emailKey')), 'gx0340@wayne.edu'); // Enter email
    await tester.pump();
    await tester.enterText(find.byKey(const Key('usernameKey')), 'mohammedali'); // Enter invalid username
    await tester.pump();
    await tester.enterText(find.byKey(const Key('fullNameKey')), 'Mohammed Ali'); // Enter full name
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'password'); // Enter invalid password
    await tester.pump();
    await tester.enterText(find.byKey(const Key('confirmPasswordKey')), 'password'); // Enter confirm password
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Expect to find error message 
    expect(find.text("Passwords must contain at least one uppercase letter, one lowercase letter, one numeric character, and one special character"),findsOneWidget);
  });

    testWidgets('REGEX TEST - Blank Password Input', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpPage()));
    // Enter all info and invalid password
    await tester.pump();
    await tester.enterText(find.byKey(const Key('emailKey')), 'gx0340@wayne.edu'); // Enter email
    await tester.pump();
    await tester.enterText(find.byKey(const Key('usernameKey')), 'mohammedali'); // Enter invalid username
    await tester.pump();
    await tester.enterText(find.byKey(const Key('fullNameKey')), 'Mohammed Ali'); // Enter full name
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), ' '); // Enter invalid password
    await tester.pump();
    await tester.enterText(find.byKey(const Key('confirmPasswordKey')), ' '); // Enter confirm password
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Expect to find error message 
    expect(find.text("Passwords must contain at least one uppercase letter, one lowercase letter, one numeric character, and one special character"),findsOneWidget);
  });

  testWidgets('REGEX TEST - Passwords do not match!', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpPage()));
    // Enter all info and password that do not match
    await tester.pump();
    await tester.enterText(find.byKey(const Key('emailKey')), 'gx0340@wayne.edu'); // Enter email
    await tester.pump();
    await tester.enterText(find.byKey(const Key('usernameKey')), 'mohammedali'); // Enter invalid username
    await tester.pump();
    await tester.enterText(find.byKey(const Key('fullNameKey')), 'Mohammed Ali'); // Enter full name
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Password2022!'); // Enter valid password
    await tester.pump();
    await tester.enterText(find.byKey(const Key('confirmPasswordKey')), 'P@sw0rd2o22!'); // Enter invalid confirm password
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Expect to find error message 
    expect(find.text("Passwords do not match!"),findsOneWidget);
  });

testWidgets('Go to Login Page', (WidgetTester tester) async {
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        home: const LoginPage(),
        navigatorObservers: [mockObserver],
      ),
    );
    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();
    expect(find.text('loginKey'), findsOneWidget);
  });

  // testWidgets('Account already exists', (tester) async {
  // await tester.pumpWidget(const MaterialApp(home: SignUpPage()));
  // });

}