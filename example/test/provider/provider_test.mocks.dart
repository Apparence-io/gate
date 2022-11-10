// Mocks generated by Mockito 5.3.2 from annotations
// in gate_example/test/provider/provider_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:gate_example/database/entities/user_entity.dart' as _i2;
import 'package:gate_example/database/repositories/book_repository.dart' as _i4;
import 'package:gate_example/database/repositories/user_repository.dart' as _i3;
import 'package:gate_example/services/auth_service.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeUserEntity_0 extends _i1.SmartFake implements _i2.UserEntity {
  _FakeUserEntity_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [UserRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserRepository extends _i1.Mock implements _i3.UserRepository {
  @override
  _i2.UserEntity getFromId(String? id) => (super.noSuchMethod(
        Invocation.method(
          #getFromId,
          [id],
        ),
        returnValue: _FakeUserEntity_0(
          this,
          Invocation.method(
            #getFromId,
            [id],
          ),
        ),
        returnValueForMissingStub: _FakeUserEntity_0(
          this,
          Invocation.method(
            #getFromId,
            [id],
          ),
        ),
      ) as _i2.UserEntity);
}

/// A class which mocks [BookRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockBookRepository extends _i1.Mock implements _i4.BookRepository {}

/// A class which mocks [AuthenticationService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthenticationService extends _i1.Mock
    implements _i5.AuthenticationService {
  @override
  String getUserId() => (super.noSuchMethod(
        Invocation.method(
          #getUserId,
          [],
        ),
        returnValue: '',
        returnValueForMissingStub: '',
      ) as String);
}