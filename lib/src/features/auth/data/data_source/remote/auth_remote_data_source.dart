import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_remote_data_source.g.dart'; // Generated file

@RestApi(baseUrl: "https://example.com/api")
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio, {String baseUrl}) = _AuthRemoteDataSource;

  /// Signup endpoint
  @POST("/signup")
  Future<void> signup(
      @Body() Map<String, dynamic> signupRequest, // Request body
      );

  /// Login endpoint with basic authentication
  @POST("/login")
  Future<void> login(
      @Header("Authorization") String authorization, // For Basic Auth header
      @Body() Map<String, dynamic> loginRequest, // Request body
      );

  /// Logout endpoint
  @POST("/logout")
  Future<void> logout(
      @Header("Authorization") String token, // Bearer Token for auth
      );
}