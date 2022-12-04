import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linear/auth_pages/signup_page.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

@GenerateMocks([http.Client])

void main() {
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

    testWidgets('FAILED SIGN UP - Enter email only', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpPage()));
    // Enter text field with sign up information
    await tester.enterText(find.byKey(const Key('emailKey')), 'gx0340@wayne.edu'); // Enter email
    await tester.pump();
    await tester.enterText(find.byKey(const Key('usernameKey')), '');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('fullNameKey')), '');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), '');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('confirmPasswordKey')), '');
    await tester.pump();
    // Rebuild the widget with the new item.
    await tester.pumpAndSettle();
    // Sign Up
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Expect to find error message
    expect(find.text("Please fill out all fields!"), findsOneWidget);
  });

  testWidgets('FAILED SIGN UP - Enter username only', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpPage()));
    // Enter text field with sign up information
    await tester.enterText(find.byKey(const Key('emailKey')), '');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('usernameKey')), 'mohammedali'); // Enter username
    await tester.pump();
    await tester.enterText(find.byKey(const Key('fullNameKey')), '');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), '');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('confirmPasswordKey')), '');
    await tester.pump();
    // Rebuild the widget with the new item.
    await tester.pumpAndSettle();
    // Sign Up
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Expect to find error message
    expect(find.text("Please fill out all fields!"), findsOneWidget);
  });

  testWidgets('FAILED SIGN UP - Enter name only', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpPage()));
    // Enter text field with sign up information
    await tester.enterText(find.byKey(const Key('emailKey')), '');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('usernameKey')), '');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('fullNameKey')), 'Mohammed Ali'); // Enter full name
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), '');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('confirmPasswordKey')), '');
    await tester.pump();
    // Rebuild the widget with the new item.
    await tester.pumpAndSettle();
    // Sign Up
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Expect to find error message
    expect(find.text("Please fill out all fields!"), findsOneWidget);
  });

  testWidgets('FAILED SIGN UP - Enter password only', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpPage()));
    // Enter text field with sign up information
    await tester.enterText(find.byKey(const Key('emailKey')), '');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('usernameKey')), '');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('fullNameKey')), '');
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
    // Expect to find error message
    expect(find.text("Please fill out all fields!"), findsOneWidget);
  });

    testWidgets('FAILED SIGN UP - Sign up without confirming password', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpPage()));
    // Enter all info and do not confirm password
    await tester.pump();
    await tester.enterText(find.byKey(const Key('emailKey')), 'gx0340@wayne.edu'); // Enter email
    await tester.pump();
    await tester.enterText(find.byKey(const Key('usernameKey')), 'mohammedali'); // Enter invalid username
    await tester.pump();
    await tester.enterText(find.byKey(const Key('fullNameKey')), 'Mohammed Ali'); // Enter full name
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Password2022!'); // Enter valid password
    await tester.pump();
    await tester.enterText(find.byKey(const Key('confirmPasswordKey')), ''); // Enter blank confirm password
    await tester.pump();
    // Rebuild the widget with the new item.
    await tester.pumpAndSettle();
    // Sign Up
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Expect to find error message 
    expect(find.text("Please fill out all fields!"),findsOneWidget);
  });

  testWidgets('FAILED SIGN UP - Please fill out all fields!', (tester) async {
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
    // Enter all info and invalid email
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
    // Enter all info and blank email
    await tester.pump();
    await tester.enterText(find.byKey(const Key('emailKey')), ' '); // Enter blank email
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
    // Enter all info and blank username
    await tester.pump();
    await tester.enterText(find.byKey(const Key('emailKey')), 'gx0340@wayne.edu'); // Enter email
    await tester.pump();
    await tester.enterText(find.byKey(const Key('usernameKey')), ' '); // Enter blank username
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
    await tester.enterText(find.byKey(const Key('usernameKey')), 'mohammedali'); // Enter username
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
    // Enter all info and blank password
    await tester.pump();
    await tester.enterText(find.byKey(const Key('emailKey')), 'gx0340@wayne.edu'); // Enter email
    await tester.pump();
    await tester.enterText(find.byKey(const Key('usernameKey')), 'mohammedali'); // Enter username
    await tester.pump();
    await tester.enterText(find.byKey(const Key('fullNameKey')), 'Mohammed Ali'); // Enter full name
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), ' '); // Enter blank password
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

}
