import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/services/firebase_auth_service.dart';
import '../../../../core/services/firestore_service.dart';

class FirebaseAuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isAuthenticated = false;
  User? _user;
  Map<String, dynamic>? _userData;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  User? get user => _user;
  Map<String, dynamic>? get userData => _userData;
  String? get userEmail => _user?.email;
  String? get userName => _user?.displayName ?? _userData?['displayName'];
  String? get userId => _user?.uid;
  String? get errorMessage => _errorMessage;

  FirebaseAuthProvider() {
    _initialize();
  }

  void _initialize() {
    try {
      // Listen to auth state changes
      FirebaseAuthService.authStateChanges.listen((User? user) {
        _user = user;
        _isAuthenticated = user != null;

        if (user != null) {
          _loadUserData(user.uid);
        } else {
          _userData = null;
        }

        notifyListeners();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Firebase Auth not available, running in development mode: $e');
      }
      // Set default values for development
      _isAuthenticated = false;
      _user = null;
      _userData = null;
      notifyListeners();
    }
  }

  Future<void> _loadUserData(String userId) async {
    try {
      _userData = await FirestoreService.getDocument(
        collection: 'users',
        documentId: userId,
      );
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user data: $e');
      }
    }
  }

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Check if user is already logged in
      final user = FirebaseAuthService.currentUser;
      if (user != null) {
        _user = user;
        _isAuthenticated = true;
        await _loadUserData(user.uid);
      }
    } catch (e) {
      _errorMessage = 'Failed to initialize authentication: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await FirebaseAuthService.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );

      if (result != null) {
        _user = result.user;
        _isAuthenticated = true;
        await _loadUserData(result.user!.uid);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await FirebaseAuthService.signIn(
        email: email,
        password: password,
      );

      if (result != null) {
        _user = result.user;
        _isAuthenticated = true;
        await _loadUserData(result.user!.uid);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseAuthService.signOut();
      _user = null;
      _userData = null;
      _isAuthenticated = false;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to sign out: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Alias for signOut to match the old interface
  Future<void> logout() async {
    await signOut();
  }

  Future<void> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await FirebaseAuthService.resetPassword(email);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseAuthService.updateProfile(
        displayName: displayName,
        photoURL: photoURL,
      );

      // Reload user data
      if (_user != null) {
        await _loadUserData(_user!.uid);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAccount() async {
    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseAuthService.deleteAccount();
      _user = null;
      _userData = null;
      _isAuthenticated = false;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
