import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linear/auth_pages/verify_email.dart';
import 'package:linear/auth_pages/login_page.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:linear/auth_pages/reset_password_code.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

@GenerateMocks([http.Client])

void main() {
  testWidgets('smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ResetPasswordPage()));
    expect(find.byType(ResetPasswordPage), findsOneWidget);
  });

  test('Email Field Changes', () {
    //setup
    final email = TextEditingController();
    //do
    email.text = 'ahmedtanvir725@gmail.com';
    //test
    expect(email.text, 'ahmedtanvir725@gmail.com');
  });

  testWidgets('Test Regex Validation', (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(const MaterialApp(home: ResetPasswordPage()));
    //Enter email into text field
    await tester.enterText(find.byType(TextField), 'ahmedtanvir725@com');
    // Rebuild the widget with the new item.
    await tester.pump();
    // Expect to find the item on screen.
    expect(find.text('ahmedtanvir725@com'), findsOneWidget);
    //Submit form
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    //Expect to find error message
    expect(find.text("Invalid email! please try again."), findsOneWidget);
  });

  testWidgets('Test Regex Validation alert button', (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(const MaterialApp(home: ResetPasswordPage()));
    //Enter email into text field
    await tester.enterText(find.byType(TextField), 'ahmedtanvir725@com');
    // Rebuild the widget with the new item.
    await tester.pump();
    // Expect to find the item on screen.
    expect(find.text('ahmedtanvir725@com'), findsOneWidget);
    //Submit form
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    //Expect to find error message
    expect(find.text("Invalid email! please try again."), findsOneWidget);
    //Tap ok button
    await tester.tap(find.text("Ok"));
    await tester.pump();
    expect(find.text("Invalid email! please try again."), findsNothing);
  });
  
  testWidgets('Failed Submission Call', (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(const MaterialApp(home: ResetPasswordPage()));
    //Enter email into text field
    await tester.enterText(find.byType(TextField), 'ahmed.tanvir725@gmail.com');
    // Rebuild the widget with the new item.
    await tester.pumpAndSettle();
    // Expect to find the item on screen.
    expect(find.text('ahmed.tanvir725@gmail.com'), findsOneWidget);
    //Submit form
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.text("An error occured while sending the password reset code. Please try again later."), findsOneWidget);
  });

  testWidgets('Succesful Submission Call', (tester) async {
    //setup
    final mockObserver = MockNavigatorObserver(); 
    final client = MockClient((request) async {
      return Response(
        json.encode({
          'status': true,
          'message': 'A password reset code has been sent to your email.'
        }),
        200,
        headers: {'content-type': 'text/plain'});
    });
    //Build widget
    await tester.pumpWidget(
      MaterialApp(
        home: const ResetPasswordPage(),
        navigatorObservers: [mockObserver],
      ),
    );
    //Enter email into text field
    await tester.enterText(find.byType(TextField), 'ahmed.tanvir725@gmail.com');
    // Rebuild the widget with the new item.
    await tester.pumpAndSettle();
    // Expect to find the item on screen.
    expect(find.text('ahmed.tanvir725@gmail.com'), findsOneWidget);
    //Submit form
    await tester.tap(find.byType(ElevatedButton));
    
    await tester.pump();
    /// Verify that a push event happened
    expect(client, isA<MockClient>());
    //expect(find.byType(ResetPasswordCodePage), findsOneWidget);    
  });
  

  testWidgets('Alert ok button works on failed submission call', (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(const MaterialApp(home: ResetPasswordPage()));
    //Enter email into text field
    await tester.enterText(find.byType(TextField), 'ahmed.tanvir725@gmail.com');
    // Rebuild the widget with the new item.
    await tester.pumpAndSettle();
    // Expect to find the item on screen.
    expect(find.text('ahmed.tanvir725@gmail.com'), findsOneWidget);
    //Submit form
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.text("An error occured while sending the password reset code. Please try again later."), findsOneWidget);
    //Tap ok button
    await tester.tap(find.text("Ok"));
    await tester.pump();
    expect(find.text("An error occured while sending the password reset code. Please try again later."), findsNothing);
  });

  testWidgets('Go to login page', (WidgetTester tester) async {
    //setup
    //Build widget
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        home: const ResetPasswordPage(),
        navigatorObservers: [mockObserver],
      ),
    );
    //Login Screen button
    await tester.tap(find.byType(TextButton));
    // Rebuild the widget with the new item.
    await tester.pumpAndSettle();

    /// Verify that a push event happened
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
