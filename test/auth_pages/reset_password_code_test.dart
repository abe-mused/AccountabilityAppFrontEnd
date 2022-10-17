import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linear/auth_pages/reset_password_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linear/auth_pages/sign_up.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

@GenerateMocks([http.Client])
void main() {
  testWidgets('smoke test', (WidgetTester tester) async {
    await tester
        .pumpWidget(const MaterialApp(home: ResetPasswordCodePage(email: '')));
    expect(find.byType(ResetPasswordCodePage), findsOneWidget);
  });

  test('Code Field Changes', () {
    //setup
    final code = TextEditingController();
    //do
    code.text = '123456';
    //test
    expect(code.text, '123456');
  });

  test('Password Field Changes', () {
    //setup
    final password = TextEditingController();
    //do
    password.text = '123456';
    //test
    expect(password.text, '123456');
  });

  test('Confirm Password Field Changes', () {
    //setup
    final confirmPassword = TextEditingController();
    //do
    confirmPassword.text = '123456';
    //test
    expect(confirmPassword.text, '123456');
  });

  testWidgets('Test Regex Validation - all fields filled', (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(const MaterialApp(
        home: ResetPasswordCodePage(
      email: 'ahmedtanvir725@gmail.com',
    )));
    //No info entered
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    //Expect to find error message
    expect(find.text("Please fill out all fields!"), findsOneWidget);
  });

  testWidgets('ALERT BUTTON: Test Regex Validation - all fields filled',
      (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(const MaterialApp(
        home: ResetPasswordCodePage(
      email: 'ahmedtanvir725@gmail.com',
    )));
    //No info entered
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    //Expect to find error message
    expect(find.text("Please fill out all fields!"), findsOneWidget);
    //Tap alert button
    await tester.tap(find.text("Ok"));
    await tester.pump();
    expect(find.text("Please fill out all fields!"), findsNothing);
  });

  testWidgets('Test Regex Validation - Password Regex', (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(const MaterialApp(
        home: ResetPasswordCodePage(
      email: 'ahmedtanvir725@gmail.com',
    )));
    //Enter all info and invalid password
    await tester.pump();
    await tester.enterText(find.byKey(const Key('codeKey')), '123456');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Invalid');
    await tester.pump();
    await tester.enterText(
        find.byKey(const Key('confirmPasswordKey')), 'Invalid');
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    //Expect to find error message
    expect(
        find.text(
            "Passwords must contain at least one uppercase letter, one lowercase letter, one numeric character, and one special character ( ! @ # \$ & * ~ ) !"),
        findsOneWidget);
  });

  testWidgets('ALERT BUTTON: Test Regex Validation - Password Regex',
      (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(const MaterialApp(
        home: ResetPasswordCodePage(
      email: 'ahmedtanvir725@gmail.com',
    )));
    //Enter all info and invalid password
    await tester.pump();
    await tester.enterText(find.byKey(const Key('codeKey')), '123456');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Invalid');
    await tester.pump();
    await tester.enterText(
        find.byKey(const Key('confirmPasswordKey')), 'Invalid');
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    //Expect to find error message
    expect(
        find.text(
            "Passwords must contain at least one uppercase letter, one lowercase letter, one numeric character, and one special character ( ! @ # \$ & * ~ ) !"),
        findsOneWidget);
    //Tap alert button
    await tester.tap(find.text("Ok"));
    await tester.pump();
    expect(
        find.text(
            "Passwords must contain at least one uppercase letter, one lowercase letter, one numeric character, and one special character ( ! @ # \$ & * ~ ) !"),
        findsNothing);
  });

  testWidgets('Test Regex Validation - Passwords do not match', (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(const MaterialApp(
        home: ResetPasswordCodePage(
      email: 'ahmedtanvir725@gmail.com',
    )));
    //Enter all info and invalid password
    await tester.pump();
    await tester.enterText(find.byKey(const Key('codeKey')), '123456');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'User1234@');
    await tester.pump();
    await tester.enterText(
        find.byKey(const Key('confirmPasswordKey')), 'User1223@8');
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    //Expect to find error message
    expect(find.text("Passwords do not match each other, please try again."),
        findsOneWidget);
  });

  testWidgets('ALERT BUTTON: Test Regex Validation - Passwords do not match',
      (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(const MaterialApp(
        home: ResetPasswordCodePage(
      email: 'ahmedtanvir725@gmail.com',
    )));
    //Enter all info and invalid password
    await tester.pump();
    await tester.enterText(find.byKey(const Key('codeKey')), '123456');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'User1234@');
    await tester.pump();
    await tester.enterText(
        find.byKey(const Key('confirmPasswordKey')), 'User1223@8');
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    //Expect to find error message
    expect(find.text("Passwords do not match each other, please try again."),
        findsOneWidget);
    //Tap alert button
    await tester.tap(find.text("Ok"));
    await tester.pump();
    expect(find.text("Passwords do not match each other, please try again."),
        findsNothing);
  });

  testWidgets('Failed Submission', (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(const MaterialApp(
        home: ResetPasswordCodePage(
      email: 'ahmedtanvir725@gmail.com',
    )));
    //Enter all info and invalid password
    await tester.pump();
    await tester.enterText(find.byKey(const Key('codeKey')), '123456');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'User1234@');
    await tester.pump();
    await tester.enterText(
        find.byKey(const Key('confirmPasswordKey')), 'User1234@');
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    //Expect to find error message
    expect(
        find.text(
            "An error occured while attempting to change your password. Please request a new code or register an account."),
        findsOneWidget);
  });

  testWidgets('ALERT BUTTON: Failed Submission', (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(const MaterialApp(
        home: ResetPasswordCodePage(
      email: 'ahmedtanvir725@gmail.com',
    )));
    //Enter all info and invalid password
    await tester.pump();
    await tester.enterText(find.byKey(const Key('codeKey')), '123456');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'User1234@');
    await tester.pump();
    await tester.enterText(
        find.byKey(const Key('confirmPasswordKey')), 'User1234@');
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    //Expect to find error message
    expect(
        find.text(
            "An error occured while attempting to change your password. Please request a new code or register an account."),
        findsOneWidget);
    //Tap alert button
    await tester.tap(find.text("Ok"));
    await tester.pump();
    expect(
        find.text(
            "An error occured while attempting to change your password. Please request a new code or register an account."),
        findsNothing);
  });

  testWidgets('Go to register page', (WidgetTester tester) async {
    //setup
    //Build widget
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        home: const ResetPasswordCodePage(email: 'ahmedtanvir725@gmail.com'),
        navigatorObservers: [mockObserver],
      ),
    );
    await tester.pumpAndSettle();
    //Register Screen button
    await tester.tap(find.text("Register"));
    // Rebuild the widget with the new item.
    await tester.pumpAndSettle();
    /// Verify that a push event happened
    expect(find.byType(SignUpPage), findsOneWidget);
  });

  testWidgets('Resend Code Button failed submission', (WidgetTester tester) async {
    //setup
    //Build widget
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        home: const ResetPasswordCodePage(email: 'ahmedtanvir725@gmail.com'),
        navigatorObservers: [mockObserver],
      ),
    );
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 100));
    //Register Screen button
    await tester.tap(find.text("Resend"));
    // Rebuild the widget with the new item.
    await tester.pumpAndSettle();
    /// Verify that a push event happened
    //Expect to find error message
    expect(
        find.text(
            "An error occured while sending the password reset code. Please try again later."),
        findsOneWidget);
  });

  testWidgets('ALERT BUTTON: Resend Code Button failed submission', (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(const MaterialApp(
        home: ResetPasswordCodePage(
      email: 'ahmedtanvir725@gmail.com',
    )));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 100));
    //Register Screen button
    await tester.tap(find.text("Resend"));
    // Rebuild the widget with the new item.
    await tester.pumpAndSettle();
    /// Verify that a push event happened
    //Expect to find error message
    expect(
        find.text(
            "An error occured while sending the password reset code. Please try again later."),
        findsOneWidget);
    //Tap alert button
    await tester.pumpAndSettle();
    await tester.tap(find.text("Ok"));
    await tester.pumpAndSettle();
    expect(
        find.text(
            "An error occured while sending the password reset code. Please try again later."),
        findsNothing);
  });
}
