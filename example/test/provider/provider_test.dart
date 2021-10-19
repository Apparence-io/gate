// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:gate_example/database/entities/user_entity.dart';
import 'package:gate_example/database/repositories/book_repository.dart';
import 'package:gate_example/database/repositories/user_repository.dart';
import 'package:gate_example/gate/gate_provider.dart';
import 'package:gate_example/main.dart';
import 'package:gate_example/services/auth_service.dart';
import 'package:mocktail/mocktail.dart';

class UserRepositoryMock extends Mock implements UserRepository {}

class BookRepositoryMock extends Mock implements BookRepository {}

class AuthenticationServiceMock extends Mock implements AuthenticationService {}

void main() {
  // Initialize mocks
  final AuthenticationService authServiceMock = AuthenticationServiceMock();
  final UserRepository userRepository = UserRepositoryMock();
  final BookRepository bookRepository = BookRepositoryMock();

  group('Mock injection group', () {
    setUp(() {
      when(() => authServiceMock.getUserId()).thenReturn("31321354");
      when(() => userRepository.getFromId(any()))
          .thenReturn(UserEntity(name: "Robert"));
      // Set injected services with mocks
      appProvider.setAuthenticationServiceBuildMock(authServiceMock);
      appProvider.setUserRepositoryBuildMock(userRepository);
      appProvider.setBookRepositoryBuildMock(bookRepository);
    });

    tearDownAll(() {
      // Remove mocks from appProvider (real ones will be used)
      appProvider.setAuthenticationServiceBuildMock(null);
      appProvider.setUserRepositoryBuildMock(null);
      appProvider.setBookRepositoryBuildMock(null);
    });

    testWidgets('Test mocks injection', (WidgetTester tester) async {
      expect(appProvider.getUserRepositoryBuild().getFromId("dsd").name,
          equals('Robert')); // Mocked returned value
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      expect(find.text("Robert"), findsOneWidget);
    });
  });
}
