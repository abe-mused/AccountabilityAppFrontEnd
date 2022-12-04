import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:linear/auth_pages/login_page.dart';
import 'package:linear/auth_pages/signup_page.dart';
import 'package:linear/auth_pages/verify_email.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

@GenerateMocks([http.Client])
void main() {
  testWidgets('Successful login with username and password', (tester) async {
    final mockObserver = MockNavigatorObserver(); 
    final client = MockClient((request) async {
      return http.Response(
        json.encode({
          'status': true,
          'message': 'Success! User is logged into account'
        }),
        200,
        headers: {'content-type': 'text/plain'});
    });
    await tester.pumpWidget(
      MaterialApp(home: const LoginPage(),
        navigatorObservers: [mockObserver],
      ),
    );
    // Enter text field with login information
    await tester.enterText(find.byKey(const Key('emailOrUsernameKey')), 'mohammedali'); // Enter username
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Password2022!'); // Enter password
    await tester.pump();
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(client, isA<MockClient>());
  });

  testWidgets('Successful login with email and password', (tester) async {
    final mockObserver = MockNavigatorObserver(); 
    final client = MockClient((request) async {
      return http.Response(
        json.encode({
          'status': true,
          'message': 'Success! User is logged into account'
        }),
        200,
        headers: {'content-type': 'text/plain'});
    });
    await tester.pumpWidget(MaterialApp(home: const LoginPage(),
        navigatorObservers: [mockObserver],
      ),
    );
    // Enter text field with login information
    await tester.enterText(find.byKey(const Key('emailOrUsernameKey')), 'gx0340@wayne.edu'); // Enter email
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Password2022!'); // Enter password
    await tester.pump();
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(client, isA<MockClient>());
  });

  testWidgets('Go to Sign Up Page', (WidgetTester tester) async {
  final mockObserver = MockNavigatorObserver();
  await tester.pumpWidget(
    MaterialApp(home: const LoginPage(),
    navigatorObservers: [mockObserver],
    ),
  );
    await tester.pumpAndSettle();
    await tester.tap(find.text("Sign Up"));
    await tester.pumpAndSettle();
    expect(find.byType(SignUpPage), findsOneWidget);
  });

testWidgets('Go to Reset Password Page', (WidgetTester tester) async {
  final mockObserver = MockNavigatorObserver();
  await tester.pumpWidget(
    MaterialApp(home: const LoginPage(),
    navigatorObservers: [mockObserver],
    ),
  );
    await tester.pumpAndSettle();
    await tester.tap(find.text("Forgot password?"));
    await tester.pumpAndSettle();
    expect(find.byType(ResetPasswordPage), findsOneWidget);
  });

testWidgets('Failed login - Fill out all fields', (tester) async {
  await tester.pumpWidget(const MaterialApp(home: LoginPage()));
  // No information entered in text field
  await tester.pump();
  await tester.tap(find.byType(ElevatedButton));
  await tester.pump();
    // Expect to find error message
  expect(find.text("Failed Login"),findsOneWidget);
  });

  testWidgets('Failed login with invalid email and good password', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    // Enter invalid information
    await tester.pump();
    await tester.enterText(find.byKey(const Key('emailOrUsernameKey')), 'test');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Password2022!');
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Expect to find error message
    expect(find.text("Failed Login"),findsOneWidget);
  });
  
  testWidgets('Failed login with invalid username and good password', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    // Enter invalid information
    await tester.pump();
    await tester.enterText(find.byKey(const Key('emailOrUsernameKey')), 'Mohammed Ali Test');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Password2022!');
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Expect to find error message
    expect(find.text("Failed Login"),findsOneWidget);
  });

  testWidgets('Failed login with invalid password and good email', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    // Enter invalid information
    await tester.pump();
    await tester.enterText(find.byKey(const Key('emailOrUsernameKey')), 'gx0340wayne.edu');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'password');
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Expect to find error message
    expect(find.text("Failed Login"),findsOneWidget);
  });

  testWidgets('Failed login with invalid password and good username', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    // Enter invalid information
    await tester.pump();
    await tester.enterText(find.byKey(const Key('emailOrUsernameKey')), 'gx0340wayne.edu');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'password');
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Expect to find error message
    expect(find.text("Failed Login"),findsOneWidget);
  });

  testWidgets('ALERT DIALOG: Failed login - Fill out all fields', (tester) async {
     await tester.pumpWidget(const MaterialApp(home: LoginPage()));
     // No information entered in text field
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.pumpAndSettle();
    //Expect to find error message
    expect(find.text("Failed Login"),findsOneWidget);
    //Tap alert button
    await tester.tap(find.text("Ok"));
    await tester.pump();
    expect(find.text("Failed Login"),findsOneWidget);
  });

  testWidgets('ALERT DIALOG: Failed login with invalid email and good password', (tester) async {
     await tester.pumpWidget(const MaterialApp(home: LoginPage()));
     // No information entered in text field
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.pumpAndSettle();
    //Expect to find error message
    expect(find.text("Failed Login"),findsOneWidget);
    //Tap alert button
    await tester.tap(find.text("Ok"));
    await tester.pump();
    expect(find.text("Failed Login"),findsOneWidget);
  });

  testWidgets('ALERT DIALOG: Failed login - Fill out all fields', (tester) async {
     await tester.pumpWidget(const MaterialApp(home: LoginPage()));
     // No information entered in text field
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.pumpAndSettle();
    //Expect to find error message
    expect(find.text("Failed Login"),findsOneWidget);
    //Tap alert button
    await tester.tap(find.text("Ok"));
    await tester.pump();
    expect(find.text("Failed Login"),findsOneWidget);
  });

  testWidgets('ALERT DIALOG: Failed login with invalid username and good password', (tester) async {
     await tester.pumpWidget(const MaterialApp(home: LoginPage()));
     // No information entered in text field
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.pumpAndSettle();
    //Expect to find error message
    expect(find.text("Failed Login"),findsOneWidget);
    //Tap alert button
    await tester.tap(find.text("Ok"));
    await tester.pump();
    expect(find.text("Failed Login"),findsOneWidget);
  });

    testWidgets('ALERT DIALOG: Failed login with invalid password and good email', (tester) async {
     await tester.pumpWidget(const MaterialApp(home: LoginPage()));
     // No information entered in text field
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.pumpAndSettle();
    //Expect to find error message
    expect(find.text("Failed Login"),findsOneWidget);
    //Tap alert button
    await tester.tap(find.text("Ok"));
    await tester.pump();
    expect(find.text("Failed Login"),findsOneWidget);
  });

  testWidgets('ALERT DIALOG: Failed login with invalid password and good username', (tester) async {
     await tester.pumpWidget(const MaterialApp(home: LoginPage()));
     // No information entered in text field
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.pumpAndSettle();
    //Expect to find error message
    expect(find.text("Failed Login"),findsOneWidget);
    //Tap alert button
    await tester.tap(find.text("Ok"));
    await tester.pump();
    expect(find.text("Failed Login"),findsOneWidget);
  });

}
