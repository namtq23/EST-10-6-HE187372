import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/user.dart';

part 'user_repository.g.dart';

@riverpod
UserRepository userRepository(Ref ref) {
  return UserRepository();
}

@riverpod
Future<List<User>> fetchUsersList(Ref ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.fetchUsers();
}

class UserRepository {
  final http.Client _client;

  UserRepository({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches the list of all users from JSONPlaceholder API
  Future<List<User>> fetchUsers() async {
    final response = await _client.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
          'Failed to fetch users: status code ${response.statusCode}');
    }
  }

  /// Fetches a single user by their ID from JSONPlaceholder API
  Future<User> fetchUserById(int id) async {
    final response = await _client.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users/$id'),
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception(
          'Failed to fetch user with id $id: status code ${response.statusCode}');
    }
  }

  /// Creates a new user via POST request
  Future<User> createUser(User user) async {
    final response = await _client.post(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create user: status code ${response.statusCode}');
    }
  }

  /// Updates an existing user via PUT request
  Future<User> updateUser(User user) async {
    final response = await _client.put(
      Uri.parse('https://jsonplaceholder.typicode.com/users/${user.id}'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to update user: status code ${response.statusCode}');
    }
  }

  /// Deletes a user via DELETE request
  Future<void> deleteUser(int id) async {
    final response = await _client.delete(
      Uri.parse('https://jsonplaceholder.typicode.com/users/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user: status code ${response.statusCode}');
    }
  }
}
