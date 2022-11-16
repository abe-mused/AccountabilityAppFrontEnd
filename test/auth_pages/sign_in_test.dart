import 'package:flutter/material.dart';
import 'package:linear/auth_pages/sign_in.dart';
import 'package:linear/auth_pages/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

@GenerateMocks([http.Client])

void main() {
  testWidgets('smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    expect(find.byType(LoginPage), findsOneWidget);
  });

  test('E-mail/username', () { // 100%
    // Arrange test
    final emailOrUsername = TextEditingController();
    // Act test
    emailOrUsername.text = 'mohammedali';
    // Assert test
    expect(emailOrUsername.text, 'mohammedali');
  });

  test('Password', () { // 100%
  // Arrange test
  final password = TextEditingController();
  // Act test
  password.text = 'password';
  // Assert test
  expect(password.text, 'password');
  });

testWidgets('User clicks Sign In button', (WidgetTester tester) async { // 100%
await tester.pumpWidget(const MaterialApp(home: LoginPage()));
// Declare variable login, check Elevated button
var userLogin = find.byType(ElevatedButton);
// Expect one widget for Elevated button
expect(userLogin, findsOneWidget);
});

testWidgets('Go to the Sign Up page', (WidgetTester tester) async { // 100%
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(MaterialApp(home: const LoginPage(),
    navigatorObservers: [mockObserver],
    ));
    await tester.pumpAndSettle();
    // Find the Sign Up button
    await tester.tap(find.text("Sign Up"));
    await tester.pumpAndSettle();
    // Search for Sign Up Page widget
    expect(find.byType(SignUpPage), findsOneWidget);
});

testWidgets('User clicks Forgot password button?', (WidgetTester tester) async { // 100 %
await tester.pumpWidget(const MaterialApp(home: LoginPage()));
// Declare variable login, check Text button
var forgetPassword = find.byType(TextButton);
// Look for Text button widget when user forgets password
expect(forgetPassword, findsWidgets);
});

}