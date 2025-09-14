import "package:dio/dio.dart";
import "package:flutter/material.dart";

///Represents the custom Exception used to distinguish the error on API call
class DioException implements Exception {
  final String message;
  DioException(this.message);
}

/// Represents a user's basic data with a [name] and [email].
///
/// Can be created manually using the constructor, or parsed from JSON
/// using [UserData.fromJson]. You can also fetch a list of users
/// from a remote API using [UserData.fetchUsers].
class UserData {
  /// The user's name.
  final String name;

  /// The user's email address.
  final String email;

  /// Creates a [UserData] instance with a required [name] and [email].
  const UserData({required this.name, required this.email});

  /// Creates a [UserData] instance from a JSON map.
  ///
  /// Expects a map with keys `"name"` and `"email"`, both being strings.
  ///
  /// Throws a [UserDataException] if either field is missing or invalid.
  factory UserData.fromJson(Map<String, dynamic> json) {
    //save the "name" from [json] to the local variable name
    final name = json["name"];
    //save the "email" from [json] to the local variable email
    final email = json["email"];
    //check if the name AND the email are string
    if (name is String && email is String) {
      //Generate the UserData object with the new variables
      return UserData(name: name, email: email);
    }
    //Throw [UserDataException], so it can be collected later, in the case
    //the condition above fails
    throw UserDataException("The name or email are missing or not strings");
  }

  /// Fetches a list of users from a remote API.
  ///
  /// Makes an HTTP GET request to
  /// `https://jsonplaceholder.typicode.com/users`.
  ///
  /// Returns a [List<UserData>] on success.
  ///
  /// - Logs and skips entries if they contain invalid data.
  /// - Throws `"Something went wrong: ${error}"` if the request fails.
  static Future<List<UserData>> fetchUsers() async {
    try {
      //Save the [Response] from [Dio]'s get call
      final response = await Dio().get(
        "https://jsonplaceholder.typicode.com/users",
        options: Options(headers: {"Accept": "application/json"}),
      );
      if (response.statusCode != 200) {
        throw DioException(
          "Connection error status code:${response.statusCode}",
        );
      }
      final data = response.data;
      //Check if the response is not a List
      if (data is! List) {
        //If true, then throw an exception which will be catch later
        throw const FormatException("reponse is not a");
      }
      final result = <UserData>[];
      for (final e in data) {
        try {
          result.add(UserData.fromJson(e));
        } on UserDataException catch (e) {
          debugPrint(e.message);
          continue;
        }
      }
      return result;
    } catch (e) {
      debugPrint("Error: $e");
      throw UserDataException("Something went wrong: $e");
    }
  }
}

///Represents the custom Exception used to distinguish the error on API call
class UserDataException implements Exception {
  final String message;
  UserDataException(this.message);
}
