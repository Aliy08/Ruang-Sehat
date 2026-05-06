import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ruang_sehat/features/auth/data/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ruang_sehat/features/auth/data/user_model.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  UserModel? _profile;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMesage => _successMessage;
  UserModel? get profile => _profile;

  // Provider Register
  Future<bool> register(String name, String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final response = await AuthServices.register(name, username, password);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['success'] == true) {
          _successMessage = data['message'] ?? 'Registrasi berhasil';
          return true;
        }
      }

      if (data['errors'] != null &&
          data['errors'] is List &&
          data['errors'].isNotEmpty) {
        final firstError = data['errors'][0];
        _errorMessage =
            firstError['message'] ?? data['message'] ?? 'Terjadi kesalahan';
      } else {
        _errorMessage = data['message'] ?? 'Registrasi gagal';
      }

      return false;
    } catch (error) {
      _errorMessage = 'Terjadi kesalahan koneksi';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Provider Login
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final response = await AuthServices.login(username, password);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['success'] == true) {
          final token = data['data']?['token'];

          if (token != null) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', token);
          }

          _successMessage = data['message'] ?? 'Login berhasil';
          return true;
        }
      }

      if (data['errors'] != null &&
          data['errors'] is List &&
          data['errors'].isNotEmpty) {
        final firstError = data['errors'][0];
        _errorMessage =
            firstError['message'] ?? data['message'] ?? 'Terjadi kesalahan';
      } else {
        _errorMessage = data['message'] ?? 'Login gagal';
      }

      return false;
    } catch (error) {
      _errorMessage = 'Terjadi kesalahan koneksi';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Provider Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token');

    if (token == null) {
      _errorMessage = 'Token tidak ditemukan';
      notifyListeners();
      return;
    }

    final response = await AuthServices.logout();

    final data =jsonDecode(response.body);

    if (response.statusCode == 200) {
      await prefs.remove('token');
      _successMessage = data ['message'] ?? 'Logout berhasil';
    } else {
      _errorMessage = data['message'] ?? 'Terjadi kesalahan';
    }

    notifyListeners();
  }

  // Provider Get Profile
  Future<void> getProfile() async {
   final prefs = await SharedPreferences.getInstance();
   final token = prefs.getString('token');

   if (token == null) {
    _errorMessage = 'Token tidak ditemukan';
    notifyListeners();
    return;
   }

   try {
    final result = await AuthServices.getProfile();
    _profile = result;
     notifyListeners();
     _successMessage = 'Profile berhasil dibuat';

   } catch(e) {
    _errorMessage = e.toString();
   }

   notifyListeners();
  }

}
