


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/global/environments.dart';
import 'package:myapp/models/auth_response.dart';
import 'package:myapp/models/complete_profile_response.dart';
import 'package:myapp/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {


  late User user;
  bool _isAuthenticating = false;
  bool _isSavingProfile = false;

  final _storage = const FlutterSecureStorage();

  bool get isAuthenticating => _isAuthenticating;
  set isAuthenticating( bool value ) {
    _isAuthenticating = value;
    notifyListeners();
  }

  bool get isSavingProfile => _isSavingProfile;
  set isSavingProfile( bool value ) {
    _isSavingProfile = value;
    notifyListeners();
  }

  // Getters token staticos
  static Future<String> getToken() async {
    const _storage = FlutterSecureStorage();
    final accessToken = await _storage.read(key: 'accessToken');
    return accessToken!;
  }

  static Future removeToken() async {
    const _storage = FlutterSecureStorage();
    await _storage.delete(key: 'accessToken');
  }


  Future<AuthResponse> login( String email, String password ) async {
    print(Environments.apiUrl);

    isAuthenticating = true;

    final data = {
      'email': email,
      'password': password,
      'entity': 'customer'
    };


    final resp = await http.post( Uri.parse( '${ Environments.apiUrl }/auth/login'), 
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    isAuthenticating = false;

    final authResponse = authResponseFromJson( resp.body );

    if ( resp.statusCode == 200 ) {
      user = authResponse.user!;
      await _saveToken( authResponse.accessToken! );
    }

    return authResponse;
  }




  Future<AuthResponse> register( String name, String email, String password ) async {

    isAuthenticating = true;

    final data = {
      'name': name,
      'email': email,
      'password': password,
      'entity': 'customer',
    };


    final resp = await http.post( Uri.parse( '${ Environments.apiUrl }/auth/register'), 
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );


    isAuthenticating = false;

    final authResponse = authResponseFromJson( resp.body );

    if ( resp.statusCode == 200 ) {
      user = authResponse.user!;
      await _saveToken( authResponse.accessToken! );
    }

    return authResponse;
  }




  Future<CompleteProfileResponse> completeProfile( dynamic data ) async {

   isSavingProfile = true;

    final resp = await http.post( Uri.parse( '${ Environments.apiUrl }/customer/complete_profile'), 
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );


    isSavingProfile = false;

    print(resp.body);

    final completeProfileResponse = completeProfileResponseFromJson( resp.body );
  
    return completeProfileResponse;
  }




  Future<bool> isLoggedIn() async {

    final accessToken = await _storage.read(key: 'accessToken');
    final resp = await http.get(
        Uri.parse('${Environments.apiUrl}/auth/renew/customer'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${accessToken ?? ''}',
        },
      );
      try {
        final authResponse = authResponseFromJson( resp.body );

        if ( authResponse.status) {
          user = authResponse.user!;
          await _saveToken( authResponse.accessToken! );
        } else {
          logout();
        }
        return authResponse.status;

      } catch (e) {
          logout();
          return false;
      }
   
  }



  Future _saveToken( String accessToken ) async {
    await _storage.write(key: 'accessToken', value: accessToken);
  }

  Future logout() async {
    await _storage.delete(key: 'accessToken');
  }

}