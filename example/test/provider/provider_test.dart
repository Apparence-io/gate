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
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'provider_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UserRepository>(),
  MockSpec<BookRepository>(),
  MockSpec<AuthenticationService>(),
])
void main() {
  // Initialize mocks
  final AuthenticationService authServiceMock = MockAuthenticationService();
  final UserRepository userRepositoryMock = MockUserRepository();
  final BookRepository bookRepositoryMock = MockBookRepository();

  group('Mock injection group', () {
    setUp(() {
      when(authServiceMock.getUserId()).thenReturn("31321354");
      when(userRepositoryMock.getFromId("31321354"))
          .thenReturn(UserEntity(name: "Robert"));
      when(userRepositoryMock.getFromId("dsd"))
          .thenReturn(UserEntity(name: "Robert"));
      // Set injected services with mocks
      appProvider.setAuthenticationServiceBuildMock(authServiceMock);
      appProvider.setUserRepositoryBuildMock(userRepositoryMock);
      appProvider.setBookRepositoryBuildMock(bookRepositoryMock);
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
