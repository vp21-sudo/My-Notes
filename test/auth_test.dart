import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('mock authetication', () {
    final provider = MockAuthProvider();
    test("Should not be initialized to begin with", () {
      expect(provider._isInitialized, false);
    });

    test("cannot logout if not initialized", () {
      expect(provider.logOut(), throwsA(isA<NotInitializedException>()));
    });

    test("should be able to init", () async {
      await provider.initialize();
    });

    test("user should be null after init", () {
      expect(provider.currentUser, null);
    });

    test("should be able to init in less that 2s", () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test("Create user should deligate to login function", () async {
      final badEmailUser = provider.createUser(
        email: 'foo@bar.com',
        password: 'asdfasf',
      );
      expect(badEmailUser, throwsA(isA<UserNotFoundAuthException>()));

      final badPasswordUser = provider.createUser(
        email: "asdfas@gmail.com",
        password: 'foobar',
      );

      expect(badPasswordUser, throwsA(isA<WrongPasswordAuthException>()));

      final user = await provider.createUser(
        email: "foo",
        password: "Bar",
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test("Logged in your should not be able to get verified", () async {
      await provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test("should be able to logout and login again", () async {
      await provider.logOut();
      await provider.logIn(
        email: 'email',
        password: 'password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!isInitialized) throw NotInitializedException();
    if (email == "foo@bar.com") throw UserNotFoundAuthException();
    if (password == "foobar") throw WrongPasswordAuthException();
    const user = AuthUser(
      isEmailVerified: false,
      email: "foo@bar.com",
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(
      isEmailVerified: true,
      email: "foo@bar.com",
    );
    _user = newUser;
  }
}
