import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linear/auth_pages/reset_password_code.dart';
import 'package:linear/auth_pages/signup_page.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
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
            "Password must contain at least one uppercase letter, one lowercase letter, one numeric character, and one special character ( ! @ # \$ & * ~ ) !"),
        findsOneWidget);
  });

    testWidgets('Test Regex Validation - Blank Password Submission', (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(const MaterialApp(
      home: ResetPasswordCodePage(
      email: 'gx0340@wayne.edu',
    )));
    //Enter all info and invalid password
    await tester.pump();
    await tester.enterText(find.byKey(const Key('codeKey')), ' ');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), ' ');
    await tester.pump();
    await tester.enterText(
        find.byKey(const Key('confirmPasswordKey')), ' ');
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    //Expect to find error message
    expect(
        find.text(
            "Password must contain at least one uppercase letter, one lowercase letter, one numeric character, and one special character ( ! @ # \$ & * ~ ) !"),
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
            "Password must contain at least one uppercase letter, one lowercase letter, one numeric character, and one special character ( ! @ # \$ & * ~ ) !"),
        findsOneWidget);
    //Tap alert button
    await tester.tap(find.text("Ok"));
    await tester.pump();
    expect(
        find.text(
            "Password must contain at least one uppercase letter, one lowercase letter, one numeric character, and one special character ( ! @ # \$ & * ~ ) !"),
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

  testWidgets('Go to Sign Up page', (WidgetTester tester) async {
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
    await tester.tap(find.text("Sign Up"));
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
    ),
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
    //Tap alert button
    await tester.pumpAndSettle();
    await tester.tap(find.text("Ok"));
    await tester.pumpAndSettle();
    expect(
        find.text(
            "An error occured while sending the password reset code. Please try again later."),
        findsNothing);
  });

    testWidgets('Failed Password Reset - Submit blank password reset code', (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(const MaterialApp(
      home: ResetPasswordCodePage(
      email: 'gx0340@wayne.edu',
    )));
    //Enter all info and invalid password
    await tester.pump();
    await tester.enterText(find.byKey(const Key('codeKey')), '');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Password2022!');
    await tester.pump();
    await tester.enterText(
        find.byKey(const Key('confirmPasswordKey')), 'Password2022!');
    await tester.pump();
    // Click Reset Password
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    //Expect to find error message
    expect(
        find.text(
        "Please fill out all fields!"),
        findsOneWidget);
  });

    testWidgets('ALERT BUTTON: Failed Password Reset - Submit Blank Password Reset Code', (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(const MaterialApp(
      home: ResetPasswordCodePage(
      email: 'gx0340@wayne.edu',
    )));
    //Enter all info and invalid password code
    await tester.pump();
    await tester.enterText(find.byKey(const Key('codeKey')), '');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Password2022!');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('confirmPasswordKey')), 'Password2022!');
    await tester.pump();
    // Click button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    //Expect to find error message
    expect(find.text("Please fill out all fields!"), findsOneWidget);
    //Tap alert button
    await tester.tap(find.text("Ok"));
    await tester.pump();
    expect(find.text("Please fill out all fields!"), findsNothing);
  });

    testWidgets('Failed Password Reset - Enter Password Reset Code and blank password', (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(const MaterialApp(
      home: ResetPasswordCodePage(
      email: 'gx0340@wayne.edu',
    )));
    // Enter all info and blank password
   await tester.enterText(find.byKey(const Key('codeKey')), '123456');
    await tester.pump();
    // Leave password fields blank
    await tester.enterText(find.byKey(const Key('passwordKey')), '');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('confirmPasswordKey')), '');
    await tester.pump();
    // Rebuild the widget with the new item.
    await tester.pumpAndSettle();
    // Reset password clicked
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Expect to find error message
    expect(find.text("Please fill out all fields!"), findsOneWidget);
  });

    testWidgets('ALERT BUTTON: Failed Password Reset - Enter Password Reset Code and blank password', (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(const MaterialApp(
      home: ResetPasswordCodePage(
      email: 'gx0340@wayne.edu',
    )));
    // Check alert button
   await tester.enterText(find.byKey(const Key('codeKey')), '123456');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), '');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('confirmPasswordKey')), '');
    await tester.pump();
    // Rebuild the widget with the new item.
    await tester.pumpAndSettle();
    // Reset password clicked
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Expect to find error message
    expect(find.text("Please fill out all fields!"), findsOneWidget);
    //Tap alert button
    await tester.tap(find.text("Ok"));
    await tester.pump();
    // Display message on alert dialog
    expect(find.text("Please fill out all fields!"), findsNothing);
  });

    testWidgets('Failed Password Reset - Enter password and blank Password Reset Code', (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(const MaterialApp(
      home: ResetPasswordCodePage(
      email: 'gx0340@wayne.edu',
    )));
    // Enter password and blank password reset code
   await tester.enterText(find.byKey(const Key('codeKey')), '');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Password2022!');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('confirmPasswordKey')), 'Password2022!');
    await tester.pump();
    // Rebuild the widget with the new item.
    await tester.pumpAndSettle();
    // Reset password clicked
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Expect to find error message
    expect(find.text("Please fill out all fields!"), findsOneWidget);
  });

      testWidgets('ALERT BUTTON: Failed Password Reset - Enter password and blank Password Reset Code', (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(const MaterialApp(
      home: ResetPasswordCodePage(
      email: 'gx0340@wayne.edu',
    )));
    // Check alert dialog message with blank password reset code
   await tester.enterText(find.byKey(const Key('codeKey')), '');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Password2022!');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('confirmPasswordKey')), 'Password2022!');
    await tester.pump();
    // Rebuild the widget with the new item.
    await tester.pumpAndSettle();
    // Reset password clicked
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Expect to find error message
    expect(find.text("Please fill out all fields!"), findsOneWidget);
    //Tap alert button
    await tester.tap(find.text("Ok"));
    await tester.pump();
    expect(find.text("Please fill out all fields!"), findsNothing);
  });

    testWidgets('Failed Password Reset - Do not confirm password', (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(const MaterialApp(
      home: ResetPasswordCodePage(
      email: 'gx0340@wayne.edu',
    )));
    // Ignore confirm password key 
    await tester.enterText(find.byKey(const Key('codeKey')), '123456');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Password2022!');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('confirmPasswordKey')), '');
    await tester.pump();
    // Rebuild the widget with the new item.
    await tester.pumpAndSettle();
    // Reset password clicked
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Expect to find error message
    expect(find.text("Please fill out all fields!"), findsOneWidget);
  });

    testWidgets('ALERT BUTTON: Failed Password Reset - Do not confirm password', (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(const MaterialApp(
      home: ResetPasswordCodePage(
      email: 'gx0340@wayne.edu',
    )));
    // Check Alert Dialog
    await tester.enterText(find.byKey(const Key('codeKey')), '123456');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Password2022!');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('confirmPasswordKey')), '');
    await tester.pump();
    // Rebuild the widget with the new item.
    await tester.pumpAndSettle();
    // Reset password
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Expect to find error message
    expect(find.text("Please fill out all fields!"), findsOneWidget);
    //Tap alert button
    await tester.tap(find.text("Ok"));
    await tester.pump();
    expect(find.text("Please fill out all fields!"), findsNothing);
  });

    testWidgets('Failed Password Reset - Invalid confirm password', (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(const MaterialApp(
      home: ResetPasswordCodePage(
      email: 'gx0340@wayne.edu',
    )));
    // Enter all info and password that do not match
    await tester.pump();
    await tester.enterText(find.byKey(const Key('codeKey')), '123456');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Password2022!');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('confirmPasswordKey')), 'p@ssw0rd2o22?');
    await tester.pump();
    // Click button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Expect to find error message 
    expect(find.text(
      "Passwords do not match each other, please try again."),findsOneWidget);
  });

    testWidgets('ALERT BUTTON: Failed Password Reset - Invalid confirm password', (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(const MaterialApp(
      home: ResetPasswordCodePage(
      email: 'gx0340@wayne.edu',
    )));
    // Enter all info and password that do not match
    await tester.pump();
    await tester.enterText(find.byKey(const Key('codeKey')), '123456');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Password2022!');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('confirmPasswordKey')), 'p@ssw0rd2o22?');
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Expect to find error message 
    expect(find.text(
      "Passwords do not match each other, please try again."),findsOneWidget);
    //Tap alert button
    await tester.tap(find.text("Ok"));
    await tester.pump();
    expect(find.text(
      "Passwords do not match each other, please try again."), findsNothing);
  });

testWidgets('Failed Password Reset - Blank confirm password', (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(const MaterialApp(
      home: ResetPasswordCodePage(
      email: 'gx0340@wayne.edu',
    ),
    ),
    );
    // Enter all info and password that do not match
    await tester.pump();
    await tester.enterText(find.byKey(const Key('codeKey')), '123456');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Password2022!');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('confirmPasswordKey')), '');
    await tester.pump();
    // Click button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Expect to find error message 
    expect(find.text("Please fill out all fields!"),findsOneWidget);
  });

    testWidgets('ALERT BUTTON: Failed Password Reset - Blank confirm password', (tester) async {
    //setup
    //Build widget
    await tester.pumpWidget(const MaterialApp(
      home: ResetPasswordCodePage(
      email: 'gx0340@wayne.edu',
    ),
    ),
    );
    // Enter all info and password that do not match
    await tester.pump();
    await tester.enterText(find.byKey(const Key('codeKey')), '123456');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('passwordKey')), 'Password2022!');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('confirmPasswordKey')), '');
    await tester.pump();
    // Click button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    // Expect to find error message 
    expect(find.text("Please fill out all fields!"),findsOneWidget);
    // Tap alert button
    await tester.tap(find.text("Ok"));
    await tester.pump();
    expect(find.text("Please fill out all fields!"), findsNothing);
  });
}