// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:gate_example/database/repositories/book_repository.dart' as _i1;
import 'package:gate_example/database/repositories/user_repository.dart' as _i2;
import 'package:gate_example/database/repositories/library_repository.dart'
    as _i3;
import 'package:gate_example/services/auth_service.dart' as _i4;
import 'package:gate_example/services/user_service.dart'
    as _i5; // coverage:ignore-file

// ********************************
// Gate generated file
// Do not modify by hand
// ********************************
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target
class AppProvider {
  AppProvider._();

  static final AppProvider instance = AppProvider._();

// BookRepository singleton
  final _i1.BookRepository _bookRepositoryBuild = _i1.BookRepository.build();

// BookRepository mock
  _i1.BookRepository? _bookRepositoryBuildMock;

// UserRepository singleton
  final _i2.UserRepository _userRepositoryBuild = _i2.UserRepository.build();

// UserRepository mock
  _i2.UserRepository? _userRepositoryBuildMock;

// LibraryRepository singleton
  final _i3.LibraryRepository _libraryRepositoryBuild =
      _i3.LibraryRepository.build();

// LibraryRepository mock
  _i3.LibraryRepository? _libraryRepositoryBuildMock;

// AuthenticationService singleton
  final _i4.AuthenticationService _authenticationServiceBuild =
      _i4.AuthenticationService.build();

// AuthenticationService mock
  _i4.AuthenticationService? _authenticationServiceBuildMock;

// UserService mock
  _i5.UserService? _userServiceBuildMock;

// injected BookRepository
  _i1.BookRepository getBookRepositoryBuild() =>
      _bookRepositoryBuildMock ?? _bookRepositoryBuild;
// Set BookRepository mock
  void setBookRepositoryBuildMock(_i1.BookRepository? mock) =>
      _bookRepositoryBuildMock = mock;
// injected UserRepository
  _i2.UserRepository getUserRepositoryBuild() =>
      _userRepositoryBuildMock ?? _userRepositoryBuild;
// Set UserRepository mock
  void setUserRepositoryBuildMock(_i2.UserRepository? mock) =>
      _userRepositoryBuildMock = mock;
// injected LibraryRepository
  _i3.LibraryRepository getLibraryRepositoryBuild() =>
      _libraryRepositoryBuildMock ?? _libraryRepositoryBuild;
// Set LibraryRepository mock
  void setLibraryRepositoryBuildMock(_i3.LibraryRepository? mock) =>
      _libraryRepositoryBuildMock = mock;
// injected AuthenticationService
  _i4.AuthenticationService getAuthenticationServiceBuild() =>
      _authenticationServiceBuildMock ?? _authenticationServiceBuild;
// Set AuthenticationService mock
  void setAuthenticationServiceBuildMock(_i4.AuthenticationService? mock) =>
      _authenticationServiceBuildMock = mock;
// injected UserService
  _i5.UserService getUserServiceBuild() =>
      _userServiceBuildMock ?? _i5.UserService.build();
// Set UserService mock
  void setUserServiceBuildMock(_i5.UserService? mock) =>
      _userServiceBuildMock = mock;
}

final AppProvider appProvider = AppProvider.instance;
